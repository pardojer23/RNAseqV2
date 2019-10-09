# Title     : Tximport
# Objective : Map transcript level expression to gene level and calculate TPM
# Created by: Jeremy
# Created on: 2019-09-19

args = commandArgs(TRUE)
outputDir = args[1]
setwd(outputDir)
# load required packages
library(readr)
library(tximport)
#read in sample table
sampleTable = read_delim("SampleTable.txt",delim="\t")
#read in tx2gene file
tx2gene = read_delim("tx2gene.txt",col_names= T, delim= "\t")
head(tx2gene)

# get vector of file paths
files = sampleTable$FilePath
# run tximport
txi_LS = tximport(files = files,type="salmon", tx2gene=tx2gene,countsFromAbundance="lengthScaledTPM")
txi = tximport(files = files,type="salmon", tx2gene=tx2gene)
#get TPM
TPM_LS = as.data.frame(txi_LS$abundance)
colnames(TPM_LS) = sampleTable$Sample
TPM_LS$GeneID = rownames(TPM_LS)
write_delim(TPM_LS,"TPM_LS.txt",delim="\t")
Counts_LS = as.data.frame(txi_LS$counts)
colnames(Counts_LS) = sampleTable$Sample
Counts = as.data.frame(txi$counts)
colnames(Counts) = sampleTable$Sample
#save the results
save.image("txi.RData")