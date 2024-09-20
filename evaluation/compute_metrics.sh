#!/bin/bash

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

ALGO_NAME=$2
CHANGE=$3
TASK=$4
CONFIG=$5
PORT_NUMBER=$6
PROMPTS_CSV=$7
METRIC=$8
RANDOM_SEED=$9

mkdir -p $PREFIX/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}/results/${PROMPTS_CSV}/
RESULTS_FILE=$PREFIX/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}/results/${PROMPTS_CSV}/${METRIC}_metrics.csv

echo $METRIC
if [ "$METRIC" == "FID" ]; then

    CUDA_VISIBLE_DEVICES=$1 python $PREFIX/evaluation/evaluate_fid.py --dir1 /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}/inference/${PROMPTS_CSV}/ --dir2 '/data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/data/mscoco-30k'

elif [ "$METRIC" == "CLIP" ]; then
    echo "CLIP SCORES FOR INITIAL MODEL"
    CUDA_VISIBLE_DEVICES=$1 python $PREFIX/evaluation/evaluate_clip_score.py --image_dir $PREFIX/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/ --prompts_path $PREFIX/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}/prompts.csv --results_file $RESULTS_FILE
    # Check if the directory exists
    FINETUNE_DIR="$PREFIX/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}/finetune/lora/celebrity_celebrity_finetune_concepts/inference"
    if [ ! -d "$FINETUNE_DIR" ]; then
        echo "Directory $FINETUNE_DIR does not exist. Skipping CLIP evaluation for finetuned model."
    else
        echo "Directory $FINETUNE_DIR exists. Proceeding with CLIP evaluation for finetuned model."
        echo "CLIP SCORES FOR FINETUNED MODEL"
        CUDA_VISIBLE_DEVICES=$1 python $PREFIX/evaluation/evaluate_clip_score.py --image_dir $FINETUNE_DIR/${PROMPTS_CSV}/ --prompts_path $FINETUNE_DIR/${PROMPTS_CSV}/prompts.csv --results_file $RESULTS_FILE
    fi
    

elif [ "$METRIC" == "GCD" ]; then

    conda deactivate

    conda activate GCD

    export APP_DATA_DIR=$PREFIX/celeb-detection-oss/examples/resources
    export APP_RECOGNITION_WEIGHTS_FILE=face_recognition/best_model_states.pkl

    CUDA_VISIBLE_DEVICES=$1 python $PREFIX/evaluation/evaluate_by_GCD.py --image_folder /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}/inference/${PROMPTS_CSV}/erased --save_excel_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}/results/${PROMPTS_CSV}/erased --results_file $RESULTS_FILE
    CUDA_VISIBLE_DEVICES=$1 python $PREFIX/evaluation/evaluate_by_GCD.py --image_folder /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}/inference/${PROMPTS_CSV}/others --save_excel_path /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}/results/${PROMPTS_CSV}/others --results_file $RESULTS_FILE

    conda deactivate
else
    echo "Metric not supported"
fi