import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

if __name__ == "__main__":
    
    # Load the data and print basic information
    df = pd.read_csv('combined_metrics.csv')
    print("DataFrame shape:", df.shape)
    print("DataFrame columns:", df.columns)
    print("Unique values in 'Task' column:", df['Task'].unique())

    celebrity_data = df[df['Task'] == 'celebrity']
    print("Celebrity data shape:", celebrity_data.shape)

    if celebrity_data.empty:
        print("Error: No data found for the 'celebrity' task.")
        exit()

    # Create a new figure with subplots for each metric
    fig, axes = plt.subplots(1, 3, figsize=(18, 6))
    metrics = ['CLIP Score', 'FID', 'GCD']

    for i, metric in enumerate(metrics):
        metric_data = celebrity_data[celebrity_data['Metric'] == metric]
        metric_data['Value'] = metric_data['Value'].apply(lambda x: float(x.split('±')[0]) if isinstance(x, str) and '±' in x else float(x))
        print(f"Data for {metric}:")
        print(metric_data)
        
        if metric_data.empty:
            print(f"Warning: No data found for metric '{metric}'")
            continue
        
        # Create the bar plot for each metric
        sns.barplot(x='Category', y='Value', hue='Type', data=metric_data, ax=axes[i])
        
        # Customize each subplot
        axes[i].set_title(f'{metric} for Celebrity Task')
        axes[i].set_xlabel('Category')
        axes[i].set_ylabel(metric)
        
        # Rotate x-axis labels if needed
        axes[i].tick_params(axis='x', rotation=45)
        
        # Add legend
        axes[i].legend(title='Type')

    # Adjust layout and save the figure
    plt.tight_layout()
    plt.savefig('celebrity_metrics.png')
    print("Figure saved as 'celebrity_metrics.png'")
    plt.close()