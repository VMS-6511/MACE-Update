#!/bin/bash

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

TASK=$2
CONFIG=$3

CUDA_VISIBLE_DEVICES=$1 python $PREFIX/data/unlearning/data_preparation.py $PREFIX/tasks/${TASK}/${CONFIG}.yaml