#!/bin/bash

source ~/.bashrc
conda activate mace-update

NUM_CELEBS=$1
ALGO_NAME=$2

echo train_model_celeb_${ALGO_NAME}_$NUM_CELEBS
bash ./launch_gpu_slurm_job_v2.sh train_model_celeb_${ALGO_NAME}_$NUM_CELEBS gpu:2 ./train_model.sh 0,1 ${ALGO_NAME} $NUM_CELEBS
