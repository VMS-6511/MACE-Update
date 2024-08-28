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

## Data Preparation for Training MACE

To erase concepts, 8 images along with their respective segmentation masks should be generated for each concept. To prepare the data for your intended concept, configure your settings in `tasks/object/ship.yaml` and execute the command:

```
CUDA_VISIBLE_DEVICES=0 python data_preparation.py tasks/object/ship.yaml
```

Before beginning the mass concept erasing process, ensure that you have pre-cached the prior knowledge (e.g., MSCOCO) and domain-specific knowledge (e.g., certain celebrities, artistic styles, or objects) you wish to retain. 

- You can download our pre-cached files from [this OneDrive folder](https://entuedu-my.sharepoint.com/:f:/g/personal/shilin002_e_ntu_edu_sg/EiyepLM2qoFEh_kQ0kO4IzQBu6YZllxATJvv7ffguvFbBQ?e=v4JeyI). Once downloaded, place these files in the `./cache/` for use.

- Alternatively, to preserve additional knowledge of your choice, you can cache the information by modifying the script `src/cache_coco.py`.

- Additionally, to generate new task create a new config (in the format of the higher level task) and add this to the config file. For the save folder please ensure that the data `./data` folder is used

To launch this command on the SLURM cluster for a specific `task` and `file_name`, execute the following command:

```
  ./slurm/scripts/data/launch_prepare_data_job.sh task file_name 
```

## Training MACE to Erase Concepts

After preparing the data, you can specify your training parameters in the same configuration file `tasks/object/ship.yaml` and run the following command:

```
CUDA_VISIBLE_DEVICES=0 python training.py tasks/object/ship.yaml
```

To launch this command on the SLURM cluster for a specific task `tasks/file_name.yaml`, specific algorithm and custom task parameters (e.g. mapping concepts), execute the following command:

```

./slurm/scripts/training/launch_train_job.sh 0,1 importance_sampling_reg_0.00004 explicit_content erase_explicit_content train_preserve_scale 0.00004

```

## Sampling from the Finetuned Model

The finetuned model can be simply tested by running the following command to generate several images:

```
CUDA_VISIBLE_DEVICES=0 python inference.py \
          --num_images 3 \
          --prompt 'your_prompt' \
          --model_path /path/to/saved_model/LoRA_fusion_model \
          --save_path /path/to/save/folder
```

To produce lots of images based on a list of prompts with with predetermined seeds (e.g., from a CSV file `./prompts_csv/celebrity_100_concepts.csv`), execute the command below (the hyperparameter `step` should be set to the same value as `num_processes`):

```
CUDA_VISIBLE_DEVICES=0,1,2,3 accelerate launch \
          --multi_gpu --num_processes=4 --main_process_port 31372 \
          src/sample_images_from_csv.py \
          --prompts_path ./prompts_csv/celebrity_100_concepts.csv \
          --save_path /path/to/save/folder \
          --model_name /path/to/saved_model/LoRA_fusion_model \
          --step 4
```

To launch this command on the SLURM cluster, execute the following command:

```
./slurm/scripts/inference/launch_sample_images_job.sh cuda_visible_devices algorithm_name task config 31380 prompts_csv_file
```

## Metrics Evaluation
During our evaluation, we employ various metrics including [FID](https://github.com/GaParmar/clean-fid), [CLIP score](https://github.com/openai/CLIP), [CLIP classification accuracy](https://github.com/openai/CLIP), [GCD accuracy](https://github.com/Giphy/celeb-detection-oss), and [NudeNet detection results](https://github.com/notAI-tech/NudeNet).

- Evaluate FID:
```
CUDA_VISIBLE_DEVICES=0 python metrics/evaluate_fid.py --dir1 'path/to/generated/image/folder' --dir2 'path/to/coco/GT/folder'
```

- Evaluate CLIP score:
```
CUDA_VISIBLE_DEVICES=0 python metrics/evaluate_clip_score.py --image_dir 'path/to/generated/image/folder' --prompts_path './prompts_csv/coco_30k.csv'
```

- Evaluate GCD accuracy. When utilizing this script for detection, please ensure that the content within the input directory consists solely of images, without the need to navigate into subdirectories. This precaution helps prevent errors during the process. (please refer to the [GCD installation guideline](https://github.com/Shilin-LU/MACE/tree/main/metrics)):
```
conda activate GCD
CUDA_VISIBLE_DEVICES=0 python metrics/evaluate_by_GCD.py --image_folder 'path/to/generated/image/folder'
```

- Evaluate NudeNet detection results (please refer to the [NudeNet installation guideline](https://github.com/notAI-tech/NudeNet)):
```
CUDA_VISIBLE_DEVICES=0 python metrics/evaluate_by_nudenet.py --folder 'path/to/generated/image/folder'
```

- Evaluate CLIP classification accuracy:
```
CUDA_VISIBLE_DEVICES=0 python metrics/evaluate_clip_accuracy.py --base_folder 'path/to/generated/image/folder'
```