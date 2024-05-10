#!/bin/bash

# Check for correct number of arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
fi

# Assign arguments to variables
input_dir=$1
output_dir=$HF_HOME/datasets/$2

# Create the output directory and the 'train' subdirectory
mkdir -p "$output_dir/train"

# Copy all jpg files from the input directory to the output directory's train subdirectory
cp "$input_dir"/*.jpg "$output_dir/train"

# Navigate to the train directory
cd "$output_dir/train"

# Create metadata.jsonl file
touch metadata.jsonl

# Loop over each jpg file in the train directory
for file in *.jpg; do
    # Extract the base name of the file
    base_name=$(basename "$file")

    # Remove the 'o_' prefix if present and then generate the descriptive text
    cleaned_name=$(echo "$base_name" | sed 's/^o_//')
    text=$(echo "$cleaned_name" | sed -E 's/(_[0-9]+)?\.jpg$//; s/-/ /g; s/([a-z])([A-Z])/\1 \2/g; s/\b(.)/\u\1/g')

    # Append a record to the metadata.jsonl
    echo "{\"file_name\": \"$base_name\", \"text\": \"$text\"}" >> metadata.jsonl
done

echo "Processing complete."
