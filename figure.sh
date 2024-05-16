#!/bin/bash

# Source system-wide and user-specific profiles
source /etc/profile
source ~/.bash_profile

# Activate the conda environment named "mace2"
source activate mace2


/home/ralur/anaconda3/bin/python inference.py --prompt "An image of Angelina Jolie" --model_path "CompVis/stable-diffusion-v1-4" --save_path "./generated_images/baseline"

#python inference.py --prompt "An image of Adam Sandler" --model_path "CompVis/stable-diffusion-v1-4" --save_path "./generated_images/baseline"

