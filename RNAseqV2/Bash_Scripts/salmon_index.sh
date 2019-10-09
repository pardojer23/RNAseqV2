#!/usr/bin/env bash
FASTA=$1
INDEX=$2
OUTPUT=$3
cd ${OUTPUT}
salmon index -t ${FASTA} -i ${INDEX}