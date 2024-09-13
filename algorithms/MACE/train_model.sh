#!/bin/bash

source ~/.bashrc
conda activate mace-update-v5

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update
CUDA_VISIBLE_DEVICES=$1
ALGO_NAME=$2
CHANGE=$3
TASK=$4
CONFIG=$5


YAML_FILE=$PREFIX/tasks/${TASK}/${CONFIG}.yaml
mkdir -p ${PREFIX}/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/

shift 5

while [[ "$#" -gt 0 ]]; do
    FIELD_PATH="$1"    # Get the first argument
    shift        # Shift to the next argument
    NEW_VALUE="$1"    # Get the second argument
    shift        # Shift to the next argument

    # Do something with arg1 and arg2
    echo "Argument pair: ${FIELD_PATH}, ${NEW_VALUE}"
    python $PREFIX/tasks/update_yaml.py $YAML_FILE 'MACE.'"${FIELD_PATH}"'='"${NEW_VALUE}"
done

old_path="./saved_model/CFR_with_multi_LoRAs"
new_path="${PREFIX}/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/CFR_with_multi_LoRAs"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"

old_path="./saved_model/LoRA_fusion_model"
new_path="${PREFIX}/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/LoRA_fusion_model"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"

cp $YAML_FILE ${PREFIX}/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/params.yaml

CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES python $PREFIX/algorithms/${ALGO_NAME}/training.py $YAML_FILE

new_path="./saved_model/CFR_with_multi_LoRAs"
old_path="${PREFIX}/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/CFR_with_multi_LoRAs"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')


sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"

new_path="./saved_model/LoRA_fusion_model"
old_path="${PREFIX}/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/LoRA_fusion_model"

# Escape slashes since they're used as delimiters in sed
escaped_old_path=$(echo "$old_path" | sed 's_/_\\/_g')
escaped_new_path=$(echo "$new_path" | sed 's_/_\\/_g')

sed -i "s/$escaped_old_path/$escaped_new_path/" "$YAML_FILE"