#!/bin/bash

### pseudocode ###

## step 1: describe script function and usage.
## step 2: define input options.
## step 3: check input and output.
## step 4: execute Krona plot creation through ktImportTaxonomy command.
## step 5: refer to output.


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of Krona_visualizer.sh: 
  
  This script takes Bracken report file and generates a Krona plot.
  
  Usage: 
    -i  input Bracken result file (*.report)
    -O  output directory (created through script)
    -h  for help

  Example cmd line:
    bash Krona_visualizer.sh 
    -i  input/bracken_result.report 
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
        echo -e "Use cmd \"bash Krona_visualizer.sh -h\" for instructions.\n"
        exit 1                      ;;
  esac
done


## step 3.1: check prompt:

if [ -z "$infile" ] || [ -z "$outdir" ]; then
  echo -e "\nPlease provide valid options (-i and -O are required)."
  echo -e "Use cmd \"bash Krona_visualizer.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.2: check output folder:

if [ ! -d "$outdir" ]; then
  mkdir -p "$outdir"
  echo -e "\nOutput folder '$outdir' created.\n"
else
  echo -e "\nUsing existing output folder '$outdir'.\n"
fi

## step 4: Create Krona plot:

base_filename=$(basename "$infile" .report)
krona_output="$outdir/${base_filename}_krona.html"

ktImportTaxonomy -m 3 -t 5 -o "$krona_output" "$infile"


## step 5: refer to output:

echo -e "\nKrona plot created and saved to '$krona_output'.\n"
