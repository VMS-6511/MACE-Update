#!/bin/bash

# Check if the input directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_directory>"
    exit 1
fi

input_dir=$1
output_file="${input_dir}/metadata.jsonl"  # Write the output file in the input directory

# Check if the input directory exists
if [ ! -d "$input_dir" ]; then
    echo "The directory $input_dir does not exist."
    exit 1
fi

# Start fresh with the metadata.jsonl file
> $output_file

# Read files and extract required data
find "$input_dir" -type f | while IFS= read -r file; do
    filename=$(basename -- "$file")
    text=$(echo "$filename" | sed -E 's/(_[0-9]+)\.[^.]+$//')
    echo "{\"file_name\": \"$filename\", \"text\": \"$text\"}" >> $output_file
done

echo "Metadata has been written to $output_file."

