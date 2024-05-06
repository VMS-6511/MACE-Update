#!/bin/bash

conda activate mace

ALGO_NAME=$2

for i in 1 5 10 100; do
	CUDA_VISIBLE_DEVICES=$1 accelerate launch \
          --multi_gpu --num_processes=$2 --main_process_port 31372 \
          src/sample_images_from_csv.py \
          --prompts_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/prompts_csv/celebrity_${i}_concepts.csv \
          --save_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}/cele_${i} \
          --model_name /data/healthy-ml/scratch/vinithms/projects/MACE-Update/saved_model/${ALGO_NAME}_cele_${i} \
          --step 1
done
