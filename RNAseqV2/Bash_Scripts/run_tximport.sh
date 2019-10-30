#!/usr/bin/env bash
TXIMPORT=$1
source activate tximport
RScript ${TXIMPORT}
conda deactivate