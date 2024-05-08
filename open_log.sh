#!/bin/bash

# Check if a job ID was provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <job-id>"
    exit 1
fi

# Assign the first argument as job ID
JOB_ID=$1

# Define the log file path
LOG_FILE="logs/slurm-${JOB_ID}.out"

# Check if the log file exists
if [ -f "$LOG_FILE" ]; then
    # Open the log file with vim
    vim "$LOG_FILE"
else
    echo "Log file does not exist: $LOG_FILE"
    exit 2
fi

