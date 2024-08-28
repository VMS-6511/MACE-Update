# MACE Update: Evaluating Robustness of MACE (and other T2I Unlearning Methods) to Finetuning

---

</div>

## Contents
  - [Setup](#setup)
    - [Creating a Conda Environment](#creating-a-conda-environment)
    - [Install Grounded-SAM to Prepare Masks for LoRA Tuning](#install-grounded\-sam-to-prepare-masks-for-lora-tuning)
    - [Install Other Dependencies](#install-other-dependencies) 
  - [Data Preparation for Training MACE](#data-preparation-for-training-mace) 
  - [Training MACE to Erase Concepts](#training-mace-to-erase-concepts)
  - [Sampling from the Modified Model](#sampling-from-the-modified-model)
  - [MACE Finetuned Model Weights](#mace-finetuned-model-weights)
  - [Metrics Evaluation](#metrics-evaluation)
  - [Acknowledgments](#acknowledgments)
  - [Citation](#citation)


<br>

## Setup

### Creating a Conda Environment

```
git clone https://github.com/Shilin-LU/MACE.git
conda create -n mace-update python=3.10
conda activate mace
conda install pytorch==2.1.0 torchvision==0.15.2 pytorch-cuda=12.1 -c pytorch -c nvidia
```

### Install Grounded-SAM to Prepare Masks for LoRA Tuning

You have the option to utilize alternative segmentation models and bypass this section; however, be aware that performance might suffer if masks are not precise or not employed.

```
export AM_I_DOCKER=False
export BUILD_WITH_CUDA=True

cd MACE
git clone https://github.com/IDEA-Research/Grounded-Segment-Anything.git
cd Grounded-Segment-Anything

# Install Segment Anything:
python -m pip install -e segment_anything

# Install Grounding DINO:
pip install --no-build-isolation -e GroundingDINO

# Install osx:
git submodule update --init --recursive
cd grounded-sam-osx && bash install.sh

# Install RAM & Tag2Text:
git clone https://github.com/xinyu1205/recognize-anything.git
pip install -r ./recognize-anything/requirements.txt
pip install -e ./recognize-anything/
```

Download the pretrained weights of Grounded-SAM.

```
cd ..    # cd Grounded-Segment-Anything

# Download the pretrained groundingdino-swin-tiny model:
wget https://github.com/IDEA-Research/GroundingDINO/releases/download/v0.1.0-alpha/groundingdino_swint_ogc.pth

# Download the pretrained SAM model:
wget https://huggingface.co/lkeab/hq-sam/resolve/main/sam_hq_vit_h.pth
```

### Install Other Dependencies

```
pip install diffusers==0.22.0 transformers==4.38.1
pip install accelerate openai omegaconf

```

### Creating Finetuning Conda Environment

```
conda create -n mace-update-ft --clone mace-update
conda activate mace-update
pip install --updgrade diffusers
```

## Repo Structure

- algorithms: code associated with unlearning algorithms we are testing
- data: code to generate data for both unlearning and finetuning and where generated data is stored
- evaluation: code for each of the different metrics we will evaluate the algorithms on (new metrics should be added in this folder)
- finetuning: code related to finetuning models (new finetuning algorithms should be added to this folder)
- inference: code related to sampling images from models
- slurm: all scripts for launching jobs related to experiments
- tasks: all of the tasks and their configs and evaluaiton prompt sets are stored here

Folders to be manually added:

- experiments
- celeb-detection-oss
- Grounded-Segment-Anything

Throughout this repo there are a set of recurring parameters used throughout the pipeline:

- ALGO_NAME: Name of the folder for each unlearning algorithm (i.e. MACE or UCE)
- ORIG_TASK: Name of the folder for the high level unlearning task (i.e. art, celebrity, explicit_content, object)
- ORIG_CONFIG: Name of the specific config in the high level unlearning task (e.g. erase_cele_1)
- FINETUNE_ALGO: Name of the finetuning algorithm (i.e. full or lora)
- FINETUNE_TASK: Name of the folder for the high level unlearning task (i.e. art, celebrity, explicit_content, object)
- FINETUNE_CONFIG: Name of the specific config in the high level unlearning task (e.g. erase_cele_1)
- CHANGE: A string to identify the change to the original algorithm that is being tested in the experiment (e.g. train_preserve_scale=0.0 if setting the regularization parameter in the cross-attention refinement objective to 0.0)

## Data Preparation

To erase concepts, 8 images along with their respective segmentation masks should be generated for each concept. To prepare the data for your intended concept, configure your settings in `tasks/object/ship.yaml` and execute the command:

```
CUDA_VISIBLE_DEVICES=0 python data_preparation.py tasks/object/ship.yaml
```

Before beginning the mass concept erasing process, ensure that you have pre-cached the prior knowledge (e.g., MSCOCO) and domain-specific knowledge (e.g., certain celebrities, artistic styles, or objects) you wish to retain. 

- You can download our pre-cached files from [this OneDrive folder](https://entuedu-my.sharepoint.com/:f:/g/personal/shilin002_e_ntu_edu_sg/EiyepLM2qoFEh_kQ0kO4IzQBu6YZllxATJvv7ffguvFbBQ?e=v4JeyI). Once downloaded, place these files in the `./cache/` for use.

- Alternatively, to preserve additional knowledge of your choice, you can cache the information by modifying the script `src/cache_coco.py`.

- Additionally, to generate new task create a new config (in the format of the higher level task) and add this to the config file. For the save folder please ensure that the data `./data` folder is used

To launch this command on the SLURM cluster for a specific `task` and `config`, execute the following command:

```
  ./slurm/scripts/data/launch_prepare_data_job.sh task config
```

## Adding New Unlearning Algorithms

The `algorithms` folder contains the code for each of the different unlearning algorithms that can be applied. For new algorithms add a new directory in this folder and ensure that there is a `training.py` script and a `train_model.sh` script that launches the python training script.

## Applying Unlearning Algorithm to Erase Concepts

After preparing the data, you can run the following command:

```
./algorithms/algo_name/train_model.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $TRAINING_PARAMETERS
```

where $TRAINING_PARAMETERS is a list of space separated values you would like to change in the `tasks/task/config.yaml` file.

To launch this command on the SLURM cluster for a specific task `tasks/task/config.yaml`, specific algorithm and custom task parameters (e.g. mapping concepts), execute the following command:

```

./slurm/scripts/training/launch_train_job.sh 0,1 MACE train_reg=0.00004 explicit_content erase_explicit_content train_preserve_scale 0.00004

```

## Sampling from the Unlearned Model

The unlearned model can be simply tested by running the following command to generate several images:

To produce lots of images based on a list of prompts with with predetermined seeds (e.g., from a CSV file `./prompts_csv/celebrity_100_concepts.csv`), execute the command below (the hyperparameter `step` should be set to the same value as `num_processes`):

```
./inference/sample_images.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV
```

The images from running this command will be saved to the following folder: `/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${TASK}_${CONFIG}/inference/${PROMPTS_CSV}`.

To launch this command as a SLURM job, execute the following command:

```
./slurm/scripts/inference/launch_sample_images_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV
```

## Generating Finetuning Dataset

To generate a dataset for finetuning, a CSV must first be created in one of the `tasks/task` folders. This CSV must contain the set of prompts to be used to generate the finetuning dataset.

After this, the dataset can be generated by running the following command:

```

./data/finetuning/generate_baseline.sh $TASK $CONFIG

```

where $TASK has the same meaning as prior and now $CONFIG represents the name of the CSV of prompts to be used to generate the data.

After running this command the following command must be executed:

```
./data/finetuning/update_metadata.sh ${PREFIX}/data/finetuning/${TASK}/${CONFIG}
```

To launch this command on the SLURM cluster for a specific `task` and `config`, execute the following command:

```
  ./slurm/scripts/data/launch_prepare_data_finetuning_job.sh task config
```

## Finetuning An Existing Model

After preparing the finetuning data, you can run the following command:

ALGO_NAME=$1
CHANGE=$2
FINETUNE_ALGO=$3
ORIG_TASK=$4
ORIG_CONFIG=$5
FINETUNE_TASK=$6
FINETUNE_CONFIG=$7

```
./finetuning/finetune_model.sh $ALGO_NAME $CHANGE $FINETUNE_ALGO $ORIG_TASK $ORIG_CONFIG $FINETUNE_TASK $FINETUNE_CONFIG
```

To launch this command on the SLURM cluster:

```

./slurm/scripts/finetuning/launch_finetune_job.sh $ALGO_NAME $CHANGE $FINETUNE_ALGO $ORIG_TASK $ORIG_CONFIG $FINETUNE_TASK $FINETUNE_CONFIG

```


## Sampling from the Finetuned Model

The newly finetuned model can be simply tested by running the following command to generate several images:

To produce lots of images based on a list of prompts with with predetermined seeds (e.g., from a CSV file `./prompts_csv/celebrity_100_concepts.csv`), execute the command below (the hyperparameter `step` should be set to the same value as `num_processes`):

```
./inference/sample_images_finetune.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $ORIG_TASK $ORIG_CONFIG $FINETUNE_ALGO $FINETUNE_TASK $FINETUNE_CONFIG $PORT_NUMBER $PROMPTS_CSV
```

The images from running this command will be saved to the following folder: `/data/healthy-ml/scratch/vinithms/projects/MACE-Robustness/experiments/${ALGO_NAME}/${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}/finetune/${FINETUNE_ALGO}/${FINETUNE_TASK}_${FINETUNE_CONFIG}/inference/${PROMPTS_CSV}`.

To launch this command as a SLURM job, execute the following command:

```
./slurm/scripts/inference/launch_sample_images_finetune_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $ORIG_TASK $ORIG_CONFIG $FINETUNE_ALGO $FINETUNE_TASK $FINETUNE_CONFIG $PORT_NUMBER $PROMPTS_CSV
```


## Metrics Evaluation
During our evaluation, we employ various metrics including [FID](https://github.com/GaParmar/clean-fid), [CLIP score](https://github.com/openai/CLIP), [CLIP classification accuracy](https://github.com/openai/CLIP), [GCD accuracy](https://github.com/Giphy/celeb-detection-oss), and [NudeNet detection results](https://github.com/notAI-tech/NudeNet).

- Evaluate FID:
```
CUDA_VISIBLE_DEVICES=0 python evaluation/evaluate_fid.py --dir1 'path/to/generated/image/folder' --dir2 'path/to/coco/GT/folder'
```

- Evaluate CLIP score:
```
CUDA_VISIBLE_DEVICES=0 python evaluation/evaluate_clip_score.py --image_dir 'path/to/generated/image/folder' --prompts_path './prompts_csv/coco_30k.csv'
```

- Evaluate GCD accuracy. When utilizing this script for detection, please ensure that the content within the input directory consists solely of images, without the need to navigate into subdirectories. This precaution helps prevent errors during the process. (please refer to the [GCD installation guideline](https://github.com/Shilin-LU/MACE/tree/main/metrics)):
```
conda activate GCD
CUDA_VISIBLE_DEVICES=0 python evaluation/evaluate_by_GCD.py --image_folder 'path/to/generated/image/folder'
```

- Evaluate NudeNet detection results (please refer to the [NudeNet installation guideline](https://github.com/notAI-tech/NudeNet)):
```
CUDA_VISIBLE_DEVICES=0 python evaluation/evaluate_by_nudenet.py --folder 'path/to/generated/image/folder'
```

- Evaluate CLIP classification accuracy:
```
CUDA_VISIBLE_DEVICES=0 python evaluation/evaluate_clip_accuracy.py --base_folder 'path/to/generated/image/folder'
```

To run any of these metrics as a SLURM job:

Without Finetuning

```
./slurm/scripts/evaluation/launch_compute_metrics_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $TASK $CONFIG $PORT_NUMBER $PROMPTS_CSV $METRIC

```

With Finetuning
```
./slurm/scripts/evaluation/launch_compute_metrics_finetune_job.sh $CUDA_VISIBLE_DEVICES $ALGO_NAME $CHANGE $ORIG_TASK $ORIG_CONFIG $FINETUNE_ALGO $FINETUNE_TASK $FINETUNE_CONFIG $PORT_NUMBER $PROMPTS_CSV $METRIC
```

## Experiment Directory Structure

For every experiment, if the entire pipeline above is run then the diectory will be structured as follows:

- `./experiments/`
  - `${ALGO_NAME}`
    - `${CHANGE}_${ORIG_TASK}_${ORIG_CONFIG}`
      - `CFR_with_multi_LoRAs`
      - `finetune`
        - `${FINETUNE_ALGO}`
          - `inference`
      - `inference`
      - `LoRA_fusion_model`
      - `results`
      - `params.yaml`

