#!/bin/bash

source ~/.bashrc
conda activate mace-update-v4

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update

CUDA_VISIBLE_DEVICES=$1
ALGO_NAME=$2
TASK=$3
CONFIG=$4



echo train_model_celeb_${ALGO_NAME}_${TASK}_$CONFIG
bash $PREFIX/slurm/scripts/launch_gpu_slurm_job_v2.sh train_model_celeb_${ALGO_NAME}_${TASK}_$CONFIG gpu:2 $PREFIX/train_model.sh "$@"
