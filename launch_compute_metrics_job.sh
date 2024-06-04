#!/bin/bash

source ~/.bashrc
conda activate mace-update

NUM_CELEBS=$1
ALGO_NAME=$2

echo compute_metrics_celeb_${ALGO_NAME}_$NUM_CELEBS
bash ./launch_gpu_slurm_job_v2.sh compute_metrics_model_celeb_${ALGO_NAME}_$NUM_CELEBS gpu:2 ./compute_metrics.sh 0,1 $NUM_CELEBS ${ALGO_NAME} 
