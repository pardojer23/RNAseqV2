#!/usr/bin/env bash
DESEQ2=$1
REFLEVELS=$2
conda activate tximport
Rscript ${DESEQ2} ${REFLEVELS}
conda deactivate