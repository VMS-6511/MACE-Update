
source ~/.bashrc
conda activate mace-update


ALGO_NAME=$2
NUM_CELEBS=$3

export MODEL_NAME="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/saved_model/LoRA_fusion_model/${ALGO_NAME}_cele_${NUM_CELEBS}"
export TRAIN_DIR="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/data/failure_finetune/others"
export OUTPUT_DIR="/data/healthy-ml/scratch/vinithms/projects/MACE-Update/finetuned_model/${ALGO_NAME}_${NUM_CELEBS}_celeb"

./scripts/finetune.sh $MODEL_NAME $TRAIN_DIR $OUTPUT_DIR