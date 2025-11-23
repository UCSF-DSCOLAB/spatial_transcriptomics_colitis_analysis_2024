# Single-cell spatial transcriptomics of fixed, paraffin-embedded biopsies reveals colitis-associated cell networks

This repository contains the code necessary to reproduce the analyses and figures presented in our paper. Because we analyzed nine datasets (seven Xenium, one CosMx, and one MERSCOPE) and performed many analyses repeatedly across datasets, we provide generalized analysis pipelines for each major step. These pipelines can be applied directly to your own data or adapted for use with any of the datasets included in our study.

Our team: Elvira Mennillo, Madison L. Lotstein, Gyehyun Lee, Julian Hou, Vrinda Johri, Donna E. Leet, Christina Ekstrand, Jessica Tsui, Jun Yan He6, Uma Mahadevan, Walter Eckalbar, David Y. Oh, Gabriela K. Fragiadakis, Michael G. Kattah, and Alexis J. Combes.

Our preprint is currently available on bioRxiv and can be accessed [here](https://www.biorxiv.org/content/10.1101/2024.11.11.623014v1).

All analyses were performed in Python, with the exception of the DESeq2 and GSEA analyses, which were run in R. Two Yaml files are provided to recreate the Python conda environments used in this work.

