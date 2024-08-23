#!/bin/bash

source ~/.bashrc
conda activate mace-update-v4

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update

ALGO_NAME=$2
TASK=$3
CONFIG=$4
PORT_NUMBER=$5
PROMPTS_CSV=$6


CUDA_VISIBLE_DEVICES=$1 accelerate launch \
          --multi_gpu --num_processes=2 --main_process_port $PORT_NUMBER \
          src/sample_images_from_csv.py \
          --prompts_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/prompts_csv/${PROMPTS_CSV}.csv \
          --save_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}_${TASK}_${CONFIG}_${PROMPTS_CSV} \
          --model_name /data/healthy-ml/scratch/vinithms/projects/MACE-Update/saved_model/LoRA_fusion_model/${ALGO_NAME}_${TASK}_${CONFIG} \
          --step 1

# CUDA_VISIBLE_DEVICES=$1 accelerate launch \
#           --multi_gpu --num_processes=2 --main_process_port 31369 \
#           src/sample_images_from_csv.py \
#           --prompts_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/prompts_csv/celebrity_1_concepts.csv \
#           --save_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/baseline_cele_1 \
#           --model_name /data/healthy-ml/scratch/vinithms/projects/MACE-Update/erase_1_celebrity \
#           --step 1


# CUDA_VISIBLE_DEVICES=$1 accelerate launch \
#           --multi_gpu --num_processes=2 --main_process_port $PORT_NUMBER \
#           src/sample_images_from_csv.py \
#           --prompts_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/prompts_csv/celebrity_${NUM_CELEBS}_concepts.csv \
#           --save_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}_cele_${NUM_CELEBS}_finetune_full_1000_steps \
#           --model_name /data/healthy-ml/scratch/vinithms/projects/MACE-Update/finetuned_model/uce_10_celeb_full_1000_steps \
#           --step 1