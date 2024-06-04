#!/bin/bash

source ~/.bashrc
conda activate mace-update

ALGO_NAME=importance_sampling
LORA_WEIGHTS=large
PORT_NUMBER=31373
for NUM_CELEBS in 10; do
    for CHECKPOINT in 100 200 300 400 500 600 700 800 900 1000; do
        echo sample_images_${ALGO_NAME}_${LORA_WEIGHTS}_checkpoint_${CHECKPOINT}_celeb_${NUM_CELEBS}
        bash ./launch_gpu_slurm_job_v5.sh sample_images_${ALGO_NAME}_${LORA_WEIGHTS}_checkpoint_${CHECKPOINT}_$NUM_CELEBS gpu:2 ./sample_images_finetune_checkpoint.sh 0,1 $ALGO_NAME $NUM_CELEBS $PORT_NUMBER $LORA_WEIGHTS $CHECKPOINT
        PORT_NUMBER=$((PORT_NUMBER+1))
    done
done
