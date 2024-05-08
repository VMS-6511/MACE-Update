from datasets import Dataset, DatasetDict, load_dataset, load_from_disk

import pandas as pd

def load_dataset_from_files():
    # Load your CSV or JSON file here
    dataset = Dataset.from_pandas(pd.read_csv(f"test_dataset.csv"))
    
    return DatasetDict({
        'train': dataset
    })

dataset = load_dataset_from_files()

dataset.save_to_disk('./test_hf_data')

dataset = load_from_disk('./test_hf_data')
