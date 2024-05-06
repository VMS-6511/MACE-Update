#!/bin/bash

conda activate mace

OUTPUT_DIR=$2
FINAL_SAVE_PATH=$3

for i in 1 5 10 100; do
	sed 's/^\(output_dir: \).*$/\1${OUTPUT_DIR}_cele_${i}/' /data/healthy-ml/scratch/vinithms/projects/MACE-Update/configs/object/erase_cele_${i}.yaml
	sed 's/^\(final_save_path: \).*$/\1${FINAL_SAVE_PATH}_cele_${i}/' /data/healthy-ml/scratch/vinithms/projects/MACE-Update/configs/object/erase_cele_${i}.yaml
	CUDA_VISIBLE_DEVICES=$1 python training.py /data/healthy-ml/scratch/vinithms/projects/MACE-Update/configs/object/erase_cele_${i}.yaml
done
