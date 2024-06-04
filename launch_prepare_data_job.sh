#!/bin/bash

source ~/.bashrc
conda activate mace-update-data

NUM_CELEBS=$1

echo data_preparation_celeb_$NUM_CELEBS
bash ./launch_cpu_slurm_job.sh data_preparation_celeb_$NUM_CELEBS gpu:2 ./prepare_data.sh 0,1 $NUM_CELEBS
