"""
Functions to conduct RNAseq data analysis.
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
import subprocess
import os
class RNAseq_exp():

    def __init__(self, ind, fasta, gff, threads, script_dir, output_dir, trim, deseq2, ref_levels):
        self.exp_params = {"Index": ind,
                           "Fasta": fasta,
                           "GFF": gff,
                           "Threads": threads,
                           "Script_dir": script_dir,
                           "Output_dir": output_dir,
                           "Trimmomatic": trim,
                           "DESeq2": deseq2,
                           "Ref_Levels": ref_levels}

    def salmon_index(self):
        if os.path.exists(self.exp_params["Output_dir"]+"/"+self.exp_params["Index"]):
            print("Index {0} already exists!".format(
                self.exp_params["Output_dir"]+"/"+self.exp_params["Index"]))
        else:
            subprocess.run(["bash", "-i", self.exp_params["Script_dir"]+"/Bash_Scripts/salmon_index.sh",
                            self.exp_params["Fasta"],
                            self.exp_params["Index"],
                            self.exp_params["Output_dir"]])
    def get_tx2gene(self):
        output_dir = self.exp_params["Output_dir"]
        with open(self.exp_params["GFF"],"r") as gff:
            with open(output_dir+"/tx2gene.txt", "w+" ) as tx2gene:
                for line in gff:
                    if not line.startswith("#"):
                        my_line = line.strip().split("\t")
                        if my_line[2] == "mRNA":
                            id_line = my_line[8].split(";")
                            for i in range(len(id_line)):
                                if id_line[i].startswith("ID="):
                                    transcript_id = id_line[i].replace("ID=", "")
                                elif id_line[i].startswith("Parent="):
                                    gene_id = id_line[i].replace("Parent=", "")
                            tx2gene.write(transcript_id + "\t" + gene_id + "\n")

    def run_tximport(self):
        subprocess.run(["bash", "-i", self.exp_params["Script_dir"]+"/Bash_Scripts/run_tximport.sh",
                        self.exp_params["Script_dir"]+"/R_Scripts/Tximport.r"])

    def run_deseq2(self):
        subprocess.run(["bash", "-i", self.exp_params["Script_dir"]+"/Bash_Scripts/run_deseq2.sh",
                       self.exp_params["Script_dir"]+"/R_Scripts/DESeq2.r",
                        self.exp_params["Ref_Levels"]])



class RNAseq():
    def __init__(self, sample_id, read1, read2, datetime, replicate, tissue, condition, paired,
                 ind, fasta, threads, script_dir, output_dir):
        self.sample_dict = {"SampleID": sample_id,
                            "Read1": read1,
                            "Read2": read2,
                            "DateTime": datetime,
                            "Replicate": replicate,
                            "Tissue": tissue,
                            "Condition": condition,
                            "Paired": paired}
        self.exp_params = {"Index": ind,
                           "Threads": threads,
                           "Fasta": fasta,
                           "Script_dir": script_dir,
                           "Output_dir": output_dir}



class RNAseqSE(RNAseq):
    def __init__(self, sample_id, read1, read2, datetime, replicate, tissue, condition, paired,
                 ind, fasta, threads, script_dir, output_dir):
        super(RNAseqSE, self).__init__(sample_id,
                                       read1,
                                       read2,
                                       datetime,
                                       replicate,
                                       tissue,
                                       condition,
                                       paired,
                                       ind,
                                       fasta,
                                       threads,
                                       script_dir,
                                       output_dir)

    def run_fastp(self):
        subprocess.run(["bash", "-i", self.exp_params["Script_dir"]+"/Bash_Scripts/fastp_se.sh",
                        self.sample_dict["Read1"],
                        self.exp_params["Threads"],
                        self.exp_params["Output_dir"]])

    def run_trimmomatic(self):
        subprocess.run(["bash", "-i", self.exp_params["Script_dir"]+"/Bash_Scripts/trimmomatic_se.sh",
                        self.sample_dict["Read1"],
                        self.exp_params["Threads"],
                        self.exp_params["Script_dir"]+"/Adapters/TruSeq3-SE.fa",
                        self.exp_params["Output_dir"]])

    def run_salmon(self):
        subprocess.run(["bash", "-i", self.exp_params["Script_dir"]+"/Bash_Scripts/salmon_se.sh",
                        self.sample_dict["Read1"],
                        self.exp_params["Index"],
                        self.exp_params["Threads"],
                        self.exp_params["Output_dir"]])


class RNAseqPE(RNAseq):
    def __init__(self, sample_id, read1, read2, datetime, replicate, tissue, condition, paired,
                 ind, fasta, threads, script_dir, output_dir):
        super(RNAseqPE, self).__init__(sample_id,
                                       read1,
                                       read2,
                                       datetime,
                                       replicate,
                                       tissue,
                                       condition,
                                       paired,
                                       ind,
                                       fasta,
                                       threads,
                                       script_dir,
                                       output_dir)

    def run_fastp(self):
        subprocess.run(["bash", "-i", self.exp_params["Script_dir"]+"/Bash_Scripts/fastp_pe.sh",
                        self.sample_dict["Read1"],
                        self.sample_dict["Read2"],
                        self.exp_params["Threads"],
                        self.exp_params["Output_dir"]])

    def run_trimmomatic(self):
        subprocess.run(["bash", "-i", self.exp_params["Script_dir"]+"/Bash_Scripts/trimmomatic_pe.sh",
                        self.sample_dict["Read1"],
                        self.sample_dict["Read2"],
                        self.exp_params["Threads"],
                        self.exp_params["Script_dir"]+"/Adapters/TruSeq3-PE.fa",
                        self.exp_params["Output_dir"]])

    def run_salmon(self):
        # debugging
        print(self.sample_dict["Read1"],
              self.sample_dict["Read2"],
              self.exp_params["Index"],
              self.exp_params["Threads"],
              self.exp_params["Output_dir"])
        subprocess.run(["bash", "-i", self.exp_params["Script_dir"]+"/Bash_Scripts/salmon_pe.sh",
                        self.sample_dict["Read1"],
                        self.sample_dict["Read2"],
                        self.exp_params["Index"],
                        self.exp_params["Threads"],
                        self.exp_params["Output_dir"]])

