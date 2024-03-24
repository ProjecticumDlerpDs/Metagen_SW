# README_Metagen_SW

# DLERPDS metagenomics slootwaterproject
# Moreno Serafino


=============================
#   Part 0: Introduction
=============================

This is the README file for DLERPDS metagenomics slootwaterproject, by Moreno Serafino. In this document, the complete pipeline from raw FASTQ data to visualised NGS data is explained, together with the scripts used.


-----------------------------
##  Part 0.1: Workstation
-----------------------------

Conda working environment:
meta

Working directory:
~/Metagen_SW unless otherwise stated.


-----------------------------
##  Part 0.2: Packages
-----------------------------

The scripts used in this pipeline require the following conda packages:

  sra-tools
  bowtie2
  samtools
  bamtools
  bedtools
  wigtobigwig
  homer
  fastqc


=============================
#   Part 1: Obtaining data
=============================

-----------------------------
##  Part 1.1: Data origin
-----------------------------

Raw data was obtained from ditch water, and provided in FASTQ format. Files are located in server directory:

/home/data/projecticum/SW/raw_data/


-----------------------------
##  Part 1.2: Raw data manipulation
-----------------------------




=============================
#   Part 2: Sequence alignment
=============================

