#!/bin/bash

# tmux new-session -d -s baseline_run 'bash run_full_pipeline.sh mapping=person erase_cele_1 celebrity_1_concepts 0 29501 && \
# bash run_full_pipeline.sh mapping=person erase_cele_1 celebrity_1_concepts 1 29502 && \
# bash run_full_pipeline.sh mapping=person erase_cele_1 celebrity_1_concepts 2 29503 && \
# bash run_full_pipeline.sh mapping=person erase_cele_5 celebrity_5_concepts 0 29504 && \
# bash run_full_pipeline.sh mapping=person erase_cele_5 celebrity_5_concepts 1 29505 && \
# bash run_full_pipeline.sh mapping=person erase_cele_5 celebrity_5_concepts 2 29506 && \
# bash run_full_pipeline.sh mapping=person erase_cele_10 celebrity_10_concepts 0 29507 && \
# bash run_full_pipeline.sh mapping=person erase_cele_10 celebrity_10_concepts 1 29508 && \
# bash run_full_pipeline.sh mapping=person erase_cele_10 celebrity_10_concepts 2 29509 && \
# bash run_full_pipeline.sh mapping=person erase_cele_100 celebrity_100_concepts 0 29510 && \
# bash run_full_pipeline.sh mapping=person erase_cele_100 celebrity_100_concepts 1 29511 && \
# bash run_full_pipeline.sh mapping=person erase_cele_100 celebrity_100_concepts 2 29512'

# tmux new-session -d -s object_run 'bash run_full_pipeline.sh mapping=object erase_cele_1_mapping_object celebrity_1_concepts 1 29513 && \
# bash run_full_pipeline.sh mapping=object erase_cele_1_mapping_object celebrity_1_concepts 2 29514 && \
# bash run_full_pipeline.sh mapping=object erase_cele_5_mapping_object celebrity_5_concepts 0 29515 && \
# bash run_full_pipeline.sh mapping=object erase_cele_5_mapping_object celebrity_5_concepts 1 29516 && \
# bash run_full_pipeline.sh mapping=object erase_cele_5_mapping_object celebrity_5_concepts 2 29517 && \
# bash run_full_pipeline.sh mapping=object erase_cele_10_mapping_object celebrity_10_concepts 0 29518 && \
# bash run_full_pipeline.sh mapping=object erase_cele_10_mapping_object celebrity_10_concepts 1 29519 && \
# bash run_full_pipeline.sh mapping=object erase_cele_10_mapping_object celebrity_10_concepts 2 29520 && \
# bash run_full_pipeline.sh mapping=object erase_cele_100_mapping_object celebrity_100_concepts 0 29521 && \
# bash run_full_pipeline.sh mapping=object erase_cele_100_mapping_object celebrity_100_concepts 1 29522 && \
# bash run_full_pipeline.sh mapping=object erase_cele_100_mapping_object celebrity_100_concepts 2 29523'


tmux new-session -d -s object_mapping_run 'bash run_full_pipeline_generic.sh mapping=object erase_automobile_mapping_object object object object_random_concepts_seed0 object_automobile_concepts 0 29535 && \
bash run_full_pipeline_generic.sh mapping=object erase_automobile_mapping_object object object object_random_concepts_seed0 object_automobile_concepts 1 29536 && \
bash run_full_pipeline_generic.sh mapping=object erase_automobile_mapping_object object object object_random_concepts_seed0 object_automobile_concepts 2 29537 && \
bash run_full_pipeline_generic.sh mapping=object erase_bird_mapping_object object object object_random_concepts_seed0 object_bird_concepts 0 29538 && \
bash run_full_pipeline_generic.sh mapping=object erase_bird_mapping_object object object object_random_concepts_seed0 object_bird_concepts 1 29538 && \
bash run_full_pipeline_generic.sh mapping=object erase_bird_mapping_object object object object_random_concepts_seed0 object_bird_concepts 2 29540 && \
bash run_full_pipeline_generic.sh mapping=object erase_ship_mapping_object object object object_random_concepts_seed0 object_ship_concepts 0 29541 && \
bash run_full_pipeline_generic.sh mapping=object erase_ship_mapping_object object object object_random_concepts_seed0 object_ship_concepts 1 29542 && \
bash run_full_pipeline_generic.sh mapping=object erase_ship_mapping_object object object object_random_concepts_seed0 object_ship_concepts 2 29543'

tmux new-session -d -s art_mapping_run 'bash run_full_pipeline_generic.sh mapping=object erase_art_100_mapping_object art art art_random_concepts_seed0 art_100_concepts 0 29536 && \
bash run_full_pipeline_generic.sh mapping=object erase_art_100_mapping_object art art art_random_concepts_seed0 art_100_concepts 1 29537 && \
bash run_full_pipeline_generic.sh mapping=object erase_art_100_mapping_object art art art_random_concepts_seed0 art_100_concepts 2 29538'