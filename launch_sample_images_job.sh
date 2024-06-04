#!/bin/bash

source ~/.bashrc
conda activate mace-update

NUM_CELEBS=$1
ALGO_NAME=$2
PORT_NUMBER=$3

echo sample_images_${ALGO_NAME}_celeb_${NUM_CELEBS}
bash ./launch_gpu_slurm_job_v3.sh sample_images_${ALGO_NAME}_cele_$NUM_CELEBS gpu:2 ./sample_images.sh 0,1 $ALGO_NAME $NUM_CELEBS $PORT_NUMBER
