#!/bin/bash

while getopts I:O:h flag; do
  case "${flag}" in
    I) indir="${OPTARG}"  ;;
    O) outdir="${OPTARG}" ;;
    *) exit 1             ;;
  esac
done

total_files=0
total_length=0
read_lengths=()
sorted_lengths=()

for file in "$indir"/*.fastq.gz; do
  current_read_length=$(awk 'NR%4==2 {sum+=length}END{print sum}' "$file")
  total_files=$((total_files + 1))
  total_length=$((total_length + current_read_length))
  read_lengths+=("$current_read_length")
done

shortest_read=$(
  { for file in "$indir"/*.fastq.gz; do
      gunzip -c "$file" | awk 'NR%4==2 {print length, $0}'
    done | sort -n | head -n1 | cut -d ' ' -f 2- | wc -c
  } 2>/dev/null
)

longest_read=$(
  { for file in "$indir"/*.fastq.gz; do
      gunzip -c "$file" | awk 'NR%4==2 {print length, $0}'
    done | sort -n | tail -n1 | cut -d ' ' -f 2- | wc -c
  } 2>/dev/null
)

total_reads=0
for file in "$indir"/*fastq.gz; do
  lines=$(wc -l < "$file")
  total_reads=$((total_reads + lines /4))
done
average_length=$(($total_length / $total_reads))

outfile="SW_FASTQ_summary.txt"

{
echo "Total files: $total_files"
echo "Total reads: $total_reads"
echo "Combined length: $total_length"
echo "Shortest read: $shortest_read"
echo "Longesr read: $longest_read"
echo "Average length$average_length"
} > "$outdir/$outfile"