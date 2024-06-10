#!/bin/bash

# Parameters
NUM_READS=1000  # Number of reads to generate
MIN_READ_LENGTH=500  # Minimum read length
MAX_READ_LENGTH=20000  # Maximum read length
OUTPUT_FILE="nonsense_nanopore.fastq"

# Function to generate a random DNA sequence
generate_random_sequence() {
    local length=$1
    cat /dev/urandom | tr -dc 'ATCG' | head -c "$length"
}

# Function to generate random quality scores with an average around 10
generate_random_quality() {
    local length=$1
    local quality=""
    for (( i=0; i<length; i++ ))
    do
        # Generate a quality score with an average around 10
        quality+=$(printf \\$(printf '%03o' $(( RANDOM % 4 + 43 ))))  # ASCII 43-46 corresponds to quality scores 10-13
    done
    echo "$quality"
}

# Create the output FASTQ file
: > "$OUTPUT_FILE"

# Generate reads
for (( i=1; i<=NUM_READS; i++ ))
do
    READ_LENGTH=$(( RANDOM % (MAX_READ_LENGTH - MIN_READ_LENGTH + 1) + MIN_READ_LENGTH ))
    SEQUENCE=$(generate_random_sequence "$READ_LENGTH")
    QUALITY=$(generate_random_quality "$READ_LENGTH")
    
    echo "@nonsense_read_$i" >> "$OUTPUT_FILE"
    echo "$SEQUENCE" >> "$OUTPUT_FILE"
    echo "+" >> "$OUTPUT_FILE"
    echo "$QUALITY" >> "$OUTPUT_FILE"
done

echo "Generated $NUM_READS reads in $OUTPUT_FILE"
