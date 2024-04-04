#!/bin/bash

### pseudocode ###

## stap 1: beschrijf de functie en gebruikswijze van het script.
## stap 2: definieer de invoeropties.
## stap 3: voer de FastQC analyse uit d.m.v. fastqc command.


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of FastQC_reporter.sh: 
  
  This script can be used to create FastQC reports for fastq.gz files.
  
  Usage: 
  -I input directory with fastq.gz files
  -O output directory (created through script)
  -h for help

  Example cmd line:
	bash FASTQC_reporter.sh 
	-I path/to/FASTQ/data 
	-O new/ouput/directory (can be created through script)\n\n"
}


## step 2: flag definition:

while getopts I:O:h flag; do
  case "${flag}" in
    I) indir="${OPTARG}"  ;;
    O) outdir="${OPTARG}" ;;
    h) print_usage
       exit 1             ;;
    *) echo -e "\nPlease provide valid options (-I and -O are required)."
       echo -e "Use cmd \"bash FASTQC_reporter.sh -h\" for instructions.\n"
       exit 1             ;;
  esac
done


## step 3: FastQC analysis report:

for file in "$indir"/*.fastq.gz
do
    echo "Running FastQC on $file..."
    fastqc "$file" -o "$indir"
done

echo "FastQC analysis complete. Please check $outdir."

