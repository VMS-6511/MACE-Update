#!/bin/bash

source ~/.bashrc
conda activate mace-update

NUM_CELEBS=$1
ALGO_NAME=$2

echo generate_baseline_celeb_${ALGO_NAME}_$NUM_CELEBS
bash ./launch_gpu_slurm_job_v2.sh generate_baseline_celeb_${ALGO_NAME}_$NUM_CELEBS gpu:2 ./generate_baseline.sh /data/healthy-ml/scratch/vinithms/projects/MACE-Update/prompts_csv/celebrity_finetune_large.csv /data/healthy-ml/scratch/vinithms/projects/MACE-Update/data/failure_finetune/
