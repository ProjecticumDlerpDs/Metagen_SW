#!/bin/bash

### pseudocode ###

## step 1: describe script function and usage.
## step 2: define input options.
## step 3: check input and output.
## setp 4: select database.
## step 5: output definition.
## step 6: execute Kraken2 analysis through kraken2 command.
## step 7: refer to output.


### code ###

## step 1: script description and usage:

print_usage() {
  printf "\nDescription of kraken2_classifier.sh: 
  
  This script can be used to create a Kraken2 species classification report on a single fastq.gz file.
  
  Usage: 
    -i  input fastq.gz file
    -O  output directory (created through script)
    -h  for help

  Example cmd line:
    bash kraken2_classifier.sh 
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
        echo -e "Use cmd \"bash kraken2_classifier.sh -h\" for instructions.\n"
        exit 1                      ;;
  esac
done


## step 3.1: check prompt:

if [ -z "$infile" ] || [ -z "$outdir" ]; then
  echo -e "\nPlease provide valid options (-i and -O are required)."
  echo -e "Use cmd \"bash kraken2_classifier.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.2: check output folder:

if [ ! -d "$outdir" ]; then
  mkdir -p "$outdir"
  echo -e "\nOutput folder '$outdir' created.\n"
else
  echo -e "\nUsing existing output folder '$outdir'.\n"
fi


## step 4.1: database selection:

echo -e "\nSelect which Kraken2 reference database to use:"
echo "1: (8 GB)  Standard database mini"
echo "2: (16 GB) Standard database small"
echo "3: (72 GB) Standard database complete"
echo "4: (<1 GB) Viral database"
echo -e "5: Skip downloading and refer to already existing database instead\n"
read -p "Enter the number of desired reference database: " db


## step 4.2: download database

if [ "$db" -eq 5 ]; then
  read -p "Enter absolute path to the already downloaded Kraken2 database: " db_dir
  db_dir="${db_dir/#\~/$HOME}" # to enable using ~
  if [ ! -d "$db_dir" ]; then
    echo -e "\nThe provided path is not a valid directory."
    exit 1
  fi
  
else
case "$db" in
1)
  db_url="https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20240112.tar.gz"
  ;;
2)
  db_url="https://genome-idx.s3.amazonaws.com/kraken/k2_standard_16gb_20240112.tar.gz"
  ;;
3)
  db_url="https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20240112.tar.gz"
  ;;
4)
  db_url="https://genome-idx.s3.amazonaws.com/kraken/k2_viral_20240112.tar.gz"
  ;;
*)
  echo -e "\nPlease provide valid options for reference database (1, 2, 3 or 4)."
  exit 1
  ;;
esac

db_dir="$outdir/kraken2_db"
mkdir -p "$db_dir"
echo -e "\nDownloading Kraken2 database to '$db_dir'. This may take a while...\n"
wget -O "$db_dir/kraken2_db.tar.gz" "$db_url"
echo -e "\nExtracting database...\n"
tar -xzvf "$db_dir/kraken2_db.tar.gz" -C "$db_dir"
fi

## step 5: Kraken2 output definition:

kraken2_db="$db_dir"

base_filename=$(basename "$outdir")
outfile="$outdir/${base_filename}.kraken"
repfile="$outdir/${base_filename}.report"


## step 6: Kraken2 taxonomic classification:

kraken2 --db "$kraken2_db" --threads "$(nproc)" --memory-mapping --output "$outfile" --report "$repfile" "$infile"


## step 7: refer to output:

echo -e "\nKraken2 analysis results saved to '$outdir'.\n"
