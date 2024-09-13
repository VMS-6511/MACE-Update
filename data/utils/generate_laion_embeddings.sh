source ~/.bashrc
# conda activate mace-update-v4-ft
conda activate mace-update-v5


# export OPENAI_API_KEY=<your-api-key>

PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update

LAION_DIR=${PREFIX}/data/laion400m
UNLABELED_DIR=/data/healthy-ml/gobi1/data/laion400m
EMBEDDINGS_DIR=$UNLABELED_DIR/embeddings

mkdir -p $EMBEDDINGS_DIR

clip-retrieval inference --input_dataset "$LAION_DIR" --output_folder "$EMBEDDINGS_DIR"