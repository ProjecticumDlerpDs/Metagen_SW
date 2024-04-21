#!/bin/bash

### pseudocode ###

## step 1: describe script function and usage.
## step 2: define input options.
## step 3: check input and output.
## step 4: create empty variables.
## step 5: execute summary analysis.
## step 6: print results to output.


### code ###

## step 0: set locale to avoid awk warning

export LC_ALL=C


## step 1: script description and usage:

print_usage() {
  printf "\nDescription of FASTQ_summarizer.sh: 
  
  This script can be used to create a quick summary of FASTQ files.
  
  Usage: 
  -I input directory with fastq.gz files
  -O output directory (created through script if necessary)
  -h for help

  Example cmd line:
	bash FASTQ_summarizer.sh -I path/to/FASTQ/data -O new/ouput/directory\n\n"
}


## step 2: flag definition:

while getopts I:O:h flag; do
  case "${flag}" in
    I) indir="${OPTARG}"  ;;
    O) outdir="${OPTARG}" ;;
    h) print_usage
       exit 1             ;;
    *) echo -e "\nPlease provide valid options (-I and -O are required)."
       echo -e "Use cmd \"bash FASTQ_summarizer.sh -h\" for instructions.\n"
       exit 1             ;;
  esac
done


## step 3.1: check whether flags have been provided by the user:

if [ -z "$indir" ] || [ -z "$outdir" ]; then
  echo -e "\nPlease provide valid options (-I and -O are required)."
  echo -e "Use cmd \"bash FASTQ_summarizer.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.2: check whether directory -I exists and contains data:

if [ ! -d "$indir" ]; then
  echo -e "\nThe provided input directory does not exist."
  echo "Use cmd \"bash FASTQ_summarizer.sh -h\" for instructions.\n"
  exit 1
fi


## step 3.3: check whether directory -O exists, create if necessary:

if [ ! -d "$outdir" ]; then
  echo -e "\nCreating output directory: $outdir"
  mkdir -p "$outdir"
    exit 1
fi


## step 4: create empty variables:

total_files=0
total_length=0
read_lengths=()
sorted_lengths=()


## step 5.1: analysis:

echo -e "\nAnalizing ..."

for file in "$indir"/*.fastq.gz; do
  current_read_length=$(awk 'NR%4==2 {sum+=length}END{print sum}' "$file")
  total_files=$((total_files + 1))
  total_length=$((total_length + current_read_length))
  read_lengths+=("$current_read_length")
done

shortest_read=$(for file in "$indir"/*.fastq.gz; do zcat "$file" | awk 'NR%4==2 {if(min=="" || length<min){min=length}} END{print min}'; done | sort -n | head -n1)
longest_read=$(for file in "$indir"/*.fastq.gz; do zcat "$file" | awk 'NR%4==2 {if(max=="" || length>max){max=length}} END{print max}'; done | sort -n | tail -n1)


## step 5.2: calculations:

echo -e "\nCalculating ..."

total_reads=0
for file in "$indir"/*fastq.gz; do
  lines=$(wc -l < "$file")
  total_reads=$((total_reads + lines /4))
done
average_length=$(($total_length / $total_reads))
total_length_Mb=$(($total_length / 1000000))


## step 6: presentation:

outfile="FASTQ_summary.txt"

{
echo -e "\nSummary analysis of FASTQ files found in $indir directory." 
echo "Script used: FASTQ_summarizer.sh."
echo "Input directory used: $indir"
echo "Script execution: $(date)"
echo -e "\n\n#===Report=======#\n\nTotal number of FASTQ files used as input:" 
echo "$total_files"
echo -e "\nTotal number of reads:"
echo "$total_reads"
echo -e "\nTotal combined read length:"
echo "$total_length ($total_length_Mb Mb)"
echo -e "\nShortest read length:"
echo "$shortest_read"
echo -e "\nLongest read length:"
echo "$longest_read"
echo -e "\nAverage read length:"
echo "$average_length"
echo -e "\n#===Fin==========#"
} > "$outdir/$outfile"

echo -e "\nSummary report added to: $outdir/$outfile.\n"