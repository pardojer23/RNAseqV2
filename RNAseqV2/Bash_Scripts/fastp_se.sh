#!/usr/bin/env bash
READ1=$1
READ1N=$(basename ${READ1})
THREADS=$2
OUTPUT=$3
conda activate fastp
mkdir -p ${OUTPUT}
mkdir -p ${OUTPUT}/fastp_reports

fastp -i ${READ1} \
-o ${OUTPUT}/${READ1N}.trimmed \
--json ${OUTPUT}/${READ1N}_fastp.json \
--html ${OUTPUT}/fastp_reports/${READ1N}_fastp.html \
--thread ${THREADS}