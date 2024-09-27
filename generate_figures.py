import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def process_task_data(df, task):
    task_data = df[df['task'] == task]
    print(f"{task.capitalize()} data shape:", task_data.shape)
    return task_data

def create_plots(task_data, task):
    metrics = ['clip_score', 'clip_acc', 'FID', 'GCD']
    fig, axes = plt.subplots(1, len(metrics), figsize=(18, 6))

    for i, metric in enumerate(metrics):
        metric_data = task_data[task_data['metric'] == metric]
        metric_data['value'] = metric_data['value'].apply(lambda x: float(x.split('±')[0]) if isinstance(x, str) and '±' in x else float(x))
        print(f"Data for {metric}:")
        print(metric_data.head(3))
        
        if metric_data.empty:
            print(f"Warning: No data found for metric '{metric}'")
            continue
        
        g = sns.FacetGrid(metric_data, col='config', row='type', height=4, aspect=1.2)
        g.map(sns.barplot, 'finetune_algo', 'value', order=['n/a', 'lora', 'full'])
        g.add_legend(title='Finetune Algorithm')
        g.set_axis_labels('Finetune Algorithm', metric)
        g.set_titles(col_template='{col_name}', row_template='{row_name}')
        axes[i] = g
        g.fig.suptitle(f'{metric} for {task.capitalize()} Task')
        g.set_axis_labels('Category', metric)

        for ax in g.axes.flat:
            if len(ax.patches) == 0:
                ax.text(0.5, 0.5, 'No Data', ha='center', va='center', fontsize=12, fontweight='bold')
                ax.set_ylim(0, 1)  # Set y-axis limits for consistency
        
        
        for ax in g.axes.flat:
            ax.tick_params(axis='x', rotation=45)
        
        g.add_legend(title='Type')

    plt.tight_layout()
    plt.savefig(f'{task}_metrics.png')
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