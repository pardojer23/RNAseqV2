#!/usr/bin/env bash

conda update --all
conda env create --file ./RNAseqV2/envs/salmon.yml
conda env create --file ./RNAseqV2/envs/trimmomatic.yml
conda env create --file ./RNAseqV2/envs/fastp.yml
conda env create --file ./RNAseqV2/envs/tximport.yml
conda env create --file ./RNAseqV2/envs/RNAseqV2.yml

source activate tximport
Rscript ./RNAseqV2/R_Scripts/Install.r
conda deactivate
conda init bash
