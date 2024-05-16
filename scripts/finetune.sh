#!/bin/bash

# Source system-wide and user-specific profiles
source /etc/profile
source ~/.bash_profile

# Activate the conda environment named "mace2"
source activate mace2

# Usage check
if [ $# -ne 3 ]; then
  echo "Usage: $0 <model_directory> <train_data_directory> <output_directory>"
  exit 1
fi

# Assign arguments to variables
model_dir=$1
train_data_dir=$2
output_dir=$3

mkdir -p "$output_dir"

# Launch the training with the provided directories
accelerate launch train_text_to_image_lora.py \
  --pretrained_model_name_or_path="$model_dir" \
  --train_data_dir="$train_data_dir" \
  --dataloader_num_workers=1 \
  --resolution=512 --center_crop --random_flip \
  --train_batch_size=1 \
  --gradient_accumulation_steps=4 \
  --max_train_steps=1000 \
  --learning_rate=1e-04 \
  --max_grad_norm=1 \
  --lr_scheduler="cosine" --lr_warmup_steps=0 \
  --output_dir="$output_dir" \
  --checkpointing_steps=100 \
  --seed=1337

