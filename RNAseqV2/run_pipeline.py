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
    def __init__(self, sample_table, gff, fasta, ind, threads, script_dir, output_dir):
        self.sample_table = sample_table
        self.gff = gff
        self.fasta = fasta
        self.index=ind
        self.threads=threads
        self.script_dir = script_dir
        self.output_dir = output_dir

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
                sample_id = os.path.splitext(os.path.basename(getattr(row, "Read1")))[0]
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
                            "samples": self.read_sample_table()}
        for key in experiment_dict["samples"]:
            if experiment_dict["samples"][key]["Read2"] == "":
                experiment_dict["samples"][key].setdefault("Paired", False)
            else:
                experiment_dict["samples"][key].setdefault("Paired", True)
            DateTime = (dateparser.parse(experiment_dict["samples"][key]["Date"] +
                                         "," + experiment_dict["samples"][key]["Time"]))

            experiment_dict["samples"][key].setdefault("DateTime", DateTime)
        return dict(experiment_dict)

    def write_json_experiment(self):
        experiment_dict = self.get_experiment_dict()
        with open("experiment_config.txt", "w+") as outfile:
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
        parser.add_argument("-o", "--output", help="Path to output directory")
        args = parser.parse_args()
        sample_table = args.sample_table
        gff = args.gff
        fasta = args.fasta
        index = args.index
        threads = args.threads
        script_dir = args.script_dir
        output_dir = args.output
        my_experiment = Experiment(sample_table, gff, fasta, index, threads, script_dir, output_dir)
        if not os.path.exists(sample_table):
            print("{0}: Generating empty sample table...\n"
                  "Please fill in sample information before continuing".format(datetime.now()))
            my_experiment.generate_sample_table()
            exit()
        my_experiment.write_json_experiment()
        subprocess.run(["bash", script_dir+"/Bash_Scripts/run_snakemake.sh",script_dir])

if __name__ == "__main__":
        main()

