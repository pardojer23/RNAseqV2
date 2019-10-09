#!/usr/bin/env bash
READ1=$1
READ2=$2
READ1N=$(basename ${READ1})
READ2N=$(basename ${READ2})
THREADS=$3
ADAPTERS=$4
OUTPUT=$5
mkdir -p ${OUTPUT}
trimmomatic PE -threads ${THREADS} -phred33 -trimlog ${OUTPUT}/${READ1N}.trimlog \
${READ1} ${READ2} \
${OUTPUT}/${READ1N}.trimmed ${OUTPUT}/${READ1N}.unpaired \
${OUTPUT}/${READ2N}.trimmed ${OUTPUT}/${READ2N}.unpaired \
ILLUMINACLIP:${ADAPTERS}:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36

