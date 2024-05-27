#!/bin/bash

### pseudocode ###

## step 1: describe script function and usage.
## step 2: define input options.
## step 3: check input and output.
## step 4: execute Bracken analysis through bracken command.
## step 5: file organization.
## step 6: refer to output.


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of Bracken_estimator.sh: 
  
  This script takes Kraken2 output and estimates the classified species' abundance.
  
  Usage: 
    -i  input Kraken2 result file (*.report)
    -O  output directory (created through script)
    -d  Kraken2 database
    -h  for help

  Example cmd line:
    bash Bracken_estimator.sh 
    -i  input/kraken2_result.report 
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
    i)  infile="${OPTARG}"          ;;
    O)  outdir="${OPTARG}"          ;;
    d)  kraken2_db="${OPTARG}"      ;;
    h)  print_usage
        exit 1                      ;;
    *)  echo -e "\nPlease provide valid options (-i, -O, and -d are required)."
        echo -e "Use cmd \"bash Bracken_estimator.sh -h\" for instructions.\n"
        exit 1                      ;;
  esac
done


## step 3.1: check prompt:

if [ -z "$infile" ] || [ -z "$outdir" ] || [ -z "$kraken2_db" ]; then
  echo -e "\nPlease provide valid options (-i, -O, and -d are required)."
  echo -e "Use cmd \"bash Bracken_estimator.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.2: check output folder:

if [ ! -d "$outdir" ]; then
  mkdir -p "$outdir"
  echo -e "\nOutput folder '$outdir' created.\n"
else
  echo -e "\nUsing existing output folder '$outdir'.\n"
fi

## step 4: Bracken abundance estimation:

base_filename=$(basename "$infile")
bracken_output="$outdir/${base_filename%.report}.bracken"

bracken -d "$kraken2_db" -i "$infile" -o "$bracken_output"


## step 5: file organization:

bracken_report="${infile%.report}_bracken_species.report"
if [ -f "$bracken_report" ]; then
  mv "$bracken_report" "$outdir"
fi


## step 6: refer to output:

echo -e "\nBracken analysis results saved to '$bracken_output'.\n"
