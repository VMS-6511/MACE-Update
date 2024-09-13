#!/bin/bash

source ~/.bashrc
conda activate mace-update-v5

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update

echo laion_embeddings
bash $PREFIX/slurm/scripts/launch_embeddings_gpu_slurm_job.sh generate_laion_embeddings gpu:1 $PREFIX/data/utils/generate_laion_embeddings.sh
