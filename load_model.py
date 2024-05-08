import logging
import torch
from diffusers import StableDiffusionPipeline

model_id = "CompVis/stable-diffusion-v1-4"


pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float32)

#prompt = "A futuristic cityscape, vivid colors, hyper-detailed, panoramic view."
#image = pipe(prompt).images[0]
#image.show()
scheduler = pipe.scheduler
