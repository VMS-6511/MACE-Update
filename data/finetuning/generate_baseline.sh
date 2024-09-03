
#!/bin/bash

# Source system-wide and user-specific profiles
source ~/.bashrc

# Activate the conda environment named "mace2"
conda activate mace-update-v5

# Usage check
if [ $# -ne 3 ]; then
  echo "Usage: $0 <cuda_visible_devices> <task> <config>"
  exit 1
fi

# Assign arguments to variables
PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness
CUDA_VISIBLE_DEVICES=$1
TASK=$2
CONFIG=$3
PROMPTS_PATH=${PREFIX}/tasks/${TASK}/${CONFIG}.csv
OUTPUT_DIR=${PREFIX}/data/finetuning/${TASK}/${CONFIG}

mkdir -p "$OUTPUT_DIR"

# Execute the Python script without arguments
python $PREFIX/inference/sample_images_from_csv.py --model_name="CompVis/stable-diffusion-v1-4" --prompts_path="$PROMPTS_PATH" --save_path="$OUTPUT_DIR" --step=1

bash $PREFIX/data/finetuning/update_metadata.sh $OUTPUT_DIR