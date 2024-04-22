#!/bin/bash

### pseudocode ###

## step 1: describe script function and usage.
## step 2: define input options.
## step 3: check input and output.
## step 4: execute FastQC analysis through fastqc command.
## step 5: cleanup excess files.
## step 6: refer to output [xdg-open bugged].


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of FASTQC_reporter.sh: 
  
  This script can be used to create FastQC reports for fastq.gz files.
  
  Usage: 
  -I input directory with fastq.gz files
  -O output directory (created through script)
  -h for help

  Example cmd line:
	bash FASTQC_reporter.sh 
	-I path/to/FASTQ/data 
	-O ouput/directory (can be created through script)\n\n"
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


## step 3.1: check whether flags have been provided by the user:

if [ -z "$indir" ] || [ -z "$outdir" ]; then
  echo -e "\nPlease provide valid options (-I and -O are required)."
  echo -e "Use cmd \"bash FASTQC_reporter.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.2: check whether directory -I exists and contains data:

if [ ! -d "$indir" ]; then
  echo -e "\nThe provided input directory does not exist."
  echo "Use cmd \"bash FASTQC_reporter.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.3: check whether directory -O exists, create if necessary:

if [ ! -d "$outdir" ]; then
  echo -e "\nCreating output directory: $outdir\n\n"
  mkdir -p "$outdir"
fi


## step 4: create FastQC analysis report:

for file in "$indir"/*.fastq.gz; do
    echo -e "Running FastQC on $file...\n"
    fastqc "$file" -o "$outdir"
done

echo -e "\nFastQC analysis complete. Please check $outdir.\n\n"


## step 5: cleanup output folder:

if [ -n "$(find "$outdir" -maxdepth 1 -type f -name '*fastqc.zip')" ]; then
    rm "$outdir"/*fastqc.zip
fi


## step 6: open FastQC report:

# [bugged] xdg-open "$outdir"/$infile*.html



