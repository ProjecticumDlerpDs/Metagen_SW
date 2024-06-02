#!/bin/bash

### pseudocode ###

## step 1: describe script function and usage.
## step 2: define input options.
## step 3: check input and output.
## step 4: provide quality threshold.
## step 5: execute length-based filtering through NanoFilt command.
## step 6: refer to output.


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of nanofilt_lfilter.sh: 
  
  This script filters reads from fastq.gz files based on minimum and/or maximum length requirements provided by the user.
  
  Usage: 
    -i  input fastq.gz file
    -O  output directory (created through script)
    -h  for help

  Example cmd line:
    bash nanofilt_lfilter.sh 
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
        echo -e "Use cmd \"bash nanofilt_lfilter.sh -h\" for instructions.\n"
        exit 1                      ;;
  esac
done


## step 3.1: check prompt:

if [ -z "$infile" ] || [ -z "$outdir" ]; then
  echo -e "\nPlease provide valid options (-i and -O are required)."
  echo -e "Use cmd \"bash nanofilt_lfilter.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.2: check output folder:

if [ ! -d "$outdir" ]; then
  mkdir -p "$outdir"
  echo -e "\nOutput folder '$outdir' created.\n"
else
  echo -e "\nUsing existing output folder '$outdir'.\n"
fi


## step 4: provide thresholds:

read -p "Provide minimum length requirement (leave blank to skip): " min_length
read -p "Provide maximum length requirement (leave blank to skip): " max_length


## step 5: filtering reads with NanoFilt based on length:

base_filename=$(basename "$infile" .fastq.gz)
output_file="${outdir}/${base_filename}"

# Constructing the NanoFilt command based on the provided lengths
nanafilt_cmd="gunzip -c \"$infile\" | NanoFilt"

if [ -n "$min_length" ]; then
  nanafilt_cmd+=" --length $min_length"
  output_file+="_minL${min_length}"
fi

if [ -n "$max_length" ]; then
  nanafilt_cmd+=" --maxlength $max_length"
  output_file+="_maxL${max_length}"
fi

output_file+=".fastq.gz"

# Adding the final gzip command
nanafilt_cmd+=" | gzip > \"$output_file\""

# Executing the command
eval $nanafilt_cmd


## step 6: refer to output:

echo -e "\nFiltered reads saved to '$output_file'.\n"
