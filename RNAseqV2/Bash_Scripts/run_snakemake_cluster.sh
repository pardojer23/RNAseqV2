#!/usr/bin/env bash
SCRIPT_DIR=$1
conda activate RNAseqV2
snakemake -s ${SCRIPT_DIR}/RNAseq.smk -j 500 \
--cluster-config ${SCRIPT_DIR}/cluster.json \
--latency-wait 30 \
--cluster 'sbatch --mem={cluster.mem} -t {cluster.time} -c {cluster.n}'