import argparse
import os
import sys
import torch
parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
sys.path.insert(0, parent_dir)
from openai import OpenAI
from tqdm import tqdm

from data.utils.process_laion import get_laion_prompts
from data.utils.process_celeba import get_celeba_prompts
from transformers import CLIPProcessor, CLIPModel

model_name = "openai/clip-vit-base-patch32"
processor = CLIPProcessor.from_pretrained(model_name)
model = CLIPModel.from_pretrained(model_name)

concept_prompt_template = \
"""
What is the abstract concept that is being changed amongst the set of captions below:

{}

Please supply the list of values of this abstract concept as your response.

"""

BLOCK_SIZE = 1

def generatePrompts(input_dir, unlabeled_dir, output_dir):
                # Load the CLIP model and processor

    # input_prompts = []
    # for root, dirs, files in os.walk(input_dir):
    #     for file in files:
    #         filename = os.path.splitext(file)[0]
    #         filename = filename.replace("-", " ")
    #         if "mask" not in filename:
    #             input_prompts.append(filename[:-2])

    # prompts = ', '.join(input_prompts)

    # client = OpenAI()

    # completion = client.chat.completions.create(
    #     model="gpt-4o",
    #     messages=[
    #         {"role": "system", "content": "You are a helpful assistant."},
    #         {
    #             "role": "user",
    #             "content": concept_prompt_template.format(prompts),
    #         }
    #     ]
    # )

    # print(completion.choices[0].message)
    dataset = unlabeled_dir.split('/')[-1]
    if dataset == 'laion400m':
        unlabeled_prompts = get_laion_prompts(unlabeled_dir)
        for i, prompt_block in enumerate(unlabeled_prompts):
            print(i)
            prompt_block = [str(item).replace("'", '"') for item in prompt_block.tolist()]
            with open(output_dir + '/unlabeled_prompts_{}.txt'.format(i), 'w') as file:
                for item in tqdm(prompt_block):
                    file.write(item + '\n')
    elif dataset == 'Celeba_HQ_dialog':
        unlabeled_prompts = get_celeba_prompts(unlabeled_dir)
        prompt_blocks = [unlabeled_prompts[i:i+BLOCK_SIZE] for i in range(0, len(unlabeled_prompts), BLOCK_SIZE)]
        for i, prompt_block in enumerate(prompt_blocks):
            with open(output_dir + f'/unlabeled_prompts_{i}.txt', 'w') as file:
                for item in tqdm(prompt_block):
                    file.write(str(item) + '\n')
    else:
        raise ValueError(f"Dataset {dataset} not supported")


if __name__=='__main__':
    parser = argparse.ArgumentParser(
                    prog = 'generateImages',
                    description = 'Generate Images using Diffusers Code')
    parser.add_argument('--input_dir', help='path to csv file with prompts', type=str, 
                        required=True)
    parser.add_argument('--unlabeled_dir', help='path to csv file with prompts', type=str, 
                        required=True)
    parser.add_argument('--output_dir', help='path to csv file with prompts', type=str, 
                        required=True)
    args = parser.parse_args()

    generatePrompts(args.input_dir, args.unlabeled_dir, args.output_dir)