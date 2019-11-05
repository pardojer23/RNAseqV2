#!/usr/bin/env bash
SCRIPT_DIR=$1
conda activate RNAseqV2
snakemake -s ${SCRIPT_DIR}/RNAseq.smk