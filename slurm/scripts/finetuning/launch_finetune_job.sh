#!/bin/bash

<<<<<<< HEAD
. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/slurm/scripts/prelude-ft.sh
=======
source ~/.bashrc
conda activate mace-update-v5-ft


PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness
>>>>>>> origin/refactor_final/vinith

ALGO_NAME=$1
CHANGE=$2
FINETUNE_ALGO=$3
ORIG_TASK=$4
ORIG_CONFIG=$5
FINETUNE_TASK=$6
FINETUNE_CONFIG=$7

echo finetune_model_${ALGO_NAME}_${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}_${FINETUNE_ALGO}_${FINETUNE_TASK}_${FINETUNE_CONFIG}
bash $PREFIX/slurm/scripts/launch_gpu_slurm_job_v4.sh finetune_model_${ALGO_NAME}_${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}_${FINETUNE_ALGO}_${FINETUNE_TASK}_${FINETUNE_CONFIG} gpu:2 $PREFIX/finetuning/finetune_model.sh "$@"
