# README_Metagen_SW

# DLERPDS Metagenomics data analysis pipeline v2
# By Moreno Serafino


-----------------------------
#   Part 1: Introduction


This is the README file for the DLERPDS metagenomics data analysis pipeline project, by Moreno Serafino. In this document, the complete pipeline from raw FASTQ data to visualised data is explained. For a more detailed description on each component, and for a step-by-step guide for using this pipeline, see Metagen_SW_RMarkdown_v2.Rmd, available on this GitHub page. 

This pipeline is designed for analyzing Next-Generation Sequencing data. The raw data used for testing this pipeline originate from two separate ONT MinION long-read, single-end shotgun DNA-sequencing experiments on ditch water using R9.4.1 flow-cells, presented in fastq.gz format. The point of this pipeline, however, is that data from other similar sequencing experiments, from various environments can be used as input. The final output of this pipeline will be a comprehensive and quality controlled overview of microbe composition found in the samples.


-----------------------------
##  Part 1.1: Requirements


The following packages must be present in your Conda environment for the pipeline to function:
  <br>bracken
  <br>fastqc
  <br>kraken2
  <br>krona
  <br>nanoplot
  <br>porechop

To avoid dependency issues, create a separate environment with the following packages:
  <br>libstdcxx-devel_linux-64
  <br>nanofilt


-----------------------------
#   Part 2: Raw data origin


This pipeline was created and tested using Oxford Nanopore Technologies' MinION R9.4.1 flow-cell sequencing data. The metagenomic samples were obtained from ditch water. It is however possible to use other NanoPore experminents as input as long as it is in fastq(.gz) format. The sample data was unpaired, and so if paired data is used as input, the pipeline will not take advantage of this without modifications.

It is recommended to first concatenate fastq.gz files into one larger fastq.gz file. 


-----------------------------
#   Part 3: Initial QC


Raw data can first be analyzed using FastQC and NanoPlot. Scripts for these analyses are fastqc_reporter.sh and fastq_nanoplotter.sh respectively. Use the -h option to view the description and usage of any script, for example *bash fastqc_reporter.sh -h*.


-----------------------------
##  Part 3.1: FastQC


Create a FastQC report: 

bash fastqc_reporter.sh \
-i path/to/fastq.gz/file \
-O path/to/output/directory

(https://github.com/s-andrews/FastQC)


-----------------------------
##  Part 3.2: NanoPlot


Create a NanoPlot report:

bash fastq_nanoplotter.sh \
-I path/to/fastq.gz/directory \
-O path/to/output/directory

(https://github.com/wdecoster/NanoPlot)


-----------------------------
#   Part 4: Taxonomy on raw data


It is important to execute a taxonomic analysis on the unedited data, so that classification results after data manipulation can be compared later.

Execute Kraken2 taxonomic classification:

bash kraken2_classifier.sh \
-i path/to/fastq.gz/file \
-O path/to/output/directory

(https://github.com/DerrickWood/kraken2)

The script will give you a prompt for choosing a Kraken2 reference database. Options are: standard, 16 gb, 8 gb, or viral (<1gb). There is also an option to use an existing database by providing the path to its directory. This option also allows you to use your own custom database, which must be built manually before executing the script.


-----------------------------
##  Part 5: Data manipulation


To increase the rate of classification by Kraken2, the raw data will be filtered and trimmed using a number of scripts.


-----------------------------
##  Part 5.1: ONT-adapter trimming


NanoPore MinION samples can contain a large variety of adapter sequences that generate irrelevant sequencing data.

Remove adapters using Porechop:

porechop \
-i path/to/fastq.gz/file \
-o path/to/output/filename.fastq.gz/file


-----------------------------
##  Part 5.2: Filtering on Q-score


Raising the minimum threshold of average Phred-quality scores (Q-scores) will help creating a more reliable subset.

This can be done with the nanofilt_qfilter.sh script, using NanoFilt. This must be done in a separate conda environment to avoid dependency issues (see part 1.1):

bash nanofilt_qfilter.sh \
-i path/to/fastq.gz/file \
-O path/to/output/directory

(https://github.com/wdecoster/nanofilt)

The script allows the user to choose a minimum Phred-quality score threshold. As shown in the Metagen_SW_RMarkdown_v2 document on this GitHub page, best results were obtained with Q>10.


-----------------------------
##  Part 5.3: Filtering on read length


The Q-filtered reads can then be filtered on length, which generally also increases classification rates since NanoPore is designed to create long reads, which counteracts the relatively high basecalling error rates. This is done through the nanofilt_lfilter.sh script, also utilizing NanoFilt:

bash nanofilt_lfilter.sh \
-i path/to/fastq.gz/file \
-O path/to/output/directory

The user is prompted to choose minimum and maximum length thresholds. As shown in the RMarkdown file, best classification results were obtained after filtering reads on a minimum length of 5000 bases and no maximum length.


-----------------------------
#   Part 6: Taxonomy on trimmed and filtered data


The Kraken2 analysis can now be done on the trimmed and filtered fastq.gz file:

bash kraken2_classifier.sh \
-i path/to/fastq.gz/file \
-O path/to/output/directory


-----------------------------
#   Part 7: Abundance estimation


To give a better representation of the actual microbial composition of the sample, the Kraken2 output is used as input for the Bracken tool, which re-estimates species abundances using Bayesian algorithms. This can be done using the bracken_estimator.sh script:

bash bracken_estimator.sh \
-i path/to/kraken2/*.report \
-O path/to/output/directory \
-d path/to/reference/database

(https://github.com/jenniferlu717/Bracken)

Make sure to use the same reference database as the one used for the Kraken2 analysis. The output file (*bracken_species.report) can be analyzed to find species of interest and their estimated abundances in the metagenomic samples at the time and place of their extraction.


-----------------------------
#   Part 8: Visualization


This pipeline visualizes the data using Krona graphs, as these are interactive and can be 'zoomed in' to provide more visual information on the species level. A Krona graph can be made using the krona_visualizer.sh script:

https://github.com/marbl/Krona

bash krona_visualizer.sh \
-i path/to/bracken/*_species.report \
-O path/to/output/directory


-----------------------------
#   Part 9: Validation


If desired, the pipeline can be tested in two ways: 
1: Positive control: use genomic data of a known species as input which is then classified using a reference database containing the genome for that species, expecting most or all reads to be classified and attributed to that species;
2: Negative control: use genomic data of a known species as input that does certainly not appear in the chosen reference database, expecting zero classified reads.