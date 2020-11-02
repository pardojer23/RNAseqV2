#!/usr/bin/env bash
READ1=$1
READ2=$2
READ1N=$(basename ${READ1})
READ2N=$(basename ${READ2})
THREADS=$3
ADAPTERS=$4
OUTPUT=$5
source $HOME/.bashrc
CONDA_SHELL="$(grep -o -m 1 "${HOME}/.*/etc/profile.d/conda.sh" $HOME/.bashrc)"
  if [[ -f "${CONDA_SHELL}" ]]; then
    source ${CONDA_SHELL}
  else
    echo "Failed to find conda shell check that ${CONDA_SHELL} exists"
    exit 1
  fi
conda activate trimmomatic
mkdir -p ${OUTPUT}
mkdir -p ${OUTPUT}/trimmed_reads
trimmomatic PE -threads ${THREADS} -phred33 -trimlog ${OUTPUT}/${READ1N}.trimlog \
${READ1} ${READ2} \
${OUTPUT}/trimmed_reads/${READ1N}.trimmed.fq ${OUTPUT}/trimmed_reads/${READ1N}.unpaired \
${OUTPUT}/trimmed_reads/${READ2N}.trimmed.fq ${OUTPUT}/trimmed_reads/${READ2N}.unpaired \
ILLUMINACLIP:${ADAPTERS}:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36

