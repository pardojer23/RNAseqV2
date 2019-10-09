#!/usr/bin/env bash
READ1=$1
READ2=$2
READ1N=$(basename ${READ1})
INDEX=$3
THREADS=$4
OUTPUT=$5
salmon quant -i ${INDEX} -l A --threads ${THREADS} \
-1 ${READ1} \
-2 ${READ2} \
--validateMappings --seqBias --gcBias \
-o ${OUTPUT}/${READ1N}_salmon