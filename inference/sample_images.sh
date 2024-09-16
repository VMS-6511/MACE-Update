#!/bin/bash

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

ALGO_NAME=$2
CHANGE=$3
TASK=$4
CONFIG=$5
PORT_NUMBER=$6
PROMPTS_CSV=$7

mkdir -p /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}
if [ ! -e "/data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/prompts.csv" ]; then
    ln -s /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/tasks/${TASK}/${PROMPTS_CSV}.csv /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/prompts.csv 
else
    echo "Symbolic link for prompts.csv already exists, continuing without creating new one."
fi
CUDA_VISIBLE_DEVICES=$1 accelerate launch \
          --multi_gpu --num_processes=2 --main_process_port $PORT_NUMBER \
          $PREFIX/inference/sample_images_from_csv.py \
          --prompts_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/tasks/${TASK}/${PROMPTS_CSV}.csv \
          --save_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV} \
          --model_name /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/LoRA_fusion_model/ \
          --step 1