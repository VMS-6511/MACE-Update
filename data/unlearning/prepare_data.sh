#!/bin/bash

<<<<<<< HEAD
. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh
=======
source ~/.bashrc
conda activate mace-update-v4

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update
>>>>>>> origin/refactor_final/vinith

TASK=$2
CONFIG=$3

CUDA_VISIBLE_DEVICES=$1 python $PREFIX/data/unlearning/data_preparation.py $PREFIX/tasks/${TASK}/${CONFIG}.yaml