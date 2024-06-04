import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd


plt.rcParams.update({
    'axes.titlesize': 16,    # Title font size
    'axes.labelsize': 14,    # X and Y axis labels font size
    'xtick.labelsize': 12,   # X tick labels font size
    'ytick.labelsize': 12,   # Y tick labels font size
    'legend.fontsize': 11,   # Legend font size
    'font.size': 12          # General font size
})

plt.rcParams['axes.spines.top'] = False
plt.rcParams['axes.spines.right'] = False
# plt.rcParams['axes.spines.bottom'] = False
# plt.rcParams['axes.spines.left'] = False

data = pd.read_csv("formatted_final_results.csv")

sampling = ['Adaptive Sampling',
'First Timestep',
'Gaussian Sampling (µ = 200, σ = 100)',
'Gaussian Sampling (µ = 200, σ = 50)',
'Gaussian Sampling (µ = 300, σ = 100)',
'Gaussian Sampling (µ = 300, σ = 50)',
'Baseline (Importance Sampling)',
'Last Timestep'
]
metric = "CLIP Score"
# Filter the data to include only the rows where the type is "erased"
print(data['Pretty Name'].isin(sampling))
filtered_data = data[data['type'] == 'others']
filtered_data = filtered_data[filtered_data['Pretty Name'].isin(sampling)]
filtered_data = filtered_data[filtered_data['metric'] == metric]
print(filtered_data['Pretty Name'])

figsize=(6,4)
# Create the plot
plt.figure(figsize=figsize)
sns.lineplot(data=filtered_data, x='task', y='value', hue='Pretty Name', marker='o')

# Customize the plot
plt.xticks([1, 5, 10])
# plt.ylim(0.925, 0.94) 
# plt.title('{} of Different Sampling Algorithms'.format(metric))
plt.xlabel('Number of Erased Celebrities')
plt.ylabel('{}'.format(metric))
plt.legend().remove()
# plt.legend(title='Algorithm')
# plt.legend(title='Algorithm', bbox_to_anchor=(0.5, -0.1), loc='upper center', ncol=2)  # Adjust ncol for the number of columns in the legend
plt.grid(True)
plt.savefig("plotting/{}_sampling.png".format(metric), bbox_inches='tight')

metric = "FID"
# Filter the data to include only the rows where the type is "erased"
print(data['Pretty Name'].isin(sampling))
filtered_data = data[data['type'] == 'others']
filtered_data = filtered_data[filtered_data['Pretty Name'].isin(sampling)]
filtered_data = filtered_data[filtered_data['metric'] == metric]
print(filtered_data['Pretty Name'])


# Create the plot
plt.figure(figsize=figsize)
sns.lineplot(data=filtered_data, x='task', y='value', hue='Pretty Name', marker='o')

# Customize the plot
plt.xticks([1, 5, 10])
# plt.ylim(0.925, 0.94) 
# plt.title('{} of Different Sampling Algorithms'.format(metric))
plt.xlabel('Number of Erased Celebrities')
plt.ylabel('{}'.format(metric))
plt.legend().remove()
# plt.legend(title='Algorithm')
# plt.legend(title='Algorithm', bbox_to_anchor=(0.5, -0.1), loc='upper center', ncol=2)  # Adjust ncol for the number of columns in the legend
plt.grid(True)
plt.savefig("plotting/{}_sampling.png".format(metric), bbox_inches='tight')

metric = "GCD"
# Filter the data to include only the rows where the type is "erased"
print(data['Pretty Name'].isin(sampling))
filtered_data = data[data['type'] == 'others']
filtered_data = filtered_data[filtered_data['Pretty Name'].isin(sampling)]
filtered_data = filtered_data[filtered_data['metric'] == metric]
print(filtered_data['Pretty Name'])


# Create the plot
plt.figure(figsize=figsize)
sns.lineplot(data=filtered_data, x='task', y='value', hue='Pretty Name', marker='o')

# Customize the plot
plt.xticks([1, 5, 10])
# plt.ylim(0.925, 0.94) 
# plt.title('{} of Different Sampling Algorithms'.format("Retain Accuracy (Specificity)"))
plt.xlabel('Number of Erased Celebrities')
plt.ylabel('{}'.format("Retain Accuracy (Specificity)"))
plt.legend().remove()
# plt.legend(title='Algorithm')
# plt.legend(title='Algorithm', bbox_to_anchor=(0.5, -0.1), loc='upper center', ncol=2)  # Adjust ncol for the number of columns in the legend
plt.grid(True)
plt.savefig("plotting/{}_sampling.png".format("specificity"), bbox_inches='tight')

print(data['Pretty Name'].isin(sampling))
filtered_data = data[data['type'] == 'erased']
filtered_data = filtered_data[filtered_data['Pretty Name'].isin(sampling)]
filtered_data = filtered_data[filtered_data['metric'] == metric]
filtered_data['value'] = pd.to_numeric(filtered_data[filtered_data['metric'] == metric]['value'])
print(filtered_data['Pretty Name'])


# Create the plot
plt.figure(figsize=figsize)
sns.lineplot(data=filtered_data, x='task', y='value', hue='Pretty Name', marker='o')

# Customize the plot
plt.xticks([1, 5, 10])
# plt.ylim(0.925, 0.94) 
# plt.title('{} of Different Sampling Algorithms'.format("Erase Accuracy (Efficacy)"))
plt.xlabel('Number of Erased Celebrities')
plt.ylabel('{}'.format("Erase Accuracy (Efficacy)"))
plt.legend().remove()
# plt.legend(title='Algorithm')
# plt.legend(title='Algorithm', bbox_to_anchor=(0.5, -0.1), loc='upper center', ncol=2)  # Adjust ncol for the number of columns in the legend
plt.grid(True)
plt.savefig("plotting/{}_sampling.png".format("efficacy"), bbox_inches='tight')