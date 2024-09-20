#!/bin/bash

CUDA_VISIBLE_DEVICES="0,1"
ALGO_NAME="MACE"
METRIC="CLIP"
FINETUNE_ALGO="lora"
FINETUNE_TASK="celebrity"
TASK="celebrity"
FINETUNE_CONFIG="celebrity_random_concepts_seed0"

CHANGE=$1
CONFIG=$2
PROMPTS_CSV=$3
RANDOM_SEED=$4
PORT_NUMBER=$5

BASELINE_MODEL="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/MACE/baseline_celebrity_${CONFIG}"

# CHANGE="baseline-cele-1"
# CONFIG="erase_cele_1"
# PROMPTS_CSV="celebrity_1_concepts"

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

# Check if the LoRA fusion model exists
LORA_FUSION_MODEL_PATH="/data/healthy-ml/scratch/ralur/projects/MACE-Update/experiments/MACE/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}/LoRA_fusion_model/model_index.json"

if [ -f "$LORA_FUSION_MODEL_PATH" ]; then
    echo "LoRA fusion model found at $LORA_FUSION_MODEL_PATH, skipping training"
elif [ -n "$BASELINE_MODEL" ]; then
    if [ ! -d "$BASELINE_MODEL" ]; then
        echo "Baseline model not found at $BASELINE_MODEL"
        echo "Please ensure the baseline model exists before running this script."
        exit 1
    else
        echo "Baseline model found at $BASELINE_MODEL"
    fi

    SYMLINK_PATH="/data/healthy-ml/scratch/ralur/projects/MACE-Update/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/${RANDOM_SEED}"
    
    echo "Creating symlink to baseline model..."
    mkdir -p "$SYMLINK_PATH"
    ln -sfn "${BASELINE_MODEL}/CFR_with_multi_LoRAs" "${SYMLINK_PATH}/CFR_with_multi_LoRAs"
    echo "Symlink created: ${SYMLINK_PATH}/CFR_with_multi_LoRAs -> ${BASELINE_MODEL}/CFR_with_multi_LoRAs"

    ln -sfn "${BASELINE_MODEL}/LoRA_fusion_model" "${SYMLINK_PATH}/LoRA_fusion_model"
    echo "Symlink created: ${SYMLINK_PATH}/LoRA_fusion_model -> ${BASELINE_MODEL}/LoRA_fusion_model"

    ln -sfn "${BASELINE_MODEL}/params.yaml" "${SYMLINK_PATH}/params.yaml"
    echo "Symlink created: ${SYMLINK_PATH}/params.yaml -> ${BASELINE_MODEL}/params.yaml"

    ln -sfn "${BASELINE_MODEL}/inference" "${SYMLINK_PATH}/inference"
    echo "Symlink created: ${SYMLINK_PATH}/inference -> ${BASELINE_MODEL}/inference"

else
    echo "LoRA fusion model not found at $LORA_FUSION_MODEL_PATH, proceeding with training"
    echo "STARTING TRAINING"
    TRAIN_JOB_OUTPUT=$(./slurm/scripts/training/launch_train_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $RANDOM_SEED)
    TRAIN_JOB_ID=$(echo "$TRAIN_JOB_OUTPUT" | grep -oP "Submitted batch job \K\d+")
    echo "Waiting for training job $TRAIN_JOB_ID to complete..."
    srun --dependency=afterany:$TRAIN_JOB_ID --ntasks=1 --cpus-per-task=1 --partition=healthyml --qos=healthyml-main --account=healthy-ml --time=1-00:00 sleep 1
    echo "Training job $TRAIN_JOB_ID has completed."

    echo "STARTING SAMPLING"
    SAMPLE_JOB_OUTPUT=$(./slurm/scripts/inference/launch_sample_images_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV $RANDOM_SEED)
    SAMPLE_JOB_ID=$(echo "$SAMPLE_JOB_OUTPUT" | grep -oP "Submitted batch job \K\d+")
    echo "Waiting for sampling job $SAMPLE_JOB_ID to complete..."
    srun --dependency=afterany:$SAMPLE_JOB_ID --ntasks=1 --cpus-per-task=1 --partition=healthyml --qos=healthyml-main --account=healthy-ml --time=1-00:00 sleep 1
    echo "Sampling job $SAMPLE_JOB_ID has completed."
fi



echo "Checking if finetuning data directory exists..."
FINETUNE_DATA_DIR="${PREFIX}/data/finetuning/${TASK}/${FINETUNE_CONFIG}/others"
if [ ! -d "$FINETUNE_DATA_DIR" ]; then
    echo "Finetuning data directory not found at $FINETUNE_DATA_DIR, exiting. To run the finetuning pipeline, please run the generate_baseline.sh script first."
    exit 1

    #bash ${PREFIX}/data/finetuning/generate_baseline.sh $CUDA_VISIBLE_DEVICES $TASK $CONFIG
    
else
    echo "Finetuning data directory found at $FINETUNE_DATA_DIR, proceeding with finetuning"
fi

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude-ft.sh

echo "STARTING FINETUNING"
FINETUNE_JOB_OUTPUT=$(./slurm/scripts/finetuning/launch_finetune_job.sh $ALGO_NAME $CHANGE $FINETUNE_ALGO $TASK $CONFIG $FINETUNE_TASK $FINETUNE_CONFIG $RANDOM_SEED)
FINETUNE_JOB_ID=$(echo "$FINETUNE_JOB_OUTPUT" | grep -oP "Submitted batch job \K\d+")
echo "Waiting for finetuning job $FINETUNE_JOB_ID to complete..."
srun --dependency=afterany:$FINETUNE_JOB_ID --ntasks=1 --cpus-per-task=1 --partition=healthyml --qos=healthyml-main --account=healthy-ml --time=1-00:00 sleep 1
echo "Finetuning job $FINETUNE_JOB_ID has completed."

echo "STARTING SAMPLING FROM FINETUNED MODEL"
SAMPLE_FINETUNE_JOB_OUTPUT=$(./slurm/scripts/inference/launch_sample_images_finetune_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $FINETUNE_ALGO $FINETUNE_TASK $FINETUNE_CONFIG $PORT_NUMBER $PROMPTS_CSV $RANDOM_SEED)
SAMPLE_FINETUNE_JOB_ID=$(echo "$SAMPLE_FINETUNE_JOB_OUTPUT" | grep -oP "Submitted batch job \K\d+")
echo "Waiting for sampling from finetuned model job $SAMPLE_FINETUNE_JOB_ID to complete..."
srun --dependency=afterany:$SAMPLE_FINETUNE_JOB_ID --ntasks=1 --cpus-per-task=1 --partition=healthyml --qos=healthyml-main --account=healthy-ml --time=1-00:00 sleep 1
echo "Sampling from finetuned model job $SAMPLE_FINETUNE_JOB_ID has completed."

echo "STARTING EVALUATION"
EVAL_JOB_OUTPUT=$(./slurm/scripts/evaluation/launch_compute_metrics_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV $METRIC $RANDOM_SEED)
EVAL_JOB_ID=$(echo "$EVAL_JOB_OUTPUT" | grep -oP "Submitted batch job \K\d+")
echo "Waiting for evaluation job $EVAL_JOB_ID to complete..."
srun --dependency=afterany:$EVAL_JOB_ID --ntasks=1 --cpus-per-task=1 --partition=healthyml --qos=healthyml-main --account=healthy-ml --time=1-00:00 sleep 1
echo "Evaluation job $EVAL_JOB_ID has completed."