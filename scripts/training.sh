#!/bin/bash

# Source system-wide and user-specific profiles
source /etc/profile
source ~/.bash_profile

# Activate the conda environment named "mace2"
source activate mace3

module load cuda/12.4

# Launch the training with the provided directories
CUDA_VISIBLE_DEVICES=0 python /home/ralur/MACE-Update/training.py /home/ralur/MACE-Update/configs/celebrity/erase_cele_5.yaml
CUDA_VISIBLE_DEVICES=0 python /home/ralur/MACE-Update/training.py /home/ralur/MACE-Update/configs/celebrity/erase_cele_5_reg.yaml

