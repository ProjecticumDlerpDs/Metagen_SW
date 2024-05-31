#!/bin/bash

### pseudocode ###

## step 1: describe script function and usage.
## step 2: define input options.
## step 3: check input and output.
## step 4: execute NanoPlot analysis through NanoPlot command.
## step 5: cleanup excess files.


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of fastq_nanoplotter.sh: 
  
This script is used to create NanoPlots from FASTQ files. 
These plots serve as quality control.
The NanoPlot tool is designed specifically for ONT long-read data.
  
  Usage: 
    -I input directory with fastq.gz files
    -O output directory (created through script)
    -h for help

  Example cmd line:
	  bash fastq_nanoplotter.sh \\
	  -I path/to/fastq/data     \\
	  -O ouput/directory\n\n"
}


## step 2: flag definition:

while getopts I:O:h flag; do
  case "${flag}" in
    I) indir="${OPTARG}"  ;;
    O) outdir="${OPTARG}" ;;
    h) print_usage
       exit 1             ;;
    *) echo -e "\nPlease provide valid options (-I and -O are required)."
       echo -e "Use cmd \"bash fastq_nanoplotter.sh -h\" for instructions.\n"
       exit 1             ;;
  esac
done


## step 3.1: check whether flags have been provided by the user:

if [ -z "$indir" ] || [ -z "$outdir" ]; then
  echo -e "\nPlease provide valid options (-I and -O are required)."
  echo -e "Use cmd \"bash fastq_nanoplotter.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.2: check whether directory -I exists and contains data:

if [ ! -d "$indir" ]; then
  echo -e "\nThe provided input directory does not exist."
  echo "Use cmd \"bash fastq_nanoplotter.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.3: check whether directory -O exists, create if necessary:

if [ ! -d "$outdir" ]; then
  echo -e "\nCreating output directory: $outdir\n"
  mkdir -p "$outdir"
fi


## step 4: create NanoPlot analysis report:

for FASTQ in "$indir"/*.fastq.gz; do
  file_name=$(basename "${FASTQ%.fastq.gz}")
  echo "Processing file: $FASTQ"
  NanoPlot --verbose --fastq_rich $FASTQ -o "$outdir/$file_name"
done


## step 5: folder cleanup:

echo -e "\nRemoving unnecessary files ..."
find "$outdir" -type f ! -name "NanoPlot-report.html" -exec rm {} +
mv "$outdir/$file_name/NanoPlot-report.html" "$outdir/${file_name}_NanoPlot-report.html"
rmdir $outdir/$file_name
echo -e "\nNanoPlot created and folder cleaned up."
echo -e "\nOpen the NanoPlot report by clicking the html file in $outdir and choosing \"Open in Web Browser\".\n\n"