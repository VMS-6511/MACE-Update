import os, gc
import torch
from diffusers import StableDiffusionPipeline, DPMSolverMultistepScheduler
from omegaconf import OmegaConf
import argparse


concepts = [
    ['adam-driver', 'object'],
    ['adriana-lima', 'object'],
    ['amber-heard', 'object'],
    ['amy-adams', 'object'],
    ['andrew-garfield', 'object'],
    ['angelina-jolie', 'object'],
    ['anjelica-huston', 'object'],
    ['anna-faris', 'object'],
    ['anna-kendrick', 'object'],
    ['anne-hathaway', 'object'],
    ['arnold-schwarzenegger', 'object'],
    ['barack-obama', 'object'],
    ['beth-behrs', 'object'],
    ['bill-clinton', 'object'],
    ['bob-dylan', 'object'],
    ['bob-marley', 'object'],
    ['bradley-cooper', 'object'],
    ['bruce-willis', 'object'],
    ['bryan-cranston', 'object'],
    ['cameron-diaz', 'object'],
    ['channing-tatum', 'object'],
    ['charlie-sheen', 'object'],
    ['charlize-theron', 'object'],
    ['chris-evans', 'object'],
    ['chris-hemsworth', 'object'],
    ['chris-pine', 'object'],
    ['chuck-norris', 'object'],
    ['courteney-cox', 'object'],
    ['demi-lovato', 'object'],
    ['drake', 'object'],
    ['drew-barrymore', 'object'],
    ['dwayne-johnson', 'object'],
    ['ed-sheeran', 'object'],
    ['elon-musk', 'object'],
    ['elvis-presley', 'object'],
    ['emma-stone', 'object'],
    ['frida-kahlo', 'object'],
    ['george-clooney', 'object'],
    ['glenn-close', 'object'],
    ['gwyneth-paltrow', 'object'],
    ['harrison-ford', 'object'],
    ['hillary-clinton', 'object'],
    ['hugh-jackman', 'object'],
    ['idris-elba', 'object'],
    ['jake-gyllenhaal', 'object'],
    ['james-franco', 'object'],
    ['jared-leto', 'object'],
    ['jason-momoa', 'object'],
    ['jennifer-aniston', 'object'],
    ['jennifer-lawrence', 'object'],
    ['jennifer-lopez', 'object'],
    ['jeremy-renner', 'object'],
    ['jessica-biel', 'object'],
    ['jessica-chastain', 'object'],
    ['john-oliver', 'object'],
    ['john-wayne', 'object'],
    ['johnny-depp', 'object'],
    ['julianne-hough', 'object'],
    ['justin-timberlake', 'object'],
    ['kate-bosworth', 'object'],
    ['kate-winslet', 'object'],
    ['leonardo-dicaprio', 'object'],
    ['margot-robbie', 'object'],
    ['mariah-carey', 'object'],
    ['meryl-streep', 'object'],
    ['mick-jagger', 'object'],
    ['mila-kunis', 'object'],
    ['milla-jovovich', 'object'],
    ['morgan-freeman', 'object'],
    ['nick-jonas', 'object'],
    ['nicolas-cage', 'object'],
    ['nicole-kidman', 'object'],
    ['octavia-spencer', 'object'],
    ['olivia-wilde', 'object'],
    ['oprah-winfrey', 'object'],
    ['paul-mccartney', 'object'],
    ['paul-walker', 'object'],
    ['peter-dinklage', 'object'],
    ['philip-seymour-hoffman', 'object'],
    ['reese-witherspoon', 'object'],
    ['richard-gere', 'object'],
    ['ricky-gervais', 'object'],
    ['rihanna', 'object'],
    ['robin-williams', 'object'],
    ['ronald-reagan', 'object'],
    ['ryan-gosling', 'object'],
    ['ryan-reynolds', 'object'],
    ['shia-labeouf', 'object'],
    ['shirley-temple', 'object'],
    ['spike-lee', 'object'],
    ['stan-lee', 'object'],
    ['theresa-may', 'object'],
    ['tom-cruise', 'object'],
    ['tom-hanks', 'object'],
    ['tom-hardy', 'object'],
    ['tom-hiddleston', 'object'],
    ['whoopi-goldberg', 'object'],
    ['zac-efron', 'object'],
    ['zayn-malik', 'object'],
    ['melania-trump', 'object'],
  ]

def main(args):
    model_id = args.pretrained_model_name_or_path
    pipe = StableDiffusionPipeline.from_pretrained(model_id).to(args.device)
    
    pipe.safety_checker = None
    pipe.requires_safety_checker = False
    torch.Generator(device=args.device).manual_seed(42)
    
    
    pipe.scheduler = DPMSolverMultistepScheduler.from_config(pipe.scheduler.config)
    num_images = 8
    count = 0
    for single_concept in concepts:
        c = single_concept[0]
        t = single_concept[1]    
        count += 1
        print(f"Generating training data for concept {count}: {c}...")
        c = c.replace('-', ' ')
        output_folder = f"{args.output_dir}/generated_images"
        os.makedirs(output_folder, exist_ok=True)
        if t == "object":
            prompt = f"a photo of the {c}"
            print(f'Inferencing: {prompt}')
            images = pipe(prompt, num_inference_steps=args.steps, guidance_scale=7.5, num_images_per_prompt=num_images).images
            for i, im in enumerate(images):
                im.save(f"{output_folder}/{prompt.replace(' ', '-')}_{i}.jpg")
        elif t == "style":
            prompt = f"a photo in the style of {c}"
            print(f'Inferencing: {prompt}')
            images = pipe(prompt, num_inference_steps=args.steps, guidance_scale=7.5, num_images_per_prompt=num_images).images
            for i, im in enumerate(images):
                im.save(f"{output_folder}/{prompt.replace(' ', '-')}_{i}.jpg")
        else:
            raise ValueError("unknown concept type.")
        del images
        torch.cuda.empty_cache()
        gc.collect()
    

    del pipe
    torch.cuda.empty_cache()
    gc.collect()

if __name__ == "__main__":
    
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    steps = 30
    model_id = "CompVis/stable-diffusion-v1-4"
    output_dir = "/home/ralur/MACE-Update/triplet_experiments/baseline/"
    num_images = 8
    
    main(OmegaConf.create({
        "pretrained_model_name_or_path": model_id,
        "device": device,
        "steps": steps,
        "output_dir": output_dir,
        "num_images": num_images, 
    }))
