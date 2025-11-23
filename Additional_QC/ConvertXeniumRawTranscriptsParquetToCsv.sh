#!/bin/bash
#SBATCH --job-name=parquet2csv_xenium
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --time=00:30:00
#SBATCH --output=/path/parquet2csv-%x-%j.out   # <-- EDIT: log directory
#SBATCH --error=/path/parquet2csv-%x-%j.err    # <-- EDIT: log directory

set -euo pipefail

#########################
# User-configurable paths
# EDIT all instances of '/path' below
#########################

# Path to the (single) transcripts parquet file
PARQ="/path/transcripts.parquet"     # <-- EDIT

# Output directory for the CSV
OUTDIR="/path/output_dir"            # <-- EDIT

#########################
# Setup
#########################

mkdir -p "${OUTDIR}"

echo "Input parquet: ${PARQ}"
echo "Output dir:    ${OUTDIR}"

# Check for the parquet file
if [[ ! -f "${PARQ}" ]]; then
    echo "ERROR: transcripts.parquet not found at: ${PARQ}" >&2
    exit 1
fi

# Derive output CSV name
PARQ_BASENAME=$(basename "${PARQ}")
CSV_BASENAME="${PARQ_BASENAME%.parquet}.csv"
OUTCSV="${OUTDIR}/${CSV_BASENAME}"

echo "Output CSV:    ${OUTCSV}"

#########################
# Conda environment
# EDIT this block to match your cluster / setup
#########################

# Example for an environment with pyarrow + pandas installed:
# module load <your_miniconda_module>
# source "$(conda info --base)/etc/profile.d/conda.sh"
# conda activate parquet_env

module load CBI miniconda3/23.3.1-0-py39   # <-- UCSF-specific; others should change/remove
conda activate parquet_env                 # <-- EDIT env name if needed

# Export paths for inline Python
export PARQ_PATH="${PARQ}"
export OUT_CSV="${OUTCSV}"

#########################
# Parquet → CSV (chunked)
#########################

python - <<'PYCODE'
import os
import pyarrow.parquet as pq
import pyarrow.csv as pacsv

parq_path = os.environ["PARQ_PATH"]
out_csv   = os.environ["OUT_CSV"]

print(f"Reading parquet: {parq_path}")
print(f"Writing csv:     {out_csv}")

pf = pq.ParquetFile(parq_path)

# Remove old file if exists (avoid writing headers twice)
try:
    os.remove(out_csv)
except FileNotFoundError:
    pass

write_header = True
with open(out_csv, "wb") as sink:
    for rg in range(pf.num_row_groups):
        table = pf.read_row_group(rg)  # read one row group at a time
        opts = pacsv.WriteOptions(include_header=write_header)
        pacsv.write_csv(table, sink, write_options=opts)
        write_header = False

print(f"Done: {out_csv}")
PYCODE

echo "Conversion finished."