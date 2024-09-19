
import sys
import random
import pandas as pd
import argparse

def main(num_celebrities, random_seed):
    
    random.seed(random_seed)

    source_files = ['/data/healthy-ml/scratch/ralur/projects/MACE-Update/tasks/celebrity/celebrity_1_concepts.csv',
                    '/data/healthy-ml/scratch/ralur/projects/MACE-Update/tasks/celebrity/celebrity_5_concepts.csv',
                    '/data/healthy-ml/scratch/ralur/projects/MACE-Update/tasks/celebrity/celebrity_10_concepts.csv',
                    '/data/healthy-ml/scratch/ralur/projects/MACE-Update/tasks/celebrity/celebrity_100_concepts.csv']

    # Read the source CSV file
    df_list = [pd.read_csv(file) for file in source_files]
    df = pd.concat(df_list, ignore_index=True)

    df = df[df['type'] == 'others']
    # Get unique celebrities
    unique_celebrities = df[df['prompt'].str.match(r'^A portrait of \w+ \w+$')]['prompt'].str.split(' of ', expand=True)[1].unique()

    sampled_celebrities = random.sample(list(unique_celebrities), num_celebrities)
    print('sampled celebrities: ', sampled_celebrities)

    df['type'] = 'others'
    df = df.loc[df['prompt'].str.contains('|'.join(sampled_celebrities), case=False)]
    df = df.reset_index(drop=True)
    
    destination_file = f"/data/healthy-ml/scratch/ralur/projects/MACE-Update/tasks/celebrity/celebrity_random_concepts_seed{random_seed}.csv"
    df.to_csv(destination_file, index = False, index_label='')

    with open(destination_file, 'r') as file:
        lines = file.readlines()
    
    lines[0] = ",type,prompt,evaluation_seed\n"
    
    with open(destination_file, 'w') as file:
        file.writelines(lines)

    print(f"Sampled {num_celebrities} celebrities and saved to {destination_file}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Sample celebrities from a CSV file.')
    parser.add_argument('num_celebrities', type=int, help='Number of celebrities to sample')
    parser.add_argument('--random_seed', type=int, default=0, help='Random seed for sampling')
    
    args = parser.parse_args()

    num_celebrities = args.num_celebrities
    random_seed = args.random_seed
    
    main(num_celebrities, random_seed)
