#!/usr/bin/env bash
READ1=$1
READ2=$2
READ1N=$(basename ${READ1})
INDEX=$3
THREADS=$4
OUTPUT=$5
source ${HOME}/.bashrc
CONDA_SHELL="$(grep -o -m 1 "${HOME}/.*/etc/profile.d/conda.sh" ${HOME}/.bashrc)"
  if [[ -f "${CONDA_SHELL}" ]]; then
    source ${CONDA_SHELL}
  else
    echo "Failed to find conda shell check that ${CONDA_SHELL} exists"
    exit 1
  fi
conda activate salmon
cd ${OUTPUT}
mkdir -p ${OUTPUT}/salmon_quant
salmon quant -i ${INDEX} -l A --threads ${THREADS} \
-1 ${READ1} \
-2 ${READ2} \
--validateMappings --seqBias --gcBias \
-o ${OUTPUT}/salmon_quant/${READ1N}_salmon