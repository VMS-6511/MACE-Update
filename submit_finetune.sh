sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_1/ ~/.cache/huggingface/hub/datasets/cele_1_similar_specific/ /pool001/ralur/finetuned_models/cele_1_similar_specific

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_1/ ~/.cache/huggingface/hub/datasets/cele_1_similar_all/ /pool001/ralur/finetuned_models/cele_1_similar_all

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_1/ ~/.cache/huggingface/hub/datasets/cele_1_random_all/ /pool001/ralur/finetuned_models/cele_1_random_all

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_1/ ~/.cache/huggingface/hub/datasets/large_images/ /pool001/ralur/finetuned_models/cele_1_large

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_5/ ~/.cache/huggingface/hub/datasets/cele_5_similar_specific/ /pool001/ralur/finetuned_models/cele_5_similar_specific

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_5/ ~/.cache/huggingface/hub/datasets/cele_5_similar_all/ /pool001/ralur/finetuned_models/cele_5_similar_all

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_5/ ~/.cache/huggingface/hub/datasets/cele_5_random_all/ /pool001/ralur/finetuned_models/cele_5_random_all

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_5/ ~/.cache/huggingface/hub/datasets/large_images/ /pool001/ralur/finetuned_models/cele_5_large

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_10/ ~/.cache/huggingface/hub/datasets/cele_10_similar_all/ /pool001/ralur/finetuned_models/cele_10_similar_all

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_10/ ~/.cache/huggingface/hub/datasets/cele_10_random_all/ /pool001/ralur/finetuned_models/cele_10_random_all

sbatch --partition=sched_mit_sloan_gpu_r8 --gres=gpu:1 --mem=30g scripts/finetune.sh /pool001/ralur/LoRA_fusion_model/importance_sampling_cele_10/ ~/.cache/huggingface/hub/datasets/large_images/ /pool001/ralur/finetuned_models/cele_10_large
