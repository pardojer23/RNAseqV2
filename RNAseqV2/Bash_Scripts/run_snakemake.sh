#!/usr/bin/env bash
SCRIPT_DIR=$1
CORES=$2
source ${HOME}/.bashrc
CONDA_SHELL="$(grep -o -m 1 "${HOME}/.*/etc/profile.d/conda.sh" ${HOME}/.bashrc)"
  if [[ -f "${CONDA_SHELL}" ]]; then
    source ${CONDA_SHELL}
  else
    echo "Failed to find conda shell check that ${CONDA_SHELL} exists"
    exit 1
  fi
conda activate RNAseqV2
snakemake -s ${SCRIPT_DIR}/RNAseq.smk --cores ${CORES}