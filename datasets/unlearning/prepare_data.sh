#!/bin/bash

source ~/.bashrc
conda activate mace-update-v4

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update

TASK=$2
CONFIG=$3

CUDA_VISIBLE_DEVICES=$1 python $PREFIX/datasets/unlearning/data_preparation.py $PREFIX/configs/${TASK}/${CONFIG}.yaml