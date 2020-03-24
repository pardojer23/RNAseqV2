#!/usr/bin/env bash
SCRIPT_DIR=$1
source $HOME/.bashrc
conda activate RNAseqV2
snakemake -s ${SCRIPT_DIR}/RNAseq.smk