#!/usr/bin/env bash
SCRIPT_DIR=$1
snakemake -s ${SCRIPT_DIR}/RNAseq.smk --use-conda