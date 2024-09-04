#!/bin/bash

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

CUDA_VISIBLE_DEVICES=$1
ALGO_NAME=$2
CHANGE=$3
TASK=$4
CONFIG=$5
PORT_NUMBER=$6
PROMPTS_CSV=$7

echo sample_images_${ALGO_NAME}_${CHANGE}_${TASK}_${CONFIG}_${PROMPTS_CSV}
bash $PREFIX/slurm/scripts/launch_gpu_slurm_job_v3.sh sample_images_${ALGO_NAME}_${CHANGE}_${TASK}_${CONFIG}_${PROMPTS_CSV} gpu:2 $PREFIX/inference/sample_images.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV
