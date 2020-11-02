#!/usr/bin/env bash --init-file

conda update --all
conda init bash


function update_env {
  if conda env list | grep -q $1; then
     echo "updating the existing conda environment ${1}"
     conda env update --prefix ./${1} \
    --file ./RNAseqV2/envs/${1}.yml --prune
  else
    echo "creating a new conda environment ${1}"
    conda env create --file ./RNAseqV2/envs/${1}.yml
  fi
}

update_env tximport
update_env salmon
update_env trimmomatic
update_env fastp
update_env RNAseqV2


FILE=~/.bashrc
if [-f "$FILE"]; then
  source $HOME/.bashrc
else
  touch $HOME/.bashrc
  conda init bash
  source $HOME/.bashrc
fi

conda activate tximport
Rscript ./RNAseqV2/R_Scripts/Install.r
conda deactivate


