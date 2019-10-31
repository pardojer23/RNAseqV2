#!/usr/bin/env bash
TXIMPORT=$1
conda activate tximport
Rscript ${TXIMPORT}
conda deactivate