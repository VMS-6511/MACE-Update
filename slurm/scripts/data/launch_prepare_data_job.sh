#!/bin/bash

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

TASK=$1
CONFIG=$2

echo data_preparation_${TASK}_$CONFIG
bash $PREFIX/slurm/scripts/launch_data_gpu_slurm_job.sh data_preparation_${TASK}_$CONFIG gpu:1 $PREFIX/data/unlearning/prepare_data.sh 0,1 $TASK ${CONFIG}
