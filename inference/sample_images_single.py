import os
from diffusers import StableDiffusionPipeline, DDIMScheduler
import torch
import pandas as pd
import argparse
from accelerate import PartialState, Accelerator


def generate_images(device='cuda:0', guidance_scale = 7.5, image_size=512, ddim_steps=100, num_samples=1, from_case=0):

    pipe = StableDiffusionPipeline.from_pretrained("CompVis/stable-diffusion-v1-4")
    pipe.scheduler = DDIMScheduler.from_config(pipe.scheduler.config)
    pipe.safety_checker = None
    pipe.requires_safety_checker = False
    
    accelerator = Accelerator()
    state = PartialState()
    pipe.to(state.device)

    prompt = "A portrait of a Jennifer Aniston"
    
    print(f'Inferencing: {prompt}')

    images = pipe(prompt, num_inference_steps=50, guidance_scale=7.5, num_images_per_prompt=1, 
                          generator=torch.manual_seed(4)).images
    for k, im in enumerate(images):
        im.save(f"./a portrait of a jennifer aniston_{k}_SD.png")   
    
    accelerator.wait_for_everyone()


if __name__=='__main__':
    parser = argparse.ArgumentParser(
                    prog = 'generateImages',
                    description = 'Generate Images using Diffusers Code')
    parser.add_argument('--device', help='cuda device to run on', type=str, required=False, default='cuda:0')
    parser.add_argument('--guidance_scale', help='guidance to run eval', type=float, required=False, default=7.5)
    parser.add_argument('--image_size', help='image size used to train', type=int, required=False, default=512)
    parser.add_argument('--from_case', help='continue generating from case_number', type=int, required=False, default=0)
    parser.add_argument('--num_samples', help='number of samples per prompt', type=int, required=False, default=1)
    parser.add_argument('--ddim_steps', help='ddim steps of inference used to train', type=int, required=False, default=50)
    args = parser.parse_args()
    
    device = args.device
    guidance_scale = args.guidance_scale
    image_size = args.image_size
    ddim_steps = args.ddim_steps
    num_samples= args.num_samples
    from_case = args.from_case
    
    generate_images(device=device, guidance_scale = guidance_scale, 
                    image_size=image_size, ddim_steps=ddim_steps, num_samples=num_samples,from_case=from_case)
