
#!/bin/bash

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/slurm/scripts/prelude.sh

# Usage check
if [ $# -ne 3 ]; then
  echo "Usage: $0 <cuda_visible_devices> <task> <config>"
  exit 1
fi

# Assign arguments to variables
CUDA_VISIBLE_DEVICES=$1
TASK=$2
CONFIG=$3
PROMPTS_PATH=${PREFIX}/tasks/${TASK}/${CONFIG}.csv
OUTPUT_DIR=${PREFIX}/data/finetuning/${TASK}/${CONFIG}

mkdir -p "$OUTPUT_DIR"

# Execute the Python script without arguments
python $PREFIX/inference/sample_images_from_csv.py --model_name="CompVis/stable-diffusion-v1-4" --prompts_path="$PROMPTS_PATH" --save_path="$OUTPUT_DIR" --step=1

if [ "$TASK" = "celebrity" ]; then
    if [ -d "$OUTPUT_DIR/erased" ]; then
        bash $PREFIX/data/finetuning/update_metadata.sh $OUTPUT_DIR/erased
    fi

    if [ -d "$OUTPUT_DIR/others" ]; then
        bash $PREFIX/data/finetuning/update_metadata.sh $OUTPUT_DIR/others
    fi
else
    bash $PREFIX/data/finetuning/update_metadata.sh $OUTPUT_DIR
fi
