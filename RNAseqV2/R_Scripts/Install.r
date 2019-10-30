# Title     : Install R Script
# Objective : Install R package dependencies
# Created by: Jeremy Pardo
# Created on: 2019-10-25
if (!requireNamespace("BiocManager", quietly = TRUE))
install.packages("BiocManager", repos='http://cran.us.r-project.org')

BiocManager::install("tximport")
BiocManager::install("DESeq2")
install.packages("readr", repos='http://cran.us.r-project.org')
install.packages("dplyr", repos='http://cran.us.r-project.org')
install.packages("stringr", repos='http://cran.us.r-project.org')
install.packages("rjson", repos='http://cran.us.r-project.org')
