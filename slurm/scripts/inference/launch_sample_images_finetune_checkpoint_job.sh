#!/bin/bash

source ~/.bashrc
conda activate mace-update

NUM_CELEBS=$1
ALGO_NAME=$2
PORT_NUMBER=$3
LORA_WEIGHTS=$4
CHECKPOINT=$5


echo sample_images_${ALGO_NAME}_${LORA_WEIGHTS}_checkpoint${CHECKPOINT}_celeb_${NUM_CELEBS}
bash ./launch_gpu_slurm_job_v5.sh sample_images_${ALGO_NAME}_${LORA_WEIGHTS}_$NUM_CELEBS gpu:2 ./sample_images_finetune_checkpoint.sh 0,1 $ALGO_NAME $NUM_CELEBS $PORT_NUMBER $LORA_WEIGHTS $CHECKPOINT
