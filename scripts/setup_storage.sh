#!/bin/bash

# Script to create/recreate storage directories for the observability stack
# Usage: 
#   ./setup_storage.sh [base_path]             - Create directories if they don't exist
#   ./setup_storage.sh [base_path] --recreate  - Delete existing data and recreate directories
#
# If base_path is not provided, it defaults to /storage/observability

set -e

# Process arguments
RECREATE=false
BASE_PATH="/storage/observability"

# Check for recreate flag
for arg in "$@"; do
  if [ "$arg" == "--recreate" ]; then
    RECREATE=true
  elif [ "$arg" != "--recreate" ]; then
    # If the argument is not --recreate, treat it as the base path
    BASE_PATH="$arg"
  fi
done

# Storage directories to create
DIRECTORIES=(
  "prometheus"
  "grafana"
  "grafana/alertmanager-data"
  "minio/data"
  "loki"
)

echo "Setting up storage directories in $BASE_PATH"

# Create base directory if it doesn't exist
if [ ! -d "$BASE_PATH" ]; then
  echo "Creating base directory: $BASE_PATH"
  sudo mkdir -p "$BASE_PATH"
  sudo chown "$(id -u):$(id -g)" "$BASE_PATH"
else
  echo "Base directory already exists: $BASE_PATH"
fi

# Handle recreate option
if [ "$RECREATE" = true ]; then
  echo "WARNING: Recreate option selected. This will delete all existing data!"
  read -p "Are you sure you want to continue? (y/n): " confirm
  
  if [[ "$confirm" == [yY] || "$confirm" == [yY][eE][sS] ]]; then
    echo "Deleting existing data..."
    for dir in "${DIRECTORIES[@]}"; do
      FULL_PATH="$BASE_PATH/$dir"
      if [ -d "$FULL_PATH" ]; then
        echo "Removing directory: $FULL_PATH"
        rm -rf "$FULL_PATH"
      fi
    done
  else
    echo "Operation cancelled."
    exit 0
  fi
fi

# Create each directory
for dir in "${DIRECTORIES[@]}"; do
  FULL_PATH="$BASE_PATH/$dir"
  if [ ! -d "$FULL_PATH" ]; then
    echo "Creating directory: $FULL_PATH"
    mkdir -p "$FULL_PATH"
  else
    echo "Directory already exists: $FULL_PATH"
  fi
done

echo "Storage setup completed successfully!"
echo "The following directories are now available:"
for dir in "${DIRECTORIES[@]}"; do
  echo "- $BASE_PATH/$dir"
done

echo -e "\nYou can now start the observability stack with: docker-compose up -d"
