# Title     : DESeq2
# Objective : Conduct differential expression analysis
# Created by: Jeremy Pardo
# Created on: 2019-09-19

args = commandArgs(TRUE)
refLevels = strsplit(args[1],",")
# load required packages
# load required packages
library(readr)
library(tximport)
library(DESeq2)
library(dplyr)
library(rjson)
jsonData = fromJSON(file="experiment_config.json")
# set working directory
setwd(jsonData$output_dir)
#read in sample table
sampleTable <-read_delim(paste0(jsonData$output_dir,"/sampleTable.csv"),delim=",")
# load tximport data
load(paste0(jsonData$output_dir,"/txi.RData"))
#
DEseq_obj <- DESeqDataSetFromTximport(txi=txi,colData = sampleTable,design = ~ Exp)
dds_obj <- DESeq(DEseq_obj)
##
##
get_sig_df = function(df,cont){
    df = mutate(df,GeneID = rownames(df),Contrast = cont)
    df = df[which(df$padj<0.05),]
    return(df)
}
expConditions = unique(sampleTable$Exp)
print("Collecting results using the following treatment(s) as the reference level:",refLevels)
compare_list = list()
x=1
for (i in 1:length(refLevels)){
    for (j in 1:length(expConditions)){
        if (expConditions[j] != refLevels[i]){
            compare_list[x] = paste0(refLevels[i],"-",expConditions[j])
            x = x+1
        }
    }

}
compare_list = unlist(strsplit(compare_list,","))
df_list = list()
print(compare_list)
for (i in 1:length(compare_list)){
    print(compare_list[i])
    condition_list = unlist(strsplit(compare_list[i],"-"))
    contrast = paste0(condition_list[1],"v",condition_list[2])
    print(contrast)
    df_list[[i]] = assign(paste0(contrast,"_sig"),get_sig_df(assign(contrast,as.data.frame(results(dds_obj,contrast=c("Condition",condition_list[2],condition_list[1]),alpha=0.05,pAdjustMethod = "fdr"))),contrast))
}
DE_Gene_df = bind_rows(df_list)
write_delim(DE_Gene_df,"DE_Gene_df.txt",delim="\t")
##
save.image("DESeq2.RData")