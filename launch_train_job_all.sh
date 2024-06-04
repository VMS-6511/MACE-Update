#!/bin/bash

source ~/.bashrc
conda activate mace-update

for NUM_CELEBS in 1 5 10; do
    for ALGO_NAME in last_timestep; do
        echo train_model_celeb_${ALGO_NAME}_$NUM_CELEBS
        bash ./launch_gpu_slurm_job_v2.sh train_model_celeb_${ALGO_NAME}_$NUM_CELEBS gpu:2 ./train_model.sh 0,1 ${ALGO_NAME} $NUM_CELEBS
    done
done
