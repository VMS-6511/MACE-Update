#!/bin/bash

source ~/.bashrc
conda activate mace-update-v5

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness

ALGO_NAME=$2
CHANGE=$3
TASK=$4
CONFIG=$5
PORT_NUMBER=$6
PROMPTS_CSV=$7
METRIC=$8

mkdir -p $PREFIX/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/results/${PROMPTS_CSV}/
RESULTS_FILE=$PREFIX/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/results/${PROMPTS_CSV}/metrics.csv

echo $METRIC
if [ "$METRIC" == "FID" ]; then

    CUDA_VISIBLE_DEVICES=$1 python $PREFIX/evaluation/evaluate_fid.py --dir1 /data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/ --dir2 '/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/data/mscoco-30k'

elif [ "$METRIC" == "CLIP" ]; then
    
    CUDA_VISIBLE_DEVICES=$1 python $PREFIX/evaluation/evaluate_clip_score.py --image_dir /data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/ --prompts_path /data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/prompts.csv --results_file $RESULTS_FILE

elif [ "$METRIC" == "GCD" ]; then

    conda deactivate

    conda activate GCD

    export APP_DATA_DIR=$PREFIX/celeb-detection-oss/examples/resources
    export APP_RECOGNITION_WEIGHTS_FILE=face_recognition/best_model_states.pkl

    CUDA_VISIBLE_DEVICES=$1 python $PREFIX/evaluation/evaluate_by_GCD.py --image_folder /data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/erased --save_excel_path /data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/results/${PROMPTS_CSV}/erased
    CUDA_VISIBLE_DEVICES=$1 python $PREFIX/evaluation/evaluate_by_GCD.py --image_folder /data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/others --save_excel_path /data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/results/${PROMPTS_CSV}/others

    conda deactivate
else
    echo "Metric not supported"
fi