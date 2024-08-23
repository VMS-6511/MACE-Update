#!/bin/bash

source ~/.bashrc
conda activate mace-update-v3


ALGO_NAME=$2
NUM_CELEBS=$3

export MODEL_NAME="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/saved_model/${ALGO_NAME}_${NUM_CELEBS}_celeb"
export TRAIN_DIR="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/data/failure_finetune/others"
export OUTPUT_DIR="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/finetuned_model/${ALGO_NAME}_${NUM_CELEBS}_celeb"

accelerate launch train_text_to_image.py \
  --pretrained_model_name_or_path=$MODEL_NAME \
  --train_data_dir=$TRAIN_DIR \
  --use_ema \
  --resolution=512 --center_crop --random_flip \
  --train_batch_size=8 \
  --gradient_accumulation_steps=4 \
  --gradient_checkpointing \
  --mixed_precision="fp16" \
  --max_train_steps=1000 \
  --learning_rate=1e-05 \
  --max_grad_norm=1 \
  --lr_scheduler="constant" --lr_warmup_steps=0 \
  --output_dir=${OUTPUT_DIR}