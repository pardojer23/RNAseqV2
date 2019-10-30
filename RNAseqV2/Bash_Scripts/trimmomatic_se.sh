#!/usr/bin/env bash
READ1=$1
READ1N=$(basename ${READ1})
THREADS=$2
ADAPTERS=$3
OUTPUT=$4
source activate trimmomatic
mkdir -p ${OUTPUT}
trimmomatic SE -threads ${THREADS} -phred33 -trimlog ${OUTPUT}/${READ1N}.trimlog \
${READ1} \
${OUTPUT}/${READ1N}.trimmed \
ILLUMINACLIP:${ADAPTERS}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
