#!/bin/bash

./slurm/scripts/evaluation/launch_compute_metrics_job.sh 0,1 MACE "mapping=person" celebrity erase_cele_1 lora celebrity celebrity_random_concepts_seed0 29512 celebrity_1_concepts CLIP 0
./slurm/scripts/evaluation/launch_compute_metrics_job.sh 0,1 MACE "mapping=person" celebrity erase_cele_1 lora celebrity celebrity_random_concepts_seed0 29513 celebrity_1_concepts CLIP 1
./slurm/scripts/evaluation/launch_compute_metrics_job.sh 0,1 MACE "mapping=person" celebrity erase_cele_1 lora celebrity celebrity_random_concepts_seed0 29514 celebrity_1_concepts CLIP 2

./slurm/scripts/evaluation/launch_compute_metrics_job.sh 0,1 MACE "mapping=person" celebrity erase_cele_1 lora celebrity celebrity_random_concepts_seed0 29515 celebrity_1_concepts GCD 0
./slurm/scripts/evaluation/launch_compute_metrics_job.sh 0,1 MACE "mapping=person" celebrity erase_cele_1 lora celebrity celebrity_random_concepts_seed0 29516 celebrity_1_concepts GCD 1
./slurm/scripts/evaluation/launch_compute_metrics_job.sh 0,1 MACE "mapping=person" celebrity erase_cele_1 lora celebrity celebrity_random_concepts_seed0 29517 celebrity_1_concepts GCD 2
