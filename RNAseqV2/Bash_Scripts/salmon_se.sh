#!/usr/bin/env bash
READ1=$1
READ1N=$(basename ${READ1})
INDEX=$2
THREADS=$3
OUTPUT=$4
source $HOME/.bashrc
conda activate salmon
cd ${OUTPUT}
mkdir -p ${OUTPUT}/salmon_quant
salmon quant -i ${INDEX} -l A --threads ${THREADS} \
-r ${READ1} \
--validateMappings --seqBias --gcBias \
-o ${OUTPUT}/salmon_quant/${READ1N}_salmon