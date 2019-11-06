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
mkdir -p ${OUTPUT}/trimmed_reads

fastp --detect_adapter_for_pe \
-i ${READ1} \
-I ${READ2} \
-o ${OUTPUT}/trimmed_reads/${READ1N}.trimmed \
-O ${OUTPUT}/trimmed_reads/${READ2N}.trimmed \
--json ${OUTPUT}/fastp_reports/${READ1N}_fastp.json \
--html ${OUTPUT}/fastp_reports/${READ1N}_fastp.html \
--thread ${THREADS}


