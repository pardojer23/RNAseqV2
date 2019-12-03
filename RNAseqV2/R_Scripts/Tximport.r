# Title     : Tximport
# Objective : Map transcript level expression to gene level and calculate TPM
# Created by: Jeremy
# Created on: 2019-09-19

# load required packages
library(readr)
library(dplyr)
library(tximport)
library (stringr)
library(rjson)
#read in json sample data
jsonData = fromJSON(file="experiment_config.json")
sampleTable = do.call(rbind.data.frame,jsonData$samples)
# add file path to salmon quant data
sampleTable$salmonFile = paste0(jsonData$output_dir,"/salmon_quant/",sampleTable$SampleID,".trimmed.fq_salmon/","quant.sf")
# convert date to date ID
sampleTable$DateTime = as.POSIXct(strptime(x = sampleTable$DateTime, format= "%Y-%m-%d %H:%M:%S"))
sampleTable = sampleTable[order(sampleTable$DateTime,decreasing = F),] %>%
dplyr::mutate(DateID=paste0("T",as.numeric(as.factor(DateTime))))
sampleTable$DateID = stringr::str_replace_all(sampleTable$DateID,"TNA","")
# add Exp column summarizing experimental conditions
sampleTable$Exp = stringr::str_c(sampleTable$Condition,
    sampleTable$Tissue,
    sampleTable$Location,
    sampleTable$DateID,sep="_")
sampleTable$Exp = stringr::str_replace_all(sampleTable$Exp,"___","_")
sampleTable$Exp = stringr::str_replace_all(sampleTable$Exp,"__","_")
sampleTable$Exp = stringr::str_replace_all(sampleTable$Exp,"_$","")
sampleTable$SampleName = paste0(sampleTable$Exp,"_R",sampleTable$Replicate)
#
head(sampleTable)
#write sampleTable
write_delim(sampleTable,paste0(jsonData$output_dir,"/sampleTable.csv"), delim=",")
#read in tx2gene file
tx2gene = read_delim(paste0(jsonData$output_dir,"/tx2gene.txt"),col_names= F, delim= "\t")
head(tx2gene)

# get vector of file paths
files = sampleTable$salmonFile
# run tximport
txi_LS = tximport(files = files,type="salmon", tx2gene=tx2gene,countsFromAbundance="lengthScaledTPM")
txi = tximport(files = files,type="salmon", tx2gene=tx2gene)
#get TPM
TPM_LS = as.data.frame(txi_LS$abundance)
colnames(TPM_LS) = sampleTable$SampleName
TPM_LS$GeneID = rownames(TPM_LS)
write_delim(TPM_LS,paste0(jsonData$output_dir,"/TPM_LS.txt"),delim="\t")
Counts_LS = as.data.frame(txi_LS$counts)
colnames(Counts_LS) = sampleTable$SampleName
Counts = as.data.frame(txi$counts)
colnames(Counts) = sampleTable$SampleName
#save the results
save.image(paste0(jsonData$output_dir,"/txi.RData"))