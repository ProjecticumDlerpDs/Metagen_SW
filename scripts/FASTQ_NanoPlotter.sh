#!/bin/bash

# step 1: script description and usage:

print_usage () {
  printf "\nDescription of FASTQ_NanoPlotter.sh: 
  
  This script is used to create NanoPlots of FASTQ files. 
  These plots serve as quality control.
  Designed for long read data only!
  
  Usage: 
  -I input directory with fastq.gz files
  -O output directory (created through script)
  -h for help

  Example cmd line:
	bash FASTQ_NanoPlotter.sh -I path/to/FASTQ/data -O new/ouput/directory\n\n"
}


## step 2: flag definition:

while getopts I:O:h flag; do
  case "${flag}" in
    I) indir="${OPTARG}"  ;;
    O) outdir="${OPTARG}" ;;
    h) print_usage
       exit 1             ;;
    *) echo -e "\nPlease provide valid options (-I and -O are required)."
       echo -e "Use cmd \"bash FASTQ_NanoPlotter.sh -h\" for instructions.\n"
       exit 1             ;;
  esac
done


## step 3: check whether directory -O exists, create if necessary:

if [ ! -d "$outdir" ]; then
  echo -e "\nCreating output directory: $outdir\n"
  mkdir -p "$outdir"
fi


## step 4: NanoPlotting:

for FASTQ in "$indir"/*.fastq.gz; do
  file_name=$(basename "${FASTQ%.fastq.gz}")
  echo "Processing file: $FASTQ"
  NanoPlot --fastq $FASTQ -o "$outdir/$file_name"


## step 5: folder cleanup:

echo -e "\nRemoving unnecessary files ..."
find "$outdir" -type f ! -name "NanoPlot-report.html" -exec rm {} +
echo -e "\nNanoPlot created and folder cleaned up.\n"
  
done
