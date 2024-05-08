#!/bin/bash
#SBATCH --job-name=inference           # Job name
#SBATCH --partition=gpu                # Partition (job queue)
#SBATCH --gres=gpu:1                   # Request one GPU
#SBATCH --mem=20G                       # Memory total in MB (for all cores)
#SBATCH --time=00:30:00                # Time limit hrs:min:sec
#SBATCH --output=inference_%j.log      # Standard output and error log

module load cuda/10.1                  # Load CUDA module if necessary
module load python/3.7                 # Load Python module if necessary

CUDA_VISIBLE_DEVICES=0 python training.py configs/object/erase_cele_1.yaml
