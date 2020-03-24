#!/usr/bin/env bash
READ1=$1
READ1N=$(basename ${READ1})
THREADS=$2
OUTPUT=$3
source $HOME/.bashrc
conda activate fastp
mkdir -p ${OUTPUT}
mkdir -p ${OUTPUT}/fastp_reports
mkdir -p ${OUTPUT}/trimmed_reads
fastp -i ${READ1} \
-o ${OUTPUT}/trimmed_reads/${READ1N}.trimmed.fq \
--json ${OUTPUT}/fastp_reports/${READ1N}_fastp.json \
--html ${OUTPUT}/fastp_reports/${READ1N}_fastp.html \
--thread ${THREADS}