#!/bin/bash


num_images=$1
prompt="$2"
model_path=$3
save_path=$4
lora_path=$5

CUDA_VISIBLE_DEVICES=0 python inference.py \
          --num_images $num_images \
          --prompt $prompt \
          --model_path $model_path \
          --save_path $save_path \
	  --lora_path $lora_path
