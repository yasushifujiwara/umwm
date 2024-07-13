#!/bin/bash

# Check if expname is provided as an argument
if [ -z "$1" ]; then
  read -p "Please enter the experiment name (expname): " expname
else
  expname="$1"
fi

echo "============== Start creating symbolic links from ${expname} ============="

# Set the source directories
source_base_dir="../data/${expname}"

# Set the destination directories and the respective subdirectories
declare -A dirs=( ["namelists"]="namelists" ["input"]="input" ["output"]="output" ["restart"]="restart" )

# Create symbolic links for each directory
for dir in "${!dirs[@]}"; do
  source_dir="${source_base_dir}/${dir}"
  dest_dir="./${dirs[$dir]}"

  # Create the source directory if it doesn't exist
  if [ ! -d "$source_dir" ]; then
    mkdir -p "$source_dir"
    echo "Created source directory: $source_dir"
  fi

  # Check if the destination directory or link exists
  if [ -L "$dest_dir" ]; then
    # If it's a symbolic link, remove it
    rm "$dest_dir"
  elif [ -d "$dest_dir" ]; then
    # If it's a directory, ask whether to remove it
    read -p "$dest_dir exists as a directory. Do you want to remove it? (y/n) " answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
      rm -rf "$dest_dir"
      echo "Removed directory: $dest_dir"
    else
      echo "Skipping $dest_dir"
      continue
    fi
  fi

  # Create the symbolic link
  ln -s "$source_dir" "$dest_dir"
  echo "Created symbolic link: $dest_dir -> $source_dir"
done

echo "============== Symbolic link creation completed successfully ============="
