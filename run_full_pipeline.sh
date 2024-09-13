CUDA_VISIBLE_DEVICES="0,1"
ALGO="MACE"
CHANGE="mapping=person"
TASK="celebrity"
CONFIG="erase_cele_5"
PORT_NUMBER="29500"
PROMPTS_CSV="celebrity_10_concepts"
FINETUNE_ALGO="lora"
FINETUNE_TASK="celebrity"
FINETUNE_CONFIG="celebrity_finetune_concepts"
METRIC="CLIP"

. /data/healthy-ml/scratch/$(whoami)/projects/MACE-Update/slurm/scripts/prelude.sh

echo "STARTING TRAINING"
./slurm/scripts/training/launch_train_job.sh $CUDA_VISIBLE_DEVICES $ALGO $CHANGE $TASK $CONFIG
echo "ENDED TRAINING"
echo "STARTING SAMPLING"
./slurm/scripts/inference/launch_sample_images_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV
echo "ENDED SAMPLING"
echo "STARTING FINETUNING"
./slurm/scripts/finetuning/launch_finetune_job.sh $ALGO_NAME $CHANGE $FINETUNE_ALGO $TASK $CONFIG $FINETUNE_TASK $FINETUNE_CONFIG
echo "ENDED FINETUNING"
echo "STARTING SAMPLING FROM FINETUNED MODEL"
./slurm/scripts/inference/launch_sample_images_finetune_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $FINETUNE_ALGO $FINETUNE_TASK $FINETUNE_CONFIG $PORT_NUMBER $PROMPTS_CSV
echo "ENDED SAMPLING FROM FINETUNED MODEL"
echo "STARTING EVALUATION"
./slurm/scripts/evaluation/launch_compute_metrics_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV $METRIC
echo "ENDING EVALUATION"