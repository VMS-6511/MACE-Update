import os
import argparse
from cleanfid import fid
import re
import csv

def main(args):
    file_exists = os.path.isfile(args.results_file) and os.path.getsize(args.results_file) > 0
    algo_name, task = re.split(r'_(?=cele)', args.dir1.split('/')[8])
    task = task.split('_')[1]
    score = fid.compute_fid(args.dir1, args.dir2)
    row = {'algo_name': algo_name, 'task': task, 'metric': 'FID', 'type': "erased", 'value': score}
    with open(args.results_file, 'a', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=row.keys())
        writer.writeheader()  # write the header
        writer.writerow(row)  # write the data row 
    row = {'algo_name': algo_name, 'task': task, 'metric': 'FID', 'type': "others", 'value': score}
    with open(args.results_file, 'a', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=row.keys())
        if not file_exists:
            writer.writeheader()  # write the header
        writer.writerow(row)  # write the data row   
    print(f'FID score: {score}')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Compute FID score between two directories.')
    parser.add_argument('--dir1', type=str, required=True, help='Path to the first directory')
    parser.add_argument('--dir2', type=str, required=True, help='Path to the second directory')
    parser.add_argument("--results_file", type=str, default='/data/healthy-ml/scratch/vinithms/projects/MACE-Update/experiments/experimental_results.csv')
    args = parser.parse_args()
    main(args)
