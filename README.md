# README_Metagen_SW

# DLERPDS Metagenomics data analysis pipeline
# By Moreno Serafino


=============================
#   Part 0: Introduction
=============================

This is the README file for the DLERPDS metagenomics data analysis pipeline project, by Moreno Serafino. In this document, the complete pipeline from raw FASTQ data to visualised NGS data is explained. For a more detailed description of script usage, see Metagen_SW_RMarkdown.Rmd on this GitHub page.


-----------------------------
##  Part 0.1: Workstation
-----------------------------

Working directory:
/home/1790915/Metagen_SW (~/Metagen_SW) unless otherwise stated.

Conda environment:
'meta'


-----------------------------
##  Part 0.2: Packages
-----------------------------

The 'meta' conda environment is created to which all necessary packages are installed:

  bowtie2   conda install bioconda::bowtie2
  bracken   conda install bioconda::bracken
  cutadapt  conda install bioconda::cutadapt
  fastqc    conda install bioconda::fastqc
  kraken2   conda install bioconda::kraken2
  nanoplot  conda install bioconda::nanoplot
  [[WIP]]

All packages must be installed in order to utilize the complete analysis pipeline.


=============================
#   Part 1: Obtaining data
=============================

-----------------------------
##  Part 1.1: Data origin
-----------------------------

Raw data was obtained from ditch water and provided in FASTQ format. Files are located in server directory:
/home/data/projecticum/SW/raw_data/

The data was generated using Oxford Nanopore Technologies' MinION device, through DNA sequencing (version 9.4.1). 
A total of 288 FASTQ-files have been generated over two ditchwater sequencing runs.


-----------------------------
##  Part 1.2: Raw data manipulation
-----------------------------




=============================
#   Part 2: Sequence alignment
=============================

