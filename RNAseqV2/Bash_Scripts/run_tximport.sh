#!/usr/bin/env bash
TXIMPORT=$1
source ${HOME}/.bashrc
CONDA_SHELL="$(grep -o -m 1 "${HOME}/.*/etc/profile.d/conda.sh" ${HOME}/.bashrc)"
  if [[ -f "${CONDA_SHELL}" ]]; then
    source ${CONDA_SHELL}
  else
    echo "Failed to find conda shell check that ${CONDA_SHELL} exists"
    exit 1
  fi
conda activate tximport
Rscript ${TXIMPORT}
conda deactivate