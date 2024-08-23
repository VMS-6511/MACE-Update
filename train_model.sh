#!/bin/bash

source ~/.bashrc
conda activate mace-update-v4

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update
CUDA_VISIBLE_DEVICES=$1
ALGO_NAME=$2
TASK=$3
CONFIG=$4

YAML_FILE=$PREFIX/configs/${TASK}/${CONFIG}.yaml

shift 5

while [[ "$#" -gt 0 ]]; do
    FIELD_PATH="$1"    # Get the first argument
    shift        # Shift to the next argument
    NEW_VALUE="$1"    # Get the second argument
    shift        # Shift to the next argument

    # Do something with arg1 and arg2
    echo "Argument pair: ${FIELD_PATH}, ${NEW_VALUE}"
    python update_yaml.py $YAML_FILE 'MACE.'"${FIELD_PATH}"'='"${NEW_VALUE}"
done

old_path="./saved_model/CFR_with_multi_LoRAs"
new_path="./saved_model/CFR_with_multi_LoRAs/${ALGO_NAME}_${TASK}_${CONFIG}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')



sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"

old_path="./saved_model/LoRA_fusion_model"
new_path="./saved_model/LoRA_fusion_model/${ALGO_NAME}_${TASK}_${CONFIG}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"

old_path="./experiments/"
new_path="./experiments/${ALGO_NAME}_${TASK}_${CONFIG}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"

CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES python training.py $YAML_FILE

new_path="./saved_model/CFR_with_multi_LoRAs"
old_path="./saved_model/CFR_with_multi_LoRAs/${ALGO_NAME}_${TASK}_${CONFIG}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')


sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"

new_path="./saved_model/LoRA_fusion_model"
old_path="./saved_model/LoRA_fusion_model/${ALGO_NAME}_${TASK}_${CONFIG}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"

new_path="./experiments/"
old_path="./experiments/${ALGO_NAME}_${TASK}_${CONFIG}"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"
