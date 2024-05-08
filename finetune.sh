#!/bin/bash

#SBATCH -c 4               # Number of CPU cores
#SBATCH --mem=30G          # Amount of CPU RAM
#SBATCH --gres=gpu:volta:1
#SBATCH -o ./logs/slurm-%j.out

# Loading the required module
source /etc/profile
module load anaconda/2023a
module load cuda/11.8

source ~/.bash_profile

source activate mace3

sh /home/gridsan/ralur/sync_hf_cache.sh

export HF_HOME=/state/partition1/user/ralur/.cache/huggingface/hub


HF_DATASETS_OFFLINE=1 TRANSFORMERS_OFFLINE=1 HF_HUB_OFFLINE=1 accelerate launch train_text_to_image_lora.py \
  --pretrained_model_name_or_path="/home/gridsan/ralur/MACE-Update/saved_model/LoRA_fusion_model_first_timestep" \
  --train_data_dir="/state/partition1/user/ralur/.cache/huggingface/hub/datasets/test_data" \
  --dataloader_num_workers=8 \
  --resolution=512 --center_crop --random_flip \
  --train_batch_size=1 \
  --gradient_accumulation_steps=4 \
  --max_train_steps=5 \
  --learning_rate=1e-04 \
  --max_grad_norm=1 \
  --lr_scheduler="cosine" --lr_warmup_steps=0 \
  --output_dir="./" \
  --validation_prompt="Totoro" \
  --checkpointing_steps=2 \
  --seed=1337
