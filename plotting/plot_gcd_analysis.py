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
data = pd.read_csv("gcd_analysis.csv")


# Filter the data to include only the rows where the type is "erased"
filtered_data = data[data['type'] == 'others']

figsize=(6,4)
# Create the plot
plt.figure(figsize=figsize)
sns.lineplot(data=filtered_data, x='Checkpoint Number', y='value', marker='o')

# Customize the plot
plt.xticks([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000])
# plt.ylim(0.925, 0.94) 
# plt.title('{} of Different Sampling Algorithms'.format(metric))
plt.xlabel('Checkpoint Number')
plt.ylabel('{}'.format("Retain Accuracy (Specificity)"))
# plt.legend(title='Algorithm')
# plt.legend(title='Algorithm', bbox_to_anchor=(0.5, -0.1), loc='upper center', ncol=2)  # Adjust ncol for the number of columns in the legend
plt.grid(True)
# plt.savefig("plotting/{}_finetuning.png".format("specificity_time"), bbox_inches='tight')

data = pd.read_csv("gcd_analysis_mean.csv")


# Filter the data to include only the rows where the type is "erased"
# filtered_data = data[data['type'] == 'others']

figsize=(6,4)
# Create the plot
plt.figure(figsize=figsize)
sns.lineplot(data=data, x='Checkpoint Number', y='type', marker='o')

# Customize the plot
plt.xticks([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000])
# plt.ylim(0.925, 0.94) 
# plt.title('{} of Different Sampling Algorithms'.format(metric))
plt.xlabel('Checkpoint Number')
plt.ylabel('{}'.format("Overall Accuracy (Generality)"))
# plt.legend(title='Algorithm')
# plt.legend(title='Algorithm', bbox_to_anchor=(0.5, -0.1), loc='upper center', ncol=2)  # Adjust ncol for the number of columns in the legend
plt.grid(True)
plt.savefig("plotting/{}_finetuning.png".format("generality_time"), bbox_inches='tight')