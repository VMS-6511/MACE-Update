
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

def process_task_data(df, task):
    task_data = df[df['task'] == task]
    print(f"{task.capitalize()} data shape:", task_data.shape)
    return task_data

def create_plots(task_data, task):
    metrics = ['clip_score', 'clip_acc', 'FID', 'GCD']
    fig, axes = plt.subplots(1, len(metrics), figsize=(20, 6))
    fig.suptitle(f'Metrics for {task.capitalize()} Task', fontsize=16)

    for i, metric in enumerate(metrics):
        metric_data = task_data[task_data['metric'] == metric]
        metric_data['value'] = metric_data['value'].apply(lambda x: float(x.split('±')[0]) if isinstance(x, str) and '±' in x else float(x))
        print(f"Data for {metric}:")
        print(metric_data.head(3))
        
        if metric_data.empty:
            print(f"Warning: No data found for metric '{metric}'")
            axes[i].text(0.5, 0.5, 'No Data', ha='center', va='center', fontsize=12, fontweight='bold')
            continue
        
        # Create a new row for each config value
        unique_configs = metric_data['config'].unique()
        num_configs = len(unique_configs)
        fig.set_figheight(6 * num_configs)  # Adjust figure height based on number of configs
        
        for j, config in enumerate(unique_configs):
            config_data = metric_data[metric_data['config'] == config]
            ax = plt.subplot(num_configs, len(metrics), i + 1 + j * len(metrics))
            
            sns.barplot(data=config_data, x='finetune_algo', y='value', hue='type', ax=ax, order=['n/a', 'lora', 'full'])
            ax.set_title(f'{metric} - {config}')
            ax.set_xlabel('Finetune Algorithm')
            ax.set_ylabel(metric)
            ax.tick_params(axis='x', rotation=45)


            
            if i == len(metrics) - 1:  # Only add legend to the last subplot in each row
                ax.legend(title='Type', bbox_to_anchor=(1.05, 1), loc='upper left')
            else:
                ax.legend().remove()

    # Create separate figure for each metric
    for metric in metrics:
        metric_data = task_data[task_data['metric'] == metric]
        if metric_data.empty:
            print(f"Warning: No data found for metric '{metric}'")
            continue

        metric_data['value'] = metric_data['value'].apply(lambda x: float(x.split('±')[0]) if isinstance(x, str) and '±' in x else float(x))
        
        # Get unique types
        types = metric_data['type'].unique()
        
        # Create a subplot for each type
        fig, axes = plt.subplots(len(types), 1, figsize=(12, 6*len(types)), sharex=True)
        fig.suptitle(f'{metric} for {task.capitalize()} Task', fontsize=16)
        
        for i, type_value in enumerate(types):
            type_data = metric_data[metric_data['type'] == type_value]
            
            sns.barplot(data=type_data, x='config', y='value', hue='finetune_algo', palette='deep', ax=axes[i])
            
            axes[i].set_title(f'Type: {type_value}')
            axes[i].set_xlabel('Config' if i == len(types)-1 else '')
            axes[i].set_ylabel(metric)
            axes[i].tick_params(axis='x', rotation=45)
            
            # Set x-axis labels to the values of 'config'
            x_labels = type_data['config'].unique()
            axes[i].set_xticks(range(len(x_labels)))
            axes[i].set_xticklabels(x_labels, rotation=45, ha='right')
            
            axes[i].legend(title='Finetune Algorithm', bbox_to_anchor=(1.05, 1), loc='upper left')
        
        plt.tight_layout()
        
        # Save the figure in the new directory
        plt.savefig(f'figures/{change}/{task}_{metric}_comparison.png', bbox_inches='tight')
        print(f"Figure saved as '{task}_{metric}_comparison.png'")
        plt.close()

    plt.tight_layout()
    
    # Create the directory if it doesn't exist
    os.makedirs(f'figures/{change}', exist_ok=True)
    
    # Save the figure in the new directory
    plt.savefig(f'figures/{change}/{task}_metrics.png', bbox_inches='tight')
    print(f"Figure saved as '{task}_metrics.png'")
    plt.close()

import argparse

if __name__ == "__main__":
    # Set up argument parser
    parser = argparse.ArgumentParser(description='Generate figures for MACE experiments')
    parser.add_argument('--change', type=str, help='Name of change (e.g., mapping=person)', default='baseline')
    
    # Parse arguments
    args = parser.parse_args()
    
    
    change = args.change
    
    print(f"Generating figures for experiment: {change}")
    df = pd.read_csv('combined_metrics.csv')

    df = df[df['change'] == change]
    
    print("DataFrame shape:", df.shape)
    print("DataFrame columns:", df.columns)
    print("Unique values in 'Task' column:", df['task'].unique())
    print("Unique values in 'Metric' column:", df['metric'].unique())

    tasks = ['celebrity', 'art', 'object']

    for task in tasks:
        task_data = process_task_data(df, task)
        
        if task_data.empty:
            print(f"Error: No data found for the '{task}' task.")
            continue

        create_plots(task_data, task)