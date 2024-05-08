HF_LOCAL_DIR="/state/partition1/user/$(whoami)/cache/huggingface"
mkdir -p $HF_LOCAL_DIR
# HF folder in shared file system
HF_USER_DIR="/home/gridsan/$(whoami)/.cache/huggingface"
export HF_HOME="${HF_LOCAL_DIR}"

HF_MODEL_NAME="CompVis/stable-diffusion-v1-4"

python load_model.py --model ${HF_MODEL_NAME}

