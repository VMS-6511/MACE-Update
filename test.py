
import os
from datasets import load_dataset

data_files = {}
train_data_dir = "/state/partition1/user/ralur/.cache/huggingface/hub/datasets/test_data"
data_files["train"] = os.path.join(train_data_dir, "**")

dataset = load_dataset(
    "imagefolder",
    data_files=data_files,
    cache_dir="/state/partition1/user/ralur/hf/hub",
)


