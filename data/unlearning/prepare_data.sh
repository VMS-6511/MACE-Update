#!/bin/bash

source ~/.bashrc
conda activate mace-update-v4

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness

TASK=$2
CONFIG=$3

CUDA_VISIBLE_DEVICES=$1 python $PREFIX/data/unlearning/data_preparation.py $PREFIX/tasks/${TASK}/${CONFIG}.yaml