#!/usr/bin/env bash

conda update -y conda
conda env create --file ./RNAseqV2/envs/salmon.yml
conda env create --file ./RNAseqV2/envs/trimmomatic.yml
conda env create --file ./RNAseqV2/envs/tximport.yml
conda env create --file ./RNAseqV2/envs/RNAseqV2.yml

source activate tximport
Rscript ./RNAseqV2/R_Scripts/Install.r
source deactivate