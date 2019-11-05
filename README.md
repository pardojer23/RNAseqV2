## RNAseqV2
This pipeline allows for the analysis of RNAseq data using the pseudo-aligner Salmon

# Installation <br>
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
5. Time: Time of day when samples were collected ie. *4 AM* or *4:00:00 am*
6. Date: Calendar date when samples were collected in month day year format
7. Condition: Description of experimental condition ie. *drought*
8. Collector: Name of individual who collected the sample
9. Location: Location where samples were collected ie. *Michigan State University HTRC*
10. Platform: Sequencing platform used ie. *HiSeq1X150* <br>

All 10 columns must be included in the sample table, however they may all be left empty for any given sample except for the Read1 and replicate columns.
In order for the pipeline to run successfully at least one of Tissue, Time, Date, or Condition must be included for all of the samples. <br>

To generate an empty sample table with all the required column names execute the pipeline with the following flags: <br>
`python run_pipeline.py --sample_table {FULL PATH WHERE SAMPLE TABLE SHOULD BE CREATED} --script_dir {FULL PATH TO DIRECTORY WHERE PROGRAM IS INSTALLED} --output_dir {FULL PATH TO DIRECTORY WHERE OUTPUT SHOULD BE SAVED}` <br>

**Execution**
 
To print the help message and exit run: <br>
`python run_pipeline.py -h`

To start the pipeline run the following command:
`python run_pipeline.py -s {SAMPLE TABLE} -g {GFF FILE} -f {TRANSCRIPTOME FASTA FILE} -i {TRANSCRIPTOME INDEX BASENAME} -t {NUMBER OF THREADS} -sd{FULL PATH TO INSTALLATION DIRECTORY} -o {OUTPUT DIRECTORY} -de {SET TRUE FOR DE} -r {REFERENCE EXP LEVEL}` <br>

**Command Line Arguments**
`-h, --help` Print help message and exit <br>
`-s, --sample_table` Full path to sample table, if file does not exist an empty sample table with only column headers will be created <br>
`-g, --gff` Full path to reference annotation in gff3 format. Looks for 'mRNA' lines in column 3 and expects 'ID=[TRANCRIPT_ID]' and 'Parent=[GENE_ID]' in column 9. <br>
`-f, --fasta` Full path to reference transcriptome in fasta format. <br>
`-i, --index` Basename for transcriptome index. If it does not exist in the output directory a new salmon index will be created. <br>
`-t, --threads` Number of threads to use for multiprocessing steps. <br>
`-sd, --script_dir` Full path to directory containing the `run_pipeline.py` file. This directory should also contain the `RNAseqFunctions.py` `RNAseq.smk` files and the `Bash_Scripts` `envs` and `R_Scripts` subdirectories. <br>
`-o, --output_dir` Full path to directory where output should be stored. If it does not exist the directory will be created. <br>
`-T, --trimmomatic` Set to true in order to run trimmomatic for read trimming instead of FastP.
`-de, --differential_expression` Set to true to run differential expression analysis. <br>
`-r, --reference_levels` The reference treatment level (control) for differential expression. 
Differential expression will be calculated relative to this level. 
Multiple levels can be set as the reference by entering each level separated by commas and differential expression will be calculated between each reference level and all other samples. 
The level should match a level from the 'Exp' column of the sampleTable. The Exp variable is created by concatenating the 'Condition', 'Tissue', 'Location' and 'DateID' variables separated by an underscore. 
The 'DateID' variable is a sequential ordering of the experimental timepoints based on the date and time entered. Each timepoint is designated as 'T" followed by a number. ie. T1, T2 etc... 
Variables left blank in the sample table will not be included. See the below example of what the 'Exp' variable will be based on different sample input information <br>

 |Condition|Tissue|Location|Date|Time|Exp|
 |---------|------|--------|----|----|---|
 |WW|V3_Leaf|MSU_HTRC|01/31/2019|4am|WW_V3_Leaf_MSU_HTRC_T1|
 |Drt|V3_Leaf|""|01/31/2019|5am|Drt_V3_Leaf_T2
 






