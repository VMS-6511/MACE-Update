#!/bin/bash

# Source the prelude script
. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

CUDA_VISIBLE_DEVICES=$1
ALGO_NAME=$2
CHANGE=$3
TASK=$4
CONFIG=$5

echo train_model_${ALGO_NAME}_${CHANGE}_${TASK}_$CONFIG
bash $PREFIX/slurm/scripts/launch_gpu_slurm_job_v2.sh train_model_${ALGO_NAME}_${CHANGE}_${TASK}_$CONFIG gpu:2 $PREFIX/algorithms/${ALGO_NAME}/train_model.sh "$@"
