#!/usr/bin/env bash
READ1=$1
READ2=$2
READ1N=$(basename ${READ1})
READ2N=$(basename ${READ2})
THREADS=$3
OUTPUT=$4
conda activate fastp
mkdir -p ${OUTPUT}
mkdir -p ${OUTPUT}/fastp_reports

fastp --detect_adapter_for_pe \
-i ${READ1} \
-I ${READ2} \
-o ${OUTPUT}/${READ1N}.trimmed \
-O ${OUTPUT}/${READ2N}.trimmed \
--json ${OUTPUT}/${READ1N}_fastp.json \
--html ${OUTPUT}/fastp_reports/${READ1N}_fastp.html \
--thread ${THREADS}


