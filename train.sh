#!/bin/bash

#SBATCH -c 4               # Number of CPU cores
#SBATCH --mem=30G          # Amount of CPU RAM
#SBATCH --gres=gpu:volta:1
#SBATCH -o ./logs/slurm-%j.out

# Loading the required module
source /etc/profile
module load anaconda/2023a
module load cuda/11.8

source ~/.bash_profile

source activate mace3

sh /home/gridsan/ralur/sync_hf_cache.sh

export HF_HOME=/state/partition1/user/ralur/.cache/huggingface/hub

HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 HF_HUB_OFFLINE=1 CUDA_VISIBLE_DEVICES=0 python training.py configs/celebrity/erase_cele_1.yaml
