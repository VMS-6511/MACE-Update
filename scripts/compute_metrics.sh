#!/bin/bash

conda activate mace

ALGO_NAME=${2}

for i in 1 5 10 100; do

	CUDA_VISIBLE_DEVICES=$1 python metrics/evaluate_fid.py --dir1 /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}/cele_${i} --dir2 '/data/healthy-ml/scratch/vinithms/projects/MACE-Update/mscoco-30k'

	CUDA_VISIBLE_DEVICES=$1 python metrics/evaluate_clip_score.py --image_dir /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}/cele_${i} --prompts_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/prompts_csv/celebrity_${i}_concepts.csv

	CUDA_VISIBLE_DEVICES=$2 python metrics/evaluate_clip_accuracy.py --base_folder /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}/cele_${i}
done
