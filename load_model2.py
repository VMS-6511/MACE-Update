import logging
from transformers import AutoModelForSequenceClassification, AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased", use_fast=True)
model = AutoModelForSequenceClassification.from_pretrained("bert-base-uncased")
