sh img_data.sh triplet_experiments/baseline/generated_images/ cele_1_similar ".*mila-kunis.*"
sh img_data.sh triplet_experiments/baseline/generated_images/ cele_1_loo ".*"
find /home/ralur/.cache/huggingface/hub/datasets/cele_1_loo/train -type f | grep -P '.*melania-trump.*' | xargs rm
