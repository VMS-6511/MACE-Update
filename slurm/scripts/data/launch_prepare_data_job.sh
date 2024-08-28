#!/bin/bash

source ~/.bashrc
conda activate mace-update-v4

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness

TASK=$1
CONFIG=$2

echo data_preparation_${TASK}_$CONFIG
bash $PREFIX/slurm/scripts/launch_data_gpu_slurm_job.sh data_preparation_${TASK}_$CONFIG gpu:2 $PREFIX/data/unlearning/prepare_data.sh 0,1 $TASK ${CONFIG}
