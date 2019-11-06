"""
Snakemake pipeline to conduct RNAseq data analysis.
Copyright (C) 2019  Jeremy Pardo

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see https://www.gnu.org/licenses/.

See README.md for installation and execution instructions


"""
import RNAseqFunctions
import json
import os
from datetime import datetime
def read_config(json_file):
    with open(json_file, "r") as json_file:
        experiment_dict = json.load(json_file)
    return experiment_dict
#print(read_config("experiment_config.txt"))



def get_input_objects(experiment_dict):
    object_dict = {}
    experiment_dict = experiment_dict
    for sample in experiment_dict["samples"].keys():
        if experiment_dict["samples"][sample]["Paired"] is True:
            object_dict.setdefault(experiment_dict["samples"][sample]["SampleID"],
                                   RNAseqFunctions.RNAseqPE(experiment_dict["samples"][sample]["SampleID"],
                                                            experiment_dict["samples"][sample]["Read1"],
                                                            experiment_dict["samples"][sample]["Read2"],
                                                            experiment_dict["samples"][sample]["DateTime"],
                                                            experiment_dict["samples"][sample]["Replicate"],
                                                            experiment_dict["samples"][sample]["Tissue"],
                                                            experiment_dict["samples"][sample]["Condition"],
                                                            experiment_dict["samples"][sample]["Paired"],
                                                            experiment_dict["index"],
                                                            experiment_dict["fasta"],
                                                            experiment_dict["threads"],
                                                            experiment_dict["script_dir"],
                                                            experiment_dict["output_dir"]))
        else:
            object_dict.setdefault(experiment_dict["samples"][sample]["SampleID"],
                                   RNAseqFunctions.RNAseqSE(experiment_dict["samples"][sample]["SampleID"],
                                                            experiment_dict["samples"][sample]["Read1"],
                                                            experiment_dict["samples"][sample]["Read2"],
                                                            experiment_dict["samples"][sample]["DateTime"],
                                                            experiment_dict["samples"][sample]["Replicate"],
                                                            experiment_dict["samples"][sample]["Tissue"],
                                                            experiment_dict["samples"][sample]["Condition"],
                                                            experiment_dict["samples"][sample]["Paired"],
                                                            experiment_dict["index"],
                                                            experiment_dict["fasta"],
                                                            experiment_dict["threads"],
                                                            experiment_dict["script_dir"],
                                                            experiment_dict["output_dir"]))
    return object_dict

experiment_dict = read_config("experiment_config.json")
my_experiment = RNAseqFunctions.RNAseq_exp(experiment_dict["index"],
                                           experiment_dict["fasta"],
                                           experiment_dict["gff"],
                                           experiment_dict["threads"],
                                           experiment_dict["script_dir"],
                                           experiment_dict["output_dir"],
                                           experiment_dict["trimmomatic"],
                                           experiment_dict["deseq2"],
                                           experiment_dict["ref_levels"])
object_dict = get_input_objects(experiment_dict)
samples = [os.path.basename(object_dict[key].sample_dict["Read1"]) for key in object_dict.keys()]
output_directory=[os.path.dirname(object_dict[key].sample_dict["Read1"]) for key in object_dict.keys()]
sample_object_hash = {os.path.basename(object_dict[key].sample_dict["Read1"]) : object_dict[key].sample_dict["SampleID"] for key in object_dict.keys()}
print(samples)
print(sample_object_hash)
#
if experiment_dict["deseq2"] is True:
    rule all:
        input:
            experiment_dict["output_dir"]+"/DESeq2.RData"
else:
    rule all:
        input:
            experiment_dict["output_dir"]+"/txi.RData"

if experiment_dict["trimmomatic"] is True:
    rule trimmomatic:
        input:
            expand("{directory}/{sample}", directory=output_directory, sample=samples)
        output:
            experiment_dict["output_dir"]+"/trimmed_reads/{sample}.trimmed"
        run:
            # print(sample_object_hash.keys())
            print("--INFO-- {0}: Running trimmomatic for sample {1}".format(datetime.now(), wildcards.sample))
            object_dict[sample_object_hash[wildcards.sample]].run_trimmomatic()
else:
    rule fastp:
        input:
             expand("{directory}/{sample}", directory=output_directory, sample=samples)
        output:
              experiment_dict["output_dir"]+"/trimmed_reads/{sample}.trimmed.fq"
        run:
            # print(sample_object_hash.keys())
            print("--INFO-- {0}: Running fastp for sample {1}".format(datetime.now(), wildcards.sample))
            object_dict[sample_object_hash[wildcards.sample]].run_fastp()

rule salmon_index:
    input:
         experiment_dict["fasta"]
    output:
          directory(experiment_dict["output_dir"]+"/"+experiment_dict["index"])

    run:
        print("--INFO-- {0}: Running Salmon index on transcriptome file {1}".format(
            datetime.now(), experiment_dict["fasta"]))
        my_experiment.salmon_index()

rule salmon_quant:
    input:
         fastq = expand(experiment_dict["output_dir"]+"/trimmed_reads/{sample}.trimmed.fq", sample=samples),
         index = experiment_dict["output_dir"]+"/"+experiment_dict["index"]
    output:
          experiment_dict["output_dir"]+"/salmon_quant/{sample}.trimmed.fq_salmon/quant.sf"

    run:
        print("--INFO-- {0}: Running Salmon quant for sample {1}".format(datetime.now(), wildcards.sample))
        object_dict[sample_object_hash[wildcards.sample]].run_salmon()
rule tx2gene:
    input:
         experiment_dict["gff"]
    output:
          experiment_dict["output_dir"]+"/tx2gene.txt"
    run:
        my_experiment.get_tx2gene()
rule tximport:
    input:
         tx2gene = experiment_dict["output_dir"]+"/tx2gene.txt",
         samples = expand((experiment_dict["output_dir"]+"/salmon_quant/{sample}.trimmed.fq_salmon/quant.sf"), sample=samples)
    output:
          experiment_dict["output_dir"]+"/txi.RData"
    run:
        my_experiment.run_tximport()
rule deseq2:
    input:
         experiment_dict["output_dir"]+"/txi.RData"
    output:
          experiment_dict["output_dir"]+"/DESeq2.RData"
    run:
        my_experiment.run_deseq2()
