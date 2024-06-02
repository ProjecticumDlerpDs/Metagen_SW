#!/bin/bash

### pseudocode ###

## step 1: describe script function and usage.
## step 2: define input options.
## step 3: check input and output.
## step 4: provide quality threshold.
## step 5: execute Phred-quality score filtering through NanoFilt command.
## step 6: refer to output.


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of nanofilt_qfilter.sh: 
  
  This script filters reads from fastq.gz files based on minimum Phred-quality score requirements provided by the user.
  
  Usage: 
    -i  input fastq.gz file
    -O  output directory (created through script)
    -h  for help

  Example cmd line:
    bash nanofilt_qfilter.sh 
    -i  path/to/fastq/file.fastq.gz 
    -O  output/directory\n\n"
}


## step 2.1: create empty variables:

infile=""
outdir=""


## step 2.2: flag definition:

while getopts i:O:h flag; do
  case "${flag}" in
    i)  infile="${OPTARG}"          ;;
    O)  outdir="${OPTARG}"          ;;
    h)  print_usage
        exit 1                      ;;
    *)  echo -e "\nPlease provide valid options (-i and -O are required)."
        echo -e "Use cmd \"bash nanofilt_qfilter.sh -h\" for instructions.\n"
        exit 1                      ;;
  esac
done


## step 3.1: check prompt:

if [ -z "$infile" ] || [ -z "$outdir" ]; then
  echo -e "\nPlease provide valid options (-i and -O are required)."
  echo -e "Use cmd \"bash nanofilt_qfilter.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.2: check output folder:

if [ ! -d "$outdir" ]; then
  mkdir -p "$outdir"
  echo -e "\nOutput folder '$outdir' created.\n"
else
  echo -e "\nUsing existing output folder '$outdir'.\n"
fi


## step 4: provide threshold:

read -p "Provide minimum Phred-quality score requirement (integer): " qual


## step 5: filtering reads with NanoFilt:

base_filename=$(basename "$infile" .fastq.gz)
output_file="${outdir}/${base_filename}_Q${qual}.fastq.gz"

gunzip -c "$infile" | NanoFilt -q "$qual" | gzip > "$output_file"


## step 6: refer to output:

echo -e "\nFiltered reads saved to '$output_file'.\n"
