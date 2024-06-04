#!/bin/bash

source ~/.bashrc
conda activate mace-update

ALGO_NAME=$2
NUM_CELEBS=$3
PORT_NUMBER=$4
LORA_WEIGHTS=$5
CHECKPOINT=$6


CUDA_VISIBLE_DEVICES=$1 accelerate launch \
          --multi_gpu --num_processes=2 --main_process_port $PORT_NUMBER \
          src/sample_images_from_csv.py \
          --prompts_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/prompts_csv/celebrity_${NUM_CELEBS}_concepts.csv \
          --save_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}_${LORA_WEIGHTS}_checkpoint_${CHECKPOINT}_cele_${NUM_CELEBS} \
          --model_name /data/healthy-ml/scratch/vinithms/projects/MACE-Update/saved_model/LoRA_fusion_model/${ALGO_NAME}_cele_${NUM_CELEBS} \
          --lora_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/saved_model/cele_${NUM_CELEBS}_${LORA_WEIGHTS}/checkpoint-${CHECKPOINT}/pytorch_lora_weights.safetensors \
          --step 1

# CUDA_VISIBLE_DEVICES=$1 accelerate launch \
#           --multi_gpu --num_processes=2 --main_process_port 31369 \
#           src/sample_images_from_csv.py \
#           --prompts_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/prompts_csv/celebrity_1_concepts.csv \
#           --save_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/baseline_cele_1 \
#           --model_name /data/healthy-ml/scratch/vinithms/projects/MACE-Update/erase_1_celebrity \
#           --step 1