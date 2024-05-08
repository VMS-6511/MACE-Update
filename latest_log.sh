#!/bin/bash

mv slurm-*.out logs/
# Find the file with the highest number in the name
latest_file=$(ls logs/slurm-*.out | sort -t '-' -k 2 -n | tail -n 1)

# Open it with vim
vim "$latest_file"

