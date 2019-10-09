#!/usr/bin/env bash
READ1=$1
READ1N=$(basename ${READ1})
INDEX=$2
THREADS=$3
OUTPUT=$4
salmon quant -i ${INDEX} -l A --threads ${THREADS} \
-r ${READ1} \
--validateMappings --seqBias --gcBias \
-o ${OUTPUT}/${READ1N}_salmon