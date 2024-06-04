import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd


# Set context to 'talk' for larger font sizes, or you can use 'poster' for even larger sizes
# sns.set_context("talk", font_scale=1.5)

# Alternatively, set individual font sizes using rcParams
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
data = pd.read_csv("formatted_final_results.csv")


sampling = ['Baseline (Importance Sampling)',
'Forget-then-Finteune (Large)',
'Forget-then-Finteune (Alternate)',
'Forget-then-Finteune (Random)',
'Forget-then-Finetune (Similar)',
]

# Filter data to include only rows where the metric is 'GCD'
gcd_data = data[data['metric'] == 'GCD']

# Separate the filtered data into 'erased' and 'others'
erased_data = gcd_data[gcd_data['type'] == 'erased']
others_data = gcd_data[gcd_data['type'] == 'others']

# Merge the two dataframes on 'task' and 'algo_name'
merged_data = pd.merge(erased_data, others_data, on=['task', 'algo_name', 'Pretty Name'], suffixes=('_erased', '_others'))

# Function to compute the harmonic mean
def harmonic_mean(row):
    return 2 / ((1 / (1 - row['value_erased'])) + (1 / row['value_others']))

# Apply the function to each row
merged_data['harmonic_mean'] = merged_data.apply(harmonic_mean, axis=1)

# Select the relevant columns
result = merged_data[['task', 'algo_name', 'Pretty Name', 'harmonic_mean']]

# Display the result
result = result[result['Pretty Name'].isin(sampling)]






# Filter the data to include only the rows where the type is "erased"
# print(data['Pretty Name'].isin(sampling))
# filtered_data = data
# # filtered_data = data[data['type'] == 'others']
# filtered_data = filtered_data[filtered_data['Pretty Name'].isin(sampling)]
# filtered_data = filtered_data[filtered_data['metric'] == 'GCD']
# erasure = 1 / (1 - pd.to_numeric(filtered_data[filtered_data['type'] == 'erased'][filtered_data['metric'] == 'GCD']))
# retain = 1 / (pd.to_numeric(filtered_data[filtered_data['type'] == 'others'][filtered_data['metric'] == 'GCD']))
# print(len(erasure))
# print(len(retain))
# filtered_data['generality'] = 2 / (erasure + retain)
# filtered_data = filtered_data[filtered_data]
# print(filtered_data['Pretty Name'])


# Create the plot
plt.figure(figsize=(6, 4))
sns.lineplot(data=result, x='task', y='harmonic_mean', hue='Pretty Name', marker='o')

# Customize the plot
plt.xticks([1, 5, 10])
# plt.ylim(0.955, 0.97)
# plt.title('Overall Accuracy (Generality) of Different Sampling Algorithms')
plt.xlabel('Number of Erased Celebrities')
plt.ylabel('Overall Accuracy (Generality)')
plt.legend().remove()
plt.grid(True)
plt.savefig("plotting/generality_finetuning.png", bbox_inches='tight')