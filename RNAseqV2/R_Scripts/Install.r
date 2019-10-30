# Title     : Install R Script
# Objective : Install R package dependencies
# Created by: Jeremy Pardo
# Created on: 2019-10-25
if (!requireNamespace("BiocManager", quietly = TRUE))
install.packages("BiocManager", repos='http://cran.us.r-project.org')

BiocManager::install("tximport")
BiocManager::install("DESeq2")
# pkgTest function from Sacha Epskamp https://stackoverflow.com/users/567015/sacha-epskamp
pkgTest <- function(x){
    if (!require(x,character.only = TRUE))
    {
        install.packages(x, repos='http://cran.us.r-project.org')
        if(!require(x,character.only = TRUE)) stop("Package not found")
    }
}

pkgTest("readr")
pkgTest("dplyr")
pkgTest("stringr")
pkgTest("rjson")

