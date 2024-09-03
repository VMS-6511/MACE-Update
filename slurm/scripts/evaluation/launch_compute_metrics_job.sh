#!/bin/bash

source ~/.bashrc
conda activate mace-update-v5

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness


CUDA_VISIBLE_DEVICES=$1
ALGO_NAME=$2
CHANGE=$3
TASK=$4
CONFIG=$5
PORT_NUMBER=$6
PROMPTS_CSV=$7
METRIC=$8



echo compute_metrics_${ALGO_NAME}_${CHANGE}_${TASK}_${CONFIG}_${PROMPTS_CSV}_${METRIC}
bash $PREFIX/slurm/scripts/launch_gpu_slurm_job_v6.sh compute_metrics_${ALGO_NAME}_${CHANGE}_${TASK}_${CONFIG}_${PROMPTS_CSV}_${METRIC} gpu:2 $PREFIX/evaluation/compute_metrics.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV $METRIC
