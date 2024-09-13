import os
import pandas as pd

def get_laion_prompts(data_dir):
    parquet_files = [os.path.join(data_dir, f) for f in os.listdir(data_dir) if f.endswith('.parquet')]
    for data_file in parquet_files:
        # Reading the parquet file
        yield pd.read_parquet(data_file)['TEXT'].values
