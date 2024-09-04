#!/bin/bash

<<<<<<< HEAD
# Source the prelude script
. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/slurm/scripts/prelude.sh
=======
source ~/.bashrc
conda activate mace-update-v5

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness
>>>>>>> origin/refactor_final/vinith

CUDA_VISIBLE_DEVICES=$1
ALGO_NAME=$2
CHANGE=$3
TASK=$4
CONFIG=$5

<<<<<<< HEAD
=======


>>>>>>> origin/refactor_final/vinith
echo train_model_${ALGO_NAME}_${CHANGE}_${TASK}_$CONFIG
bash $PREFIX/slurm/scripts/launch_gpu_slurm_job_v2.sh train_model_${ALGO_NAME}_${CHANGE}_${TASK}_$CONFIG gpu:2 $PREFIX/algorithms/${ALGO_NAME}/train_model.sh "$@"
