#!/usr/bin/env bash
READ1=$1
READ2=$2
READ1N=$(basename ${READ1})
READ2N=$(basename ${READ2})
THREADS=$3
OUTPUT=$4
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

fastp --detect_adapter_for_pe \
-i ${READ1} \
-I ${READ2} \
-o ${OUTPUT}/trimmed_reads/${READ1N}.trimmed.fq \
-O ${OUTPUT}/trimmed_reads/${READ2N}.trimmed.fq \
--json ${OUTPUT}/fastp_reports/${READ1N}_fastp.json \
--html ${OUTPUT}/fastp_reports/${READ1N}_fastp.html \
--thread ${THREADS}


