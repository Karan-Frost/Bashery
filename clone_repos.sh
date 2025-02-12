#!/bin/bash

# Check if the first argument is --shallow
SHALLOW_CLONE=0
if [ "$1" == "--shallow" ]; then
  SHALLOW_CLONE=1
  shift  # Remove the first argument so that only repo entries remain
fi

# Usage check: at least one argument is required.
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 [--shallow] \"repo_url,branch,target_dir\" [\"repo_url,branch,target_dir\" ...]"
  exit 1
fi

# Loop through each argument.
for entry in "$@"; do
  # Split the entry into variables using comma as the delimiter.
  IFS=',' read -r repo_url branch target_dir <<< "$entry"
  
  # Validate the parsed values.
  if [ -z "$repo_url" ] || [ -z "$branch" ] || [ -z "$target_dir" ]; then
    echo "Invalid argument: '$entry'"
    echo "Expected format: repo_url,branch,target_dir"
    exit 1
  fi
  
  echo "-------------------------------"
  echo "Processing repository:"
  echo "Repository URL: $repo_url"
  echo "Branch:         $branch"
  echo "Target Dir:     $target_dir"
  
  # Remove the target directory if it exists.
  if [ -d "$target_dir" ]; then
    echo "Removing existing directory: $target_dir"
    rm -rf "$target_dir"
  else
    echo "Directory $target_dir does not exist. No need to remove."
  fi

  # Construct the clone command
  CLONE_CMD="git clone --branch \"$branch\""
  if [ "$SHALLOW_CLONE" -eq 1 ]; then
    CLONE_CMD="$CLONE_CMD --depth=1"
  fi
  CLONE_CMD="$CLONE_CMD \"$repo_url\" \"$target_dir\""

  # Execute the clone command
  echo "Running: $CLONE_CMD"
  eval $CLONE_CMD
  
  # Check if the clone command succeeded.
  if [ "$?" -ne 0 ]; then
    echo "Error cloning repository $repo_url"
    exit 1
  fi
done

echo "-------------------------------"
echo "All repositories have been cloned successfully."
