#!/usr/bin/env bash
TXIMPORT=$1
source $HOME/.bashrc
conda activate tximport
Rscript ${TXIMPORT}
conda deactivate