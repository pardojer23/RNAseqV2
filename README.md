## RNAseqV2
This pipeline allows for the analysis of RNAseq data using the pseudo-aligner Salmon

#Installation
*Dependencies:*<br>
The folowing dependencies must be pre-installed:
1. Anaconda3 / Miniconda3
2. BASH shell

Other dependencies are installed through the installation script
1. python=3.6.*
2. pandas
3. dateparser
4. snakemake
5. fastp
6. trimmomatic
7. salmon
8. r-base=3.6.*

The following R packages are also required and are installed via the installation script
1. BiocManager
2. tximport
3. DESeq2
4. readr
5. dplyr
6. stringr
7. rjson

To install clone the git repository: <br>
`git clone https://github.com/pardojer23/RNAseqV2.git` <br>
Then navigate to the directory containing the `setup.py` file. <br>
`cd RNAseqV2`<br>
Finally with the base anaconda / miniconda active run the installation script. <br>
`python setup.py install`
