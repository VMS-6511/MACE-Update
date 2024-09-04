#!/bin/bash

source ~/.bashrc

# Get the current user
CURRENT_USER=$(whoami)

if [ "$CURRENT_USER" = "ralur" ]; then
    conda activate mace-update-v3
else
    conda activate mace-update-v5
fi

PREFIX=/data/healthy-ml/scratch/$CURRENT_USER/projects/MACE-Update

export PREFIX
