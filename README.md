## RNAseqV2
This pipeline allows for the analysis of RNAseq data using the pseudo-aligner Salmon

#Installation <br>
**Dependencies:**<br>
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
Finally with the base anaconda / miniconda environment active run the installation script. <br>
`python setup.py install`
# Basic Execution
To run the pipeline the following inputs are required:
1. sample table contaiing paths to raw fastq reads and metadata in csv format
2. reference transcriptome in fasta format
3. reference genome in gff3 format

**Sample Table:** <br>
The sample table should contain 10 columns:
1. Read1: Path to fwd read fastq
2. Read2: Path to rev read fastq (leave blank if single end reads)
3. Replicate: Integer denoting the biological replicate
4. Tissue: Name of tissue where sample originated from ie. *V3_leaf*
5. Time: Time of day when samples were collected ie. *4 AM or 4:00:00 am
6. Date: Calendar date when samples were collected in month day year format
7. Condition: Description of experimental condition ie. *drought*
8. Collector: Name of individual who collected the sample
9. Location: Location where samples were collected ie. *Michigan State University HTRC*
10. Platform: Sequencing platform used ie. *HiSeq1X150* <br>

All 10 columns must be included in the sample table, however they may all be left empty for any given sample except for the Read1 and replicate columns.
In order for the pipeline to run successfully at least one of Tissue, Time, Date, or Condition must be included for all of the samples.

