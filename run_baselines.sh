#!/bin/bash

tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_1 celebrity_random_concepts_seed0 0 29501'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_1 celebrity_random_concepts_seed0 1 29502'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_1 celebrity_random_concepts_seed0 2 29503'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_5 celebrity_random_concepts_seed0 0 29504'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_5 celebrity_random_concepts_seed0 1 29505'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_5 celebrity_random_concepts_seed0 2 29506'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_10 celebrity_random_concepts_seed0 0 29507'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_10 celebrity_random_concepts_seed0 1 29508'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_10 celebrity_random_concepts_seed0 2 29509'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_100 celebrity_random_concepts_seed0 0 29510'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_100 celebrity_random_concepts_seed0 1 29511'
tmux new-session -d 'bash run_full_pipeline.sh mapping=person erase_cele_100 celebrity_random_concepts_seed0 2 29512'