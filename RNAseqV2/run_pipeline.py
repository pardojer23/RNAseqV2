"""
Pipeline to conduct RNAseq data analysis.
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
from datetime import datetime
import argparse
import pandas as pd
import numpy as np
import os
import dateparser
import json
import subprocess

class MyEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, np.int64):
            return int(o)
        elif isinstance(o, np.floating):
            return float(o)
        elif isinstance(o, datetime):
            return str(o)


class Experiment:
    def __init__(self, sample_table, gff, fasta, ind, threads, script_dir, output_dir, trimmomatic, deseq2, ref_levels):
        self.sample_table = sample_table
        self.gff = gff
        self.fasta = fasta
        self.index=ind
        self.threads=threads
        self.script_dir = script_dir
        self.output_dir = output_dir
        self.trimmomatic= trimmomatic
        self.deseq2 = deseq2
        self.ref_levels = ref_levels

    def generate_sample_table(self):
        if not os.path.exists(self.sample_table):
            with open(self.sample_table, "w+") as sampleTable:
                sampleTable.write("Read1,"
                                  "Read2,"
                                  "Replicate,"
                                  "Tissue,"
                                  "Time,"
                                  "Date,"
                                  "Condition,"
                                  "Collector,"
                                  "Location,"
                                  "Platform\n")

    def read_sample_table(self):
        sample_dict = {}
        sample_table = pd.read_csv(self.sample_table)
        sample_table.fillna("", inplace=True)
        for row in sample_table.itertuples(index=True, name="Pandas"):
                sample_id = os.path.basename(getattr(row, "Read1"))
                sample_dict.setdefault(sample_id, {"SampleID": sample_id,
                                                   "Read1": getattr(row, "Read1"),
                                                   "Read2": getattr(row, "Read2"),
                                                   "Replicate": getattr(row, "Replicate"),
                                                   "Tissue": getattr(row, "Tissue"),
                                                   "Time": getattr(row, "Time"),
                                                   "Date": getattr(row, "Date"),
                                                   "Condition": getattr(row, "Condition"),
                                                   "Collector": getattr(row, "Collector"),
                                                   "Location": getattr(row, "Location"),
                                                   "Platform": getattr(row, "Platform")})

        return sample_dict

    def get_experiment_dict(self):
        experiment_dict = {"gff": self.gff,
                            "fasta": self.fasta,
                            "index": self.index,
                            "threads": self.threads,
                            "script_dir": self.script_dir,
                            "output_dir": self.output_dir,
                            "trimmomatic": self.trimmomatic,
                            "deseq2": self.deseq2,
                            "ref_levels": self.ref_levels,
                            "samples": self.read_sample_table()}
        for key in experiment_dict["samples"]:
            if experiment_dict["samples"][key]["Read2"] == "":
                experiment_dict["samples"][key].setdefault("Paired", False)
            else:
                experiment_dict["samples"][key].setdefault("Paired", True)
            DateTime = (dateparser.parse(experiment_dict["samples"][key]["Date"] +
                                         "," + experiment_dict["samples"][key]["Time"]))
            if DateTime is None:
                DateTime = ""




            experiment_dict["samples"][key].setdefault("DateTime", DateTime)
        return dict(experiment_dict)

    def write_json_experiment(self):
        experiment_dict = self.get_experiment_dict()
        with open("experiment_config.json", "w+") as outfile:
            json.dump(experiment_dict, outfile, cls=MyEncoder, indent=4)





def main():
        print("Started at {0}".format(datetime.now()))
        parser = argparse.ArgumentParser()
        parser.add_argument("-s", "--sample_table", help="Path to sample table")
        parser.add_argument("-g", "--gff", help="Path to reference annotation", default=None)
        parser.add_argument("-f", "--fasta", help="Path to reference transcriptome", default=None)
        parser.add_argument("-i", "--index", help="Basename for transcriptome index", default="myTranscriptIndex")
        parser.add_argument("-t", "--threads", help="number of multiprocessing threads", default="1")
        parser.add_argument("-sd", "--script_dir", help="path to the directory where the package is installed", default="./")
        parser.add_argument("-o", "--output_dir", help="Path to output directory")
        parser.add_argument("-T", "--trimmomatic", help="Set to True to use Trimmomatic instead of fastp", default="false")
        parser.add_argument("-de", "--differential_expression", help="Set to True to run differential expression", default="false")
        parser.add_argument("-r", "--reference_levels", help="Enter reference Exp conditions seperated by commas", default=None)
        parser.add_argument("-c", "--cluster", help="Set to true in order to submit jobs to SLURM cluster", default="false")
        args = parser.parse_args()
        sample_table = args.sample_table
        gff = args.gff
        fasta = args.fasta
        index = args.index
        threads = args.threads
        script_dir = args.script_dir
        output_dir = args.output_dir
        trimmomatic = args.trimmomatic
        differential_exp = args.differential_expression
        ref_levels = args.reference_levels
        cluster = args.cluster
        truth = ["t", "true", "y", "yes", "1", "on"]
        if trimmomatic.lower() in truth:
            trim = True
        else:
            trim = False
        if differential_exp.lower() in truth:
           deseq2 = True
        else:
            deseq2 = False
        if cluster.lower() in truth:
            slurm = True
        else:
            slurm = False
        my_experiment = Experiment(sample_table,
                                   gff,
                                   fasta,
                                   index,
                                   threads,
                                   script_dir,
                                   output_dir,
                                   trim,
                                   deseq2,
                                   ref_levels)
        if not os.path.exists(sample_table):
            print("{0}: Generating empty sample table...\n"
                  "Please fill in sample information before continuing".format(datetime.now()))
            my_experiment.generate_sample_table()
            exit()
        if os.path.isfile(sample_table):
            my_experiment.write_json_experiment()
        else:
            print("{0} ERROR: The path {1} is not a file!".format(datetime.now(), sample_table))
            exit(1)
        if slurm is True:
            subprocess.run(["bash", "-i", script_dir+"/Bash_Scripts/run_snakemake_cluster.sh", script_dir])

        else:
            subprocess.run(["bash", "-i", script_dir+"/Bash_Scripts/run_snakemake.sh", script_dir])

if __name__ == "__main__":
        main()


