#!/bin/bash

### pseudocode ###

## stap 1: beschrijf de functie en gebruikswijze van het script.
## stap 2: definieer de invoeropties.
## stap 3: definieer de output o.b.v. input.
## stap 4: voer de trimming uit met de <cutadapt> command.


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of FastQ_1000bp_trimmer.sh: 
  
  This script can be used to remove the first x basecalls from fastq.gz files.
  
  Usage: 
  -i input fastq.gz file
  -O output directory (created through script)
  -x cutoff (number)
  -h for help

  Example cmd line:
	bash FASTQC_reporter.sh 
	-i path to FASTQ (.fastq.gz) 
	-O ouput directory (can be created through script)
	-x number (inclusive) of bases that will be trimmed from the start of each read\n\n"
}


## step 2: flag definition:

while getopts ":i:O:x:h" flag; do
  case ${flag} in
    i)  infile=$OPTARG ;;
    O)  outdir=$OPTARG ;;
    x)  cutoff=$OPTARG ;;
    h)  print_usage      
        exit 1         ;;
    *)  echo -e "\nPlease provide valid options (-i, -O and -x are required).\nUse cmd \"bash FASTQ_trimmer.sh -h\" for instructions.\n"
        exit 1         ;;
  esac
done


## step 3: output definition:

outfile="$outdir/$(basename "${infile%.fastq.gz}")_trimmed.fastq.gz"


## step 4: trimming with cutadapt:

cutadapt -u "$cutoff" -o "$outfile" "$infile"
echo "Trimming completed. Output written to $outdir/$outfile"
