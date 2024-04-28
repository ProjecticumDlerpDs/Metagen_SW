#!/bin/bash

### pseudocode ###

## step 1: describe script function and usage.
## step 2: define input options.
## step 3: check input and output.
## step 4: execute Kraken2 analysis through kraken2 command.
## step 5: refer to output.


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of Kraken2_classifier.sh: 
  
  This script can be used to create a Kraken2 species classification report on a single fastq.gz file.
  
  Usage: 
    -i  input fastq.gz file
    -O  output directory (created through script)
    -d  Kraken2 database
    -h  for help

  Example cmd line:
    bash Kraken2_classifier.sh 
    -i  path/to/FASTQ/file.fastq.gz 
    -O  output/directory
    -d  path/to/Kraken2_reference_database\n\n"
}


## step 2.1: create empty variables:

infile=""
outdir=""
kraken2_db=""


## step 2.2: flag definition:

while getopts i:O:d:h flag; do
  case "${flag}" in
    i)  infile="${OPTARG}"           ;;
    O)  outdir="${OPTARG}"          ;;
    d)  kraken2_db="${OPTARG}"      ;;
    h)  print_usage
        exit 1                      ;;
    *)  echo -e "\nPlease provide valid options (-i, -O, and -d are required)."
        echo -e "Use cmd \"bash Kraken2_classifier.sh -h\" for instructions.\n"
        exit 1                      ;;
  esac
done


## step 3.1: check prompt:

if [ -z "$infile" ] || [ -z "$outdir" ] || [ -z "$kraken2_db" ]; then
  echo -e "\nPlease provide valid options (-i, -O, and -d are required)."
  echo -e "Use cmd \"bash Kraken2_classifier.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.2: check output folder:

if [ ! -d "$outdir" ]; then
  mkdir -p "$outdir"
  echo -e "\nOutput folder '$outdir' created.\n"
else
  echo -e "\nUsing existing output folder '$outdir'.\n"
fi


## step 4.1: Kraken2 output filename definition:

base_filename=$(basename "$infile")
outfile="$outdir/${base_filename%.fastq.gz}.kraken"
repfile="$outdir/${base_filename%.fastq.gz}.report"


## step 4.2: Kraken2 classification:

kraken2 --db "$kraken2_db" --threads "$(nproc)" --output "$outfile" --report "$repfile" "$infile"


## step 5: refer to output:

echo -e "\nKraken2 analysis results saved to '$outdir'.\n"
