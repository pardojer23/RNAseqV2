# Title     : Tximport
# Objective : Map transcript level expression to gene level and calculate TPM
# Created by: Jeremy
# Created on: 2019-09-19

args = commandArgs(TRUE)
outputDir = args[1]
# load required packages
library(readr)
library(dplyr)
library(tximport)
library (stringr)
library(rjson)
#read in json sample data
print("Before json")
jsonData = fromJSON(file="experiment_config.txt")
print("After json")
print(jsonData)
sampleTable = do.call(rbind.data.frame,jsonData$samples)
print("sampleTable made, line 15")
# add file path to salmon quant data
sampleTable$salmonFile = paste0(jsonData$output_dir,"/",sampleTable$SampleID,".trimmed_salmon/","quant.sf")
# convert date to date ID
print("before date-making, line 19")
sampleTable$DateTime = as.POSIXct(strptime(x = sampleTable$DateTime, format= "%Y-%m-%d %H:%M:%S"))
sampleTable = sampleTable[order(sampleTable$DateTime,decreasing = F),] %>%
dplyr::mutate(DateID=paste0("T",as.numeric(as.factor(DateTime))))
print("after Date-making, line 23")
# add Exp column summarizing experimental conditions
sampleTable$Exp = stringr::str_c(sampleTable$Condition,
    sampleTable$Tissue,
    sampleTable$Location,
    sampleTable$DateID,sep="_")
sampleTable$Exp = stringr::str_replace_all(sampleTable$Exp,"__","_")
#read in tx2gene file
tx2gene = read_delim(outputDir+"/tx2gene.txt",col_names= T, delim= "\t")
head(tx2gene)

# get vector of file paths
files = sampleTable$salmonFile
# run tximport
txi_LS = tximport(files = files,type="salmon", tx2gene=tx2gene,countsFromAbundance="lengthScaledTPM")
txi = tximport(files = files,type="salmon", tx2gene=tx2gene)
#get TPM
TPM_LS = as.data.frame(txi_LS$abundance)
colnames(TPM_LS) = sampleTable$Sample
TPM_LS$GeneID = rownames(TPM_LS)
write_delim(TPM_LS,paste0(jsonData$output_dir,"/TPM_LS.txt"),delim="\t")
Counts_LS = as.data.frame(txi_LS$counts)
colnames(Counts_LS) = sampleTable$Sample
Counts = as.data.frame(txi$counts)
colnames(Counts) = sampleTable$Sample
#save the results
save.image(paste0(jsonData$output_dir,"/txi.RData"))