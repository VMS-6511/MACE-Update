import os
import pandas as pd
import glob

import matplotlib.pyplot as plt
import matplotlib.image as mpimg


if __name__ == "__main__":
    directories = ["/data/healthy-ml/scratch/ralur/projects/MACE-Update/experiments/MACE/", "/data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/MACE/"]
    prompt = 'A portrait of Adam Driver'

    def find_images(base_path, prompt):
        images = []
        for root, dirs, files in os.walk(base_path):
            for file in files:
                if file.startswith(prompt) and file.endswith('.png'):
                    images.append(os.path.join(root, file))
                    
        return images

    def generate_image_grid(directories, prompt):
        all_experiments = []
        for directory in directories:
            for experiment in os.listdir(directory):
                experiment_path = os.path.join(directory, experiment)
                if os.path.isdir(experiment_path):
                    all_experiments.append(experiment_path)

        valid_experiments = []
        for experiment_path in all_experiments:
            original_images = find_images(os.path.join(experiment_path, '0', 'inference'), prompt)
            finetuned_images = find_images(os.path.join(experiment_path, '0', 'finetune', 'lora'), prompt)
            if original_images or finetuned_images:
                valid_experiments.append((experiment_path, original_images, finetuned_images))
        print(len(valid_experiments))
        fig, axes = plt.subplots(len(valid_experiments), 2, figsize=(10, 5 * len(valid_experiments)))
        for i, (experiment_path, original_images, finetuned_images) in enumerate(valid_experiments):
            experiment_name = os.path.basename(os.path.normpath(experiment_path))
            
            if original_images:
                img = mpimg.imread(original_images[0])
                axes[i, 0].imshow(img)
                axes[i, 0].set_title('Original')
                axes[i, 0].axis('off')
            else:
                axes[i, 0].set_visible(False)

            if finetuned_images:
                img = mpimg.imread(finetuned_images[0])
                axes[i, 1].imshow(img)
                axes[i, 1].set_title('Finetuned')
                axes[i, 1].axis('off')
            else:
                axes[i, 1].set_visible(False)
                
            axes[i, 0].text(0.5, -0.1, experiment_name, size=12, ha="center", transform=axes[i, 0].transAxes)

        plt.tight_layout()
        output_file = 'image_grid.png'
        plt.savefig(output_file)
        print(f"Image grid saved to {output_file}")

    generate_image_grid(directories, prompt)