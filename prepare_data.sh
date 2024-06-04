#!/bin/bash

source ~/.bashrc
conda activate mace-update

NUM_CELEBS=$2

CUDA_VISIBLE_DEVICES=$1 python ./data_preparation.py /data/healthy-ml/scratch/vinithms/projects/MACE-Update/configs/celebrity/erase_cele_${NUM_CELEBS}.yaml