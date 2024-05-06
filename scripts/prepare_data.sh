#!/bin/bash

conda activate mace

for i in 1 5 10 100; do
	CUDA_VISIBLE_DEVICES=$1 python data_preparation.py /data/healthy-ml/scratch/vinithms/projects/MACE-Update/configs/object/erase_cele_${i}.yaml
done
