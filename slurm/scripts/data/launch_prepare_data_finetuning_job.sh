#!/bin/bash
. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/slurm/scripts/prelude.sh

slurm/scripts/data/launch_prepare_data_job.sh

TASK=$1
CONFIG=$2

echo data_preparation_finetuning_${TASK}_$CONFIG
bash $PREFIX/slurm/scripts/launch_data_gpu_slurm_job.sh data_preparation_finetuning_${TASK}_$CONFIG gpu:2 $PREFIX/data/finetuning/generate_baseline.sh 0,1 $TASK ${CONFIG}