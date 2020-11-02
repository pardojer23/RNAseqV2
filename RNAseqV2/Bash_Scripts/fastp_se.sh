#!/usr/bin/env bash
READ1=$1
READ1N=$(basename ${READ1})
THREADS=$2
OUTPUT=$3
source $HOME/.bashrc
CONDA_SHELL="$(grep -o -m 1 "${HOME}/.*/etc/profile.d/conda.sh" $HOME/.bashrc)"
  if [[ -f "${CONDA_SHELL}" ]]; then
    source ${CONDA_SHELL}
  else
    echo "Failed to find conda shell check that ${CONDA_SHELL} exists"
    exit 1
  fi
conda activate fastp
mkdir -p ${OUTPUT}
mkdir -p ${OUTPUT}/fastp_reports
mkdir -p ${OUTPUT}/trimmed_reads
fastp -i ${READ1} \
-o ${OUTPUT}/trimmed_reads/${READ1N}.trimmed.fq \
--json ${OUTPUT}/fastp_reports/${READ1N}_fastp.json \
--html ${OUTPUT}/fastp_reports/${READ1N}_fastp.html \
--thread ${THREADS}