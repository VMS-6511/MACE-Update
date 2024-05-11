#!/bin/bash

# Check for correct number of arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <input_directory> <output_directory> <regex_pattern>"
    exit 1
fi

if [ -z "$HF_HOME" ]; then
    # If HF_HOME is not set, set it to the desired path
    export HF_HOME="/home/ralur/.cache/huggingface/hub"
    echo "HF_HOME was not set. It has been set to: $HF_HOME"
else
    # If HF_HOME is already set, display its value
    echo "HF_HOME is already set to: $HF_HOME"
fi

# Assign arguments to variables
input_dir=$1
output_dir=$HF_HOME/datasets/$2
regex_pattern="$3"

# Create the output directory and the 'train' subdirectory
mkdir -p "$output_dir/train"

# Copy files that match the regex from the input directory to the output directory's train subdirectory
find "$input_dir" -type f -regextype posix-extended -regex ".*/$regex_pattern" -exec cp {} "$output_dir/train" \;

# Navigate to the train directory
cd "$output_dir/train"

# Create metadata.jsonl file
touch metadata.jsonl

# Loop over each file that matches the regex in the train directory
for file in $(ls | grep -E "$regex_pattern"); do
    # Extract the base name of the file
    base_name=$(basename "$file")

    # Remove the 'o_' prefix if present and then generate the descriptive text
    cleaned_name=$(echo "$base_name" | sed 's/^o_//')
    text=$(echo "$cleaned_name" | sed -E 's/(_[0-9]+)?\..+$//; s/-/ /g; s/([a-z])([A-Z])/\1 \2/g; s/\b(.)/\u\1/g')

    # Append a record to the metadata.jsonl
    echo "{\"file_name\": \"$base_name\", \"text\": \"$text\"}" >> metadata.jsonl
done

echo "Processing complete."

