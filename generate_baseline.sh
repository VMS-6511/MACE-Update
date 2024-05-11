#!/bin/bash

# Source system-wide and user-specific profiles
source /etc/profile
source ~/.bash_profile

# Activate the conda environment named "mace2"
source activate mace2

# Usage check
if [ $# -ne 2 ]; then
  echo "Usage: $0 <prompts_path> <output_dir>"
  exit 1
fi

# Assign arguments to variables
prompts_path=$1
output_dir=$2

mkdir -p "$output_dir"

# Execute the Python script without arguments
python src/sample_images_from_csv.py --model_name="CompVis/stable-diffusion-v1-4" --prompts_path="$prompts_path" --save_path="$output_dir" --step=1
