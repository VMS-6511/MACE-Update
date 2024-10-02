
import os
import pandas as pd
import glob


if __name__ == "__main__":
    #directories = ["/data/healthy-ml/scratch/ralur/projects/MACE-Update/experiments/MACE/", "/data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/MACE/"]
    directories = ["/data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/MACE/", "/data/healthy-ml/vinithms/projects/MACE-Update/experiments/MACE"]
    

    all_metrics = []

    for directory in directories:
        for change_dir in os.listdir(directory):
            change_path = os.path.join(directory, change_dir)
            components = change_dir.split('_')
            
            change = '_'.join(components[0:-4])
            if len(components) < 4:
                print(f"Skipping {change_dir} because it doesn't have enough components")
                continue
            task = components[-4]
            config = '_'.join(components[-3:])
            
            if os.path.isdir(change_path):
                for seed_dir in os.listdir(change_path):
                    seed_path = os.path.join(change_path, seed_dir)
                    if os.path.isdir(seed_path):
                        results_path = os.path.join(seed_path, "results")
                        if os.path.isdir(results_path):
                            csv_files = glob.glob(os.path.join(results_path, "*", "metrics.csv"))
                            for csv_file in csv_files:
                                df = pd.read_csv(csv_file, header=None)
                                
                                df['change'] = change
                                df['task'] = task
                                df['config'] = config
                                df['seed'] = seed_dir
                                df['finetune_algo'] = 'n/a'
                                df['finetune_prompts'] = 'n/a'
                                all_metrics.append(df)
                        
                        finetune_path = os.path.join(seed_path, "finetune", "lora")
                        if os.path.isdir(finetune_path):
                            for task_dir in os.listdir(finetune_path):
                                task_path = os.path.join(finetune_path, task_dir)
                                if os.path.isdir(task_path):
                                    csv_files = glob.glob(os.path.join(task_path, "results", "*", "metrics.csv"))
                                    for csv_file in csv_files:
                                        df = pd.read_csv(csv_file, header=None)
                                        df['change'] = change
                                        df['task'] = task
                                        df['config'] = config
                                        df['seed'] = seed_dir
                                        df['finetune_algo'] = 'lora'
                                        df['finetune_prompts'] = task_dir
                                        all_metrics.append(df)
                        
                        full_finetune_path = os.path.join(seed_path, "finetune", "full")
                        if os.path.isdir(full_finetune_path):
                            for task_dir in os.listdir(full_finetune_path):
                                task_path = os.path.join(full_finetune_path, task_dir)
                                if os.path.isdir(task_path):
                                    csv_files = glob.glob(os.path.join(task_path, "results", "*", "metrics.csv"))
                                    for csv_file in csv_files:
                                        df = pd.read_csv(csv_file, header=None)
                                        df['change'] = change
                                        df['task'] = task
                                        df['config'] = config
                                        df['seed'] = seed_dir
                                        df['finetune_algo'] = 'full'
                                        df['finetune_prompts'] = task_dir
                                        all_metrics.append(df)

    combined_metrics = pd.concat(all_metrics, ignore_index=True)
    # Drop the second column (index 1)
    #combined_metrics = combined_metrics.drop(combined_metrics.columns[1], axis=1)
    #combined_metrics.columns = ['Algo', 'Metric', 'Category', 'Value', 'Change', 'Task', 'Config', 'Seed', 'Type', 'Finetune_Config']
    col_names = ['algo', 'change', 'task', 'config', 'finetune_algo', 'finetune_task', 'finetune_prompts', 'prompts_csv', 'seed', 'type', 'metric', 'value']
    combined_metrics = combined_metrics.iloc[:, :len(col_names)]
    combined_metrics.columns = col_names
    
    # Save the combined metrics to a CSV file
    output_file = 'combined_metrics.csv'
    combined_metrics.to_csv(output_file, index=False)
    print(f"Combined metrics saved to {output_file}")


