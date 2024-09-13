source ~/.bashrc
# conda activate mace-update-v4-ft
conda activate mace-update-v5


PREFIX=/data/healthy-ml/scratch/vinithms/projects/MACE-Update

DATA_DIR=${PREFIX}/data/Celeba_HQ_dialog
UNLABELED_DIR=/data/healthy-ml/gobi1/data/Celeba_HQ_dialog
EMBEDDINGS_DIR=$UNLABELED_DIR/embeddings

mkdir -p $EMBEDDINGS_DIR

clip-retrieval inference --input_dataset "$DATA_DIR" --output_folder "$EMBEDDINGS_DIR"