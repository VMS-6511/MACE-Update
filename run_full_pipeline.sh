#!/bin/bash

CUDA_VISIBLE_DEVICES="0,1"
ALGO_NAME="MACE"
CHANGE="mapping=person"
TASK="celebrity"
CONFIG="erase_cele_5"
PORT_NUMBER=29500
PROMPTS_CSV="celebrity_10_concepts"
FINETUNE_ALGO="lora"
FINETUNE_TASK="celebrity"
FINETUNE_CONFIG="celebrity_random_concepts"
METRIC="CLIP"
RANDOM_SEED=0

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

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

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude-ft.sh

echo "STARTING FINETUNING"
FINETUNE_JOB_OUTPUT=$(./slurm/scripts/finetuning/launch_finetune_job.sh $ALGO_NAME $CHANGE $FINETUNE_ALGO $TASK $CONFIG $FINETUNE_TASK $FINETUNE_CONFIG $PORT_NUMBER $RANDOM_SEED)
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