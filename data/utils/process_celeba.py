import os
import pandas as pd

MAPPING_TXT_FILE = "CelebA-HQ-to-CelebA-mapping.txt"
IDENTITY_TXT_FILE = "list_identity_celeba.txt"

def get_celeba_prompts(data_dir):
    mapping_df = pd.read_csv(os.path.join(data_dir, MAPPING_TXT_FILE), sep="\s+", header=0)
    identity_df = pd.read_csv(os.path.join(data_dir, IDENTITY_TXT_FILE), sep="\s+", header=1)
    merged_df = pd.merge(mapping_df, identity_df, left_on='orig_file', right_on='image_id')
    merged_df['new_file'] = merged_df['idx'].astype(str) + '.jpg'
    merged_df['identity_name'] = merged_df['identity_name'].str.replace('_', ' ')
    return merged_df['identity_name'].values

def get_celeba_df(data_dir):
    mapping_df = pd.read_csv(os.path.join(data_dir, MAPPING_TXT_FILE), sep="\s+", header=0)
    identity_df = pd.read_csv(os.path.join(data_dir, IDENTITY_TXT_FILE), sep="\s+", header=1)
    merged_df = pd.merge(mapping_df, identity_df, left_on='orig_file', right_on='image_id')
    merged_df['new_file'] = merged_df['idx'].astype(str) + '.jpg'
    merged_df['identity_name'] = merged_df['identity_name'].str.replace('_', ' ')
    return merged_df