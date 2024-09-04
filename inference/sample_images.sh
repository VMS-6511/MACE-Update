#!/bin/bash

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/slurm/scripts/prelude.sh

ALGO_NAME=$2
CHANGE=$3
TASK=$4
CONFIG=$5
PORT_NUMBER=$6
PROMPTS_CSV=$7

mkdir /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}
ln -s /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/tasks/${TASK}/${PROMPTS_CSV}.csv /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/prompts.csv 

CUDA_VISIBLE_DEVICES=$1 accelerate launch \
          --multi_gpu --num_processes=2 --main_process_port $PORT_NUMBER \
          $PREFIX/inference/sample_images_from_csv.py \
          --prompts_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/tasks/${TASK}/${PROMPTS_CSV}.csv \
          --save_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV} \
          --model_name /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/LoRA_fusion_model/ \
          --step 1