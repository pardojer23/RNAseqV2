#!/usr/bin/env bash --init-file

conda update --all
conda init bash
conda env create --file ./RNAseqV2/envs/salmon.yml
conda env create --file ./RNAseqV2/envs/trimmomatic.yml
conda env create --file ./RNAseqV2/envs/fastp.yml
conda env create --file ./RNAseqV2/envs/tximport.yml
conda env create --file ./RNAseqV2/envs/RNAseqV2.yml

FILE=~/.bashrc
if [-f "$FILE"]; then
  source $HOME/.bashrc
else
  touch $HOME/.bashrc
  conda init bash
  source $HOME/.bashrc
fi

conda activate tximport
Rscript ./RNAseqV2/R_Scripts/Install.r
conda deactivate


