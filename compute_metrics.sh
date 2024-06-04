#!/bin/bash

source ~/.bashrc
conda activate mace-update

NUM_CELEBS=$2
ALGO_NAME=$3

# CUDA_VISIBLE_DEVICES=$1 python metrics/evaluate_fid.py --dir1 /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}_cele_${NUM_CELEBS}/others --dir2 '/data/healthy-ml/scratch/vinithms/projects/MACE-Update/mscoco-30k'

# CUDA_VISIBLE_DEVICES=$1 python metrics/evaluate_clip_score.py --image_dir /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}_cele_${NUM_CELEBS} --prompts_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/prompts_csv/celebrity_${NUM_CELEBS}_concepts.csv

# conda deactivate

conda activate GCD

export APP_DATA_DIR=celeb-detection-oss/examples/resources
export APP_RECOGNITION_WEIGHTS_FILE=face_recognition/best_model_states.pkl

CUDA_VISIBLE_DEVICES=$1 python metrics/evaluate_by_GCD.py --image_folder /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}_cele_${NUM_CELEBS}/erased --save_excel_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}_cele_${NUM_CELEBS}/erased
CUDA_VISIBLE_DEVICES=$1 python metrics/evaluate_by_GCD.py --image_folder /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}_cele_${NUM_CELEBS}/others --save_excel_path /data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/${ALGO_NAME}_cele_${NUM_CELEBS}/others

conda deactivate