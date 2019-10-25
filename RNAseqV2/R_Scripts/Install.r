# Title     : Install R Script
# Objective : Install R package dependencies
# Created by: Jeremy Pardo
# Created on: 2019-10-25
if (!requireNamespace("BiocManager", quietly = TRUE))
install.packages("BiocManager")

BiocManager::install("tximport")
BiocManager::install("DESeq2")
install.packages("readr")
install.packages("dplyr")
install.packages("stringr")
install.packages("rjson")
