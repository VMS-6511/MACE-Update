#!/bin/bash

# Base directory path
base_dir="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments"

# Check if the directory exists
if [ ! -d "$base_dir" ]; then
    echo "The directory $base_dir does not exist."
    exit 1
fi

# Initialize an array to store the names of algorithms that meet the condition
matching_algos=()

# Find all directories at a depth of 1 under base_dir
find "$base_dir" -maxdepth 1 -mindepth 1 -type d | while read algo_dir; do
    # Remove the base directory path from algo_dir for clean algorithm name output
    algo_name=$(basename $algo_dir)

    # Full path to the "erased" and "others" folders
    erased_path="${algo_dir}/erased/"
    others_path="${algo_dir}/others/"


    # Count the number of files in each directory
    erased_count=$(find "$erased_path" -type f 2>/dev/null | wc -l)
    others_count=$(find "$others_path" -type f 2>/dev/null | wc -l)

    echo $erased_count
    echo $others_count

    # Check if file counts meet the specified conditions
    if [ $erased_count -lt 250 ] || [ $others_count -lt 2500 ]; then
        # Append the algorithm name to the array
        matching_algos+=(${algo_name})
        echo "${matching_algos[@]}"
    fi
done

for key in "${matching_algos[@]}";
do
  echo "Key for fruits array is: $key"
done

echo "Algorithms that matched the criteria:"
for full_name in "${!matching_algos[@]}"; do
        # Extract the base algorithm name and the number of celebrities
        echo $full_name
        base_name=${full_name%_cele_*}
        num_celebs=${full_name##*_cele_}

        # Print details
        echo "Algorithm: $base_name, Number of Celebrities: $num_celebs"
done
