#!/bin/bash

source ~/.bashrc
conda activate mace-update

ALGO_NAME=importance_sampling
PORT_NUMBER=31380
for NUM_CELEBS in 1 5 10; do
    for LORA_WEIGHTS in large_alternate; do
        echo sample_images_${ALGO_NAME}_${LORA_WEIGHTS}_celeb_${NUM_CELEBS}
        bash ./launch_gpu_slurm_job_v4.sh sample_images_${ALGO_NAME}_${LORA_WEIGHTS}_$NUM_CELEBS gpu:2 ./sample_images_finetune.sh 0,1 $ALGO_NAME $NUM_CELEBS $PORT_NUMBER $LORA_WEIGHTS
        PORT_NUMBER=$((PORT_NUMBER+1))
    done
done
