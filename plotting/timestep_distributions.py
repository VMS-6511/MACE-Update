import pandas as pd
import matplotlib.pyplot as plt

sampling = ['Adaptive Sampling',
'First Timestep',
'Gaussian Sampling (µ = 200, σ = 100)',
'Gaussian Sampling (µ = 200, σ = 50)',
'Gaussian Sampling (µ = 300, σ = 100)',
'Gaussian Sampling (µ = 300, σ = 50)',
'Baseline (Importance Sampling)',
'Last Timestep'
]

algos = {
    "importance_sampling": "Baseline (Importance Sampling)", "gaussian_sampling_mean_200_std_50": 'Gaussian Sampling (µ = 200, σ = 50)' , \
    "gaussian_sampling_mean_200_std_100": 'Gaussian Sampling (µ = 200, σ = 100)', "gaussian_sampling_mean_300_std_100": 'Gaussian Sampling (µ = 300, σ = 100)', \
    "gaussian_sampling_mean_300_std_50": 'Gaussian Sampling (µ = 300, σ = 50)', \
    "adaptive_sampling_eta_0.1": "Adaptive Sampling"
}

colors = ['red', 'blue', 'green', 'purple', 'orange', 'black', 'gray', 'brown', 'black']

dataframes = {}
for algo in algos.keys():
    file = '/data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/{}_cele_1/sampled.csv'.format(algo)
    dataframes[algos[algo]] = pd.read_csv(file, skiprows=lambda x: x % 2 == 0 and x != 0)
    print(dataframes[algos[algo]]['timesteps'])
    dataframes[algos[algo]]['timesteps'] = pd.to_numeric(dataframes[algos[algo]]['timesteps'], errors='coerce')

first_timestep_row = {}
first_timestep_row['timesteps'] = [0 for i in range(1000)]
first_timestep_row = pd.DataFrame(first_timestep_row)
last_timestep_row = {}
last_timestep_row['timesteps'] = [1000 for i in range(1000)]
last_timestep_row = pd.DataFrame(last_timestep_row)
# Plotting the histograms
plt.figure(figsize=(10, 6))
colors_count = 0
for key, dataframe in dataframes.items():
    print(type(dataframe['timesteps']))
    dataframe['timesteps'].plot(kind='density', label=key, alpha=0.5, color=colors[colors_count])
    colors_count+=1

plt.axvline(x = 0, color = 'black', label = 'Last Timestep')
plt.axvline(x = 1000, color = 'brown', label = 'First Timestep')

# first_timestep_row['timesteps'].plot(kind='density', label="First Timestep", alpha=0.5, color=colors[-2])
# last_timestep_row['timesteps'].plot(kind='density', label="Last Timestep", alpha=0.5, color=colors[-1])

plt.xlabel('Timesteps')
plt.ylabel('Frequency')
plt.xlim(-5, 1005)
plt.title('Comparison of Timesteps across Sampling Strategies')
plt.legend()
plt.savefig("timesteps.png")