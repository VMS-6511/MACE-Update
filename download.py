from transformers import AutoModel, AutoTokenizer

model_name = "CompVis/stable-diffusion-v1-4"

# Download model and tokenizer
model = AutoModel.from_pretrained(model_name)
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Save model and tokenizer to a directory
model.save_pretrained('./cache/')
tokenizer.save_pretrained('./cache/')

