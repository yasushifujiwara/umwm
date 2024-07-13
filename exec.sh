#!/bin/bash

# Define the list of expnames and num_proc
expnames=("test/om101_old")  # Replace with your actual experiment names
num_proc=6  # Replace with the actual number of processors to use

# Get the current date and time for the log file
current_datetime=$(date '+%Y%m%d_%H%M%S')
log_file="./log/log_${current_datetime}"

# Create the log directory if it doesn't exist
mkdir -p ./log

# Function to log a message with the current date and time
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

# Start logging
log_message "Script started"

# Loop through each expname and execute the required commands
for expname in "${expnames[@]}"; do
  log_message "Processing $expname"

  # Create symbolic links
  ./pre_run.sh "$expname" 
  log_message "Created symbolic links for $expname"

  # Run the MPI job
  mpiexec -n ${num_proc} ./umwm > "../data/${expname}/log_${current_datetime}"
  log_message "Ran MPI job for $expname"

  # Mark the end of processing for this expname
  log_message "end $expname"
done

# Finish logging
log_message "Script completed"

echo "All operations completed. Check the log file at $log_file for details."
