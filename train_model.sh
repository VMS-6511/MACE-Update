#!/bin/bash

source ~/.bashrc
conda activate mace-update

ALGO_NAME=$2
NUM_CELEBS=$3

old_path="./saved_model/CFR_with_multi_LoRAs"
new_path="./saved_model/CFR_with_multi_LoRAs/${ALGO_NAME}_cele_${NUM_CELEBS}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

yaml_file="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/configs/celebrity/erase_cele_${NUM_CELEBS}.yaml"


sed -i "s/$escaped_old_path/$escaped_new_path/" "$yaml_file"

old_path="./saved_model/LoRA_fusion_model"
new_path="./saved_model/LoRA_fusion_model/${ALGO_NAME}_cele_${NUM_CELEBS}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$yaml_file"

old_path="./experiments/"
new_path="./experiments/${ALGO_NAME}_cele_${NUM_CELEBS}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$yaml_file"

CUDA_VISIBLE_DEVICES=$1 python training.py /data/healthy-ml/scratch/vinithms/projects/MACE-Update/configs/celebrity/erase_cele_${NUM_CELEBS}.yaml

new_path="./saved_model/CFR_with_multi_LoRAs"
old_path="./saved_model/CFR_with_multi_LoRAs/${ALGO_NAME}_cele_${NUM_CELEBS}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

yaml_file="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/configs/celebrity/erase_cele_${NUM_CELEBS}.yaml"


sed -i "s/$escaped_old_path/$escaped_new_path/" "$yaml_file"

new_path="./saved_model/LoRA_fusion_model"
old_path="./saved_model/LoRA_fusion_model/${ALGO_NAME}_cele_${NUM_CELEBS}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$yaml_file"

new_path="./experiments/"
old_path="./experiments/${ALGO_NAME}_cele_${NUM_CELEBS}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$yaml_file"
