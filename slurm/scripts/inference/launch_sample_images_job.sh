#!/bin/bash

source ~/.bashrc
conda activate mace-update-v4

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update

CUDA_VISIBLE_DEVICES=$1
ALGO_NAME=$2
TASK=$3
CONFIG=$4
PORT_NUMBER=$5
PROMPTS_CSV=$6

echo sample_images_${ALGO_NAME}_${TASK}_${CONFIG}_${PROMPTS_CSV}
bash $PREFIX/slurm/scripts/launch_gpu_slurm_job_v3.sh sample_images_${ALGO_NAME}_${TASK}_${CONFIG}_${PROMPTS_CSV} gpu:2 $PREFIX/sample_images.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV
