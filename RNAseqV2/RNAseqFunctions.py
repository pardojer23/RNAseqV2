import subprocess
import os
class RNAseq_exp:

    def __init__(self, ind, fasta, threads, script_dir, output_dir):

        self.exp_parmas = {"Index": ind,
                       "Threads": threads,
                       "Fasta": fasta,
                       "Script_dir": script_dir,
                       "Output_dir": output_dir}

    def salmon_index(self):
        if os.path.exists(self.exp_parmas["Output_dir"]+"/"+self.exp_parmas["Index"]):
            print("Index {0} already exists!".format(
                self.exp_parmas["Output_dir"]+"/"+self.exp_parmas["Index"]))
        else:
            subprocess.run(["bash", self.exp_parmas["Script_dir"]+"/Bash_Scripts/salmon_index.sh",
                            self.exp_parmas["Fasta"],
                            self.exp_parmas["Index"]],)
class RNAseq:
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
        self.exp_parmas = {"Index": ind,
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

    def run_trimmomatic(self):
        subprocess.run(["bash", self.exp_parmas["Script_dir"]+"/Bash_Scripts/trimmomatic_se.sh",
                        self.sample_dict["Read1"],
                        self.exp_parmas["Threads"],
                        self.exp_parmas["Script_dir"]+"/Adapters/TruSeq3-SE.fa",
                        self.exp_parmas["Output_dir"]])

    def run_salmon(self):
        subprocess.run(["bash", self.exp_parmas["Script_dir"]+"/Bash_Scripts/salmon_se.sh",
                        self.sample_dict["Read1"],
                        self.exp_parmas["Index"],
                        self.exp_parmas["Threads"]],
                        self.exp_parmas["Output_dir"])


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

    def run_trimmomatic(self):
        subprocess.run(["bash", self.exp_parmas["Script_dir"]+"/Bash_Scripts/trimmomatic_pe.sh",
                        self.sample_dict["Read1"],
                        self.sample_dict["Read2"],
                        self.exp_parmas["Threads"],
                        self.exp_parmas["Script_dir"]+"/Adapters/TruSeq3-PE.fa",
                        self.exp_parmas["Output_dir"]])

    def run_salmon(self):
        subprocess.run(["bash", self.exp_parmas["Script_dir"]+"/Bash_Scripts/salmon_pe.sh",
                        self.sample_dict["Read1"],
                        self.sample_dict["Read2"],
                        self.exp_parmas["Index"],
                        self.exp_parmas["Threads"]],
                        self.exp_parmas["Output_dir"])

