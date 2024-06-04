#!/bin/bash

source ~/.bashrc
conda activate mace-update

# for NUM_CELEBS in 1 5 10; do
#     for ALGO_NAME in last_timestep adaptive_sampling_eta_0.1 gaussian_sampling_mean_300_std_50 gaussian_sampling_mean_200_std_50 gaussian_sampling_mean_300_std_100 gaussian_sampling_mean_200_std_100; do
#         echo compute_metrics_celeb_${ALGO_NAME}_$NUM_CELEBS
#         bash ./launch_gpu_slurm_job_v2.sh compute_metrics_model_celeb_${ALGO_NAME}_$NUM_CELEBS gpu:2 ./compute_metrics.sh 0,1 $NUM_CELEBS ${ALGO_NAME} 
#     done
# done

for NUM_CELEBS in 1 5 10; do
    for ALGO_NAME in last_timestep_sampling; do
        echo compute_metrics_celeb_${ALGO_NAME}_$NUM_CELEBS
        bash ./launch_gpu_slurm_job_v2.sh compute_metrics_model_celeb_${ALGO_NAME}_$NUM_CELEBS gpu:2 ./compute_metrics.sh 0,1 $NUM_CELEBS ${ALGO_NAME} 
    done
done

# for NUM_CELEBS in 10; do
#     for CHECKPOINT in 800 900 1000; do
#         for ALGO_NAME in importance_sampling_large; do
#             echo compute_metrics_celeb_${ALGO_NAME}_checkpoint_${CHECKPOINT}_$NUM_CELEBS
#             bash ./launch_gpu_slurm_job_v2.sh compute_metrics_model_celeb_${ALGO_NAME}_checkpoint_${CHECKPOINT}_$NUM_CELEBS gpu:2 ./compute_metrics.sh 0,1 $NUM_CELEBS ${ALGO_NAME}_checkpoint_${CHECKPOINT} 
#         done
#     done
# done
