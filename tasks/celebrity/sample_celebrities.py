
import sys
import random
import pandas as pd
import argparse

def main(num_celebrities, random_seed, source_file):
    
    random.seed(random_seed)

    # Read the source CSV file
    df = pd.read_csv(source_file)

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
    parser.add_argument('--source_file', type=str, default='/data/healthy-ml/scratch/ralur/projects/MACE-Update/tasks/celebrity/celebrity_100_concepts.csv', help='Source CSV file')

    args = parser.parse_args()

    num_celebrities = args.num_celebrities
    random_seed = args.random_seed
    source_file = args.source_file
    
    main(num_celebrities, random_seed, source_file)
