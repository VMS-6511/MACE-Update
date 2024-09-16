#!/bin/bash

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

ALGO_NAME=$2
CHANGE=$3
ORIG_TASK=$4
ORIG_CONFIG=$5
FINETUNE_ALGO=$6
FINETUNE_TASK=$7
FINETUNE_CONFIG=$8
PORT_NUMBER=$9
PROMPTS_CSV=${10}

mkdir -p /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/finetune/${FINETUNE_ALGO}/${FINETUNE_TASK}_${FINETUNE_CONFIG}/inference/${PROMPTS_CSV}
ln -s /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/tasks/${FINETUNE_TASK}/${PROMPTS_CSV}.csv /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/finetune/${FINETUNE_ALGO}/${FINETUNE_TASK}_${FINETUNE_CONFIG}/inference/${PROMPTS_CSV}/prompts.csv 

if [ $FINETUNE_ALGO == "full" ]; then

    CUDA_VISIBLE_DEVICES=$1 accelerate launch \
            --multi_gpu --num_processes=2 --main_process_port $PORT_NUMBER \
            $PREFIX/inference/sample_images_from_csv.py \
            --prompts_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/tasks/${FINETUNE_TASK}/${PROMPTS_CSV}.csv \
            --save_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/finetune/${FINETUNE_ALGO}/${FINETUNE_TASK}_${FINETUNE_CONFIG}/inference/${PROMPTS_CSV} \
            --model_name /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/finetune/${FINETUNE_ALGO}/${FINETUNE_TASK}_${FINETUNE_CONFIG} \
            --multi_gpu --num_processes=2 --main_process_port $PORT_NUMBER \
            $PREFIX/inference/sample_images_from_csv.py \
            --prompts_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/tasks/${FINETUNE_TASK}/${PROMPTS_CSV}.csv \
            --save_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/finetune/${FINETUNE_ALGO}/${FINETUNE_TASK}_${FINETUNE_CONFIG}/inference/${PROMPTS_CSV} \
            --model_name /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/LoRA_fusion_model \
            --lora_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/finetune/${FINETUNE_ALGO}/${FINETUNE_TASK}_${FINETUNE_CONFIG}/pytorch_lora_weights.safetensors \
            --step 1
else
    echo "Finetuning algorithm '${FINETUNE_ALGO}' not supported"
fi