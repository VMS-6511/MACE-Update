#!/bin/bash

# Define the folder to check
folder="tmp_images"

# List of names to check against
names=("Adam Levine" "Adrienne Bailon" "Amber Riley" "Amy Schumer" "Andrew Lincoln")

# Change to the specified directory
cd "$folder"

# Loop through all files in the directory
for file in *; do
    # Flag to check if a name matches
    match_found=false

    # Check each name in the names array
    for name in "${names[@]}"; do
        # Check if the filename contains the name
        if [[ "$file" == *"$name"* ]]; then
            match_found=true
            break
        fi
    done

    # If no name matched, delete the file
    if [ "$match_found" = false ]; then
        echo "Deleting $file as it does not contain any of the specified names."
        rm "$file"
    fi
done

