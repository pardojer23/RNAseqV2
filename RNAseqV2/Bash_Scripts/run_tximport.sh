#!/usr/bin/env bash
TXIMPORT=$1
OUTPUT_DIR=$2
conda activate tximport
Rscript ${TXIMPORT} ${OUTPUT_DIR}
conda deactivate