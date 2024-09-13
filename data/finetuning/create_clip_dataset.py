import argparse
import os
import sys
import torch
parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
sys.path.insert(0, parent_dir)
from openai import OpenAI
from tqdm import tqdm
import numpy as np
import csv

from data.utils.process_laion import get_laion_prompts
from data.utils.process_celeba import get_celeba_prompts, get_celeba_df
from transformers import CLIPTokenizer, CLIPModel
import pandas as pd

model_name = "openai/clip-vit-base-patch32"
tokenizer = CLIPTokenizer.from_pretrained(model_name)
model = CLIPModel.from_pretrained(model_name)

concept_prompt_template = \
"""
What is the abstract concept that is being changed amongst the set of captions below:

{}

Please supply the list of values of this abstract concept as your response.

"""

BLOCK_SIZE = 1024
CONCEPT_NUMBER = 10

# Define the different prompt templates
templates = [
            "A portrait of {}",
            "An image capturing {} at a public event",
            "An oil painting of {}",
            "A sketch of {}",
            "{} in an official photo"
]

def generatePrompts(input_dir, unlabeled_dir, embeddings_dir, output_dir):
                # Load the CLIP model and processor

    input_prompts = []
    for root, dirs, files in os.walk(input_dir):
        for file in files:
            filename = os.path.splitext(file)[0]
            filename = filename.replace("-", " ")
            if "mask" not in filename:
                input_prompts.append(filename[:-2])

    prompts = ', '.join(input_prompts)

    client = OpenAI()

    completion = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {
                "role": "user",
                "content": concept_prompt_template.format(prompts),
            }
        ]
    )

    completion_output = completion.choices[0].message.content
    values_start_index = completion_output.index(':') + 1
    values_list = completion_output[values_start_index:].strip().split('\n')
    abstract_concept_values = [value.strip().split(' ', 1)[-1] for value in values_list]
    inputs = tokenizer(abstract_concept_values, padding=True, return_tensors="pt")
    with torch.no_grad():
        text_embeddings = model.get_text_features(**inputs)
    text_embeddings = text_embeddings.cpu().numpy()
    # Generate CLIP text embeddings of the abstract concept values
    unlabeled_embeddings = np.load(embeddings_dir + '/text_emb_0.npy')
    # Calculate cosine similarity matrix
    matrix_1 = text_embeddings / np.linalg.norm(text_embeddings, axis=1, keepdims=True)
    matrix_2 = unlabeled_embeddings / np.linalg.norm(unlabeled_embeddings, axis=1, keepdims=True)
    similarity_matrix = np.dot(matrix_1, matrix_2.T)
    min_similarity = np.min(similarity_matrix)
    max_similarity = np.max(similarity_matrix)
    intervals = np.linspace(min_similarity, max_similarity, num=5)
    celeba_df = get_celeba_df(unlabeled_dir)
    for interval_value in range(len(intervals)-1):
        selected_columns = []
        for i in range(similarity_matrix.shape[1]):
            column_values = similarity_matrix[:, i]
            if np.mean(column_values) >= intervals[interval_value] and np.mean(column_values) <= intervals[interval_value + 1]:
                selected_columns.append(i)
        np.random.seed(42)  # Add a fixed random seed
        if len(selected_columns) != 0:
            selected_columns_sample = np.random.choice(selected_columns, size=10, replace=False)
            selected_concepts = celeba_df.iloc[selected_columns_sample]['identity_name'].values



            # Create and write to a CSV file
            with open(output_dir + '/prompts_{}.csv'.format(interval_value), mode='w', newline='') as file:
                writer = csv.writer(file)
                
                # Write the header
                writer.writerow(["","type","prompt","evaluation_seed", "clip_lower", "clip_upper"])
                
                idx = 0  # Start index
                # Loop through each concept
                for celeb in selected_concepts:
                    # For each template, generate 5 entries with different seeds
                    for template in templates:
                        for seed in range(1, 6):
                            prompt = template.format(celeb)
                            writer.writerow([idx,"others",f"{prompt}",seed, intervals[interval_value], intervals[interval_value + 1]])
                            idx += 1

        
    
    # print(celeba_df.head())

if __name__=='__main__':
    parser = argparse.ArgumentParser(
                    prog = 'generateImages',
                    description = 'Generate Images using Diffusers Code')
    parser.add_argument('--input_dir', help='path to csv file with prompts', type=str, 
                        required=True)
    parser.add_argument('--unlabeled_dir', help='path to csv file with prompts', type=str, 
                        required=True)
    parser.add_argument('--embeddings_dir', help='path to csv file with prompts', type=str, 
                        required=True)
    parser.add_argument('--output_dir', help='path to csv file with prompts', type=str, 
                        required=True)
    args = parser.parse_args()

    generatePrompts(args.input_dir, args.unlabeled_dir, args.embeddings_dir, args.output_dir)