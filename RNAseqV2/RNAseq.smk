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
                                                            experiment_dict["index"],
                                                            experiment_dict["samples"][sample]["Paired"],
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
                                                            experiment_dict["index"],
                                                            experiment_dict["samples"][sample]["Paired"],
                                                            experiment_dict["fasta"],
                                                            experiment_dict["threads"],
                                                            experiment_dict["script_dir"],
                                                            experiment_dict["output_dir"]))
    return object_dict

experiment_dict = read_config("experiment_config.txt")
my_experiment = RNAseqFunctions.RNAseq_exp(experiment_dict["index"],
                                           experiment_dict["threads"],
                                           experiment_dict["fasta"],
                                           experiment_dict["gff"],
                                           experiment_dict["script_dir"],
                                           experiment_dict["output_dir"],
                                           experiment_dict["trimmomatic"])
object_dict = get_input_objects(experiment_dict)
samples = [os.path.basename(object_dict[key].sample_dict["Read1"]) for key in object_dict.keys()]
output_directory=[os.path.dirname(object_dict[key].sample_dict["Read1"]) for key in object_dict.keys()]
sample_object_hash = {os.path.basename(object_dict[key].sample_dict["Read1"]) : object_dict[key].sample_dict["SampleID"] for key in object_dict.keys()}
print(samples)
print(sample_object_hash)
#
rule all:
    input:
         experiment_dict["output_dir"]+"/txi.RData"

if experiment_dict["trimmomatic"] is True:
    rule trimmomatic:
        input:
            expand("{directory}/{sample}", directory=output_directory, sample=samples)
        output:
            experiment_dict["output_dir"]+"/{sample}.trimmed"
        run:
            # print(sample_object_hash.keys())
            print("--INFO-- {0}: Running trimmomatic for sample {1}".format(datetime.now(), wildcards.sample))
            object_dict[sample_object_hash[wildcards.sample]].run_trimmomatic()
else:
    rule fastp:
        input:
             expand("{directory}/{sample}", directory=output_directory, sample=samples)
        output:
              experiment_dict["output_dir"]+"/{sample}.trimmed"
        run:
            # print(sample_object_hash.keys())
            print("--INFO-- {0}: Running fastp for sample {1}".format(datetime.now(), wildcards.sample))
            object_dict[sample_object_hash[wildcards.sample]].run_fastp()

rule salmon_index:
    input:
         experiment_dict["fasta"]
    output:
          experiment_dict["output_dir"]+"/"+experiment_dict["index"]

    run:
        print("--INFO-- {0}: Running Salmon index on transcriptome file {1}".format(
            datetime.now(), experiment_dict["fasta"]))
        my_experiment.salmon_index()

rule salmon_quant:
    input:
         fastq = expand(experiment_dict["output_dir"]+"/{sample}.trimmed", sample=samples),
         index = experiment_dict["output_dir"]+"/"+experiment_dict["index"]
    output:
          experiment_dict["output_dir"]+"/{sample}.trimmed_salmon"

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
         samples = expand((experiment_dict["output_dir"]+"/{sample}.trimmed_salmon"), sample=samples)
    output:
          experiment_dict["output_dir"]+"/txi.RData"
    run:
        my_experiment.run_tximport()