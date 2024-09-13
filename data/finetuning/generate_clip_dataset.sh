source ~/.bashrc
# conda activate mace-update-v4-ft
conda activate mace-update-v5


# export OPENAI_API_KEY=<your-api-key>

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update

ORIG_TASK=$1
ORIG_CONFIG=$2
FINETUNE_TASK=$3
FINETUNE_CONFIG=$4
UNLABELED_DATA=$5


FIELD_KEY="input_data_dir"
INPUT_DIR=$(grep "$FIELD_KEY" $PREFIX/tasks/${ORIG_TASK}/${ORIG_CONFIG}.yaml | awk -F ": " '{print $2}')
UNLABELED_DIR=/data/healthy-ml/gobi1/data/${UNLABELED_DATA}
OUTPUT_DIR=${PREFIX}/data/finetuning/${FINETUNE_TASK}/${FINETUNE_CONFIG}
EMBEDDINGS_DIR=$UNLABELED_DIR/embeddings/text_emb

mkdir -p $OUTPUT_DIR
python -u $PREFIX/data/finetuning/create_clip_dataset.py --input_dir=$INPUT_DIR --unlabeled_dir=$UNLABELED_DIR --embeddings_dir=$EMBEDDINGS_DIR --output_dir=$OUTPUT_DIR

mv $OUTPUT_DIR/prompts.csv $PREFIX/tasks/${FINETUNE_TASK}/${FINETUNE_CONFIG}.csv

# bash $PREFIX/data/finetuning/update_metadata.sh $OUTPUT_DIR