#!/bin/bash


num_images=$1
prompt=$2
model_path=$3
save_path=$4

HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 HF_HUB_OFFLINE=1 CUDA_VISIBLE_DEVICES=0 python inference.py \
          --num_images $num_images \
          --prompt $prompt \
          --model_path $model_path \
          --save_path $save_path
