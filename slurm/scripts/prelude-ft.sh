#!/bin/bash

source ~/.bashrc

# Get the current user
CURRENT_USER=$(whoami)

if [ "$CURRENT_USER" = "ralur" ]; then
    conda activate mace-update-v33-ft
else
    conda activate mace-update-v5-ft
fi

PREFIX=/data/healthy-ml/scratch/$CURRENT_USER/projects/MACE-Robustness

export PREFIX
