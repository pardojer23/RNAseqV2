#!/usr/bin/env bash
SCRIPT_DIR=$1
source activate RNAseqV2
conda init bash
source ~/.bashrc
snakemake -s ${SCRIPT_DIR}/RNAseq.smk --use-conda