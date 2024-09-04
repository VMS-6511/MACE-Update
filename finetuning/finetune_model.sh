#!/bin/bash

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Robustness/slurm/scripts/prelude-ft.sh

ALGO_NAME=$1
CHANGE=$2
FINETUNE_ALGO=$3
ORIG_TASK=$4
ORIG_CONFIG=$5
FINETUNE_TASK=$6
FINETUNE_CONFIG=$7

export MODEL_NAME="${PREFIX}/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/LoRA_fusion_model"
export TRAIN_DIR="${PREFIX}/data/finetuning/${FINETUNE_TASK}/${FINETUNE_CONFIG}/others"
export OUTPUT_DIR="${PREFIX}/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/finetune/${FINETUNE_ALGO}/${FINETUNE_TASK}_${FINETUNE_CONFIG}"

if [ $FINETUNE_ALGO == "full" ]; then
  accelerate launch $PREFIX/finetuning/train_text_to_image.py \
    --pretrained_model_name_or_path=$MODEL_NAME \
    --train_data_dir=$TRAIN_DIR \
    --use_ema \
    --resolution=512 --center_crop --random_flip \
    --train_batch_size=8 \
    --gradient_accumulation_steps=4 \
    --gradient_checkpointing \
    --mixed_precision="fp16" \
    --max_train_steps=1000 \
    --learning_rate=1e-05 \
    --max_grad_norm=1 \
    --lr_scheduler="constant" --lr_warmup_steps=0 \
    --output_dir=${OUTPUT_DIR} \
    --checkpointing_steps=100 \
    --seed=1337

elif [ $FINETUNE_ALGO == "lora" ]; then
  accelerate launch $PREFIX/finetuning/train_text_to_image_lora.py \
    --pretrained_model_name_or_path=$MODEL_NAME \
    --train_data_dir=$TRAIN_DIR \
    --dataloader_num_workers=1 \
    --resolution=512 --center_crop --random_flip \
    --train_batch_size=1 \
    --gradient_accumulation_steps=4 \
    --max_train_steps=1000 \
    --learning_rate=1e-04 \
    --max_grad_norm=1 \
    --lr_scheduler="cosine" --lr_warmup_steps=0 \
    --output_dir=${OUTPUT_DIR} \
    --checkpointing_steps=100 \
    --seed=1337
else
  echo "Finetuning method '$FINETUNE_ALGO' is not supported. Valid options are 'full' and 'lora'."
fi