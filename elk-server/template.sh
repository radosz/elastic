#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

# Download envsubst if it doesn't exist
if ! command -v envsubst >/dev/null 2>&1; then
    echo "Installing envsubst..."
    curl -L https://github.com/a8m/envsubst/releases/download/v1.4.2/envsubst-Linux-x86_64 -o envsubst
    chmod +x envsubst
    mv envsubst /bin/envsubst
else
    echo "envsubst is already installed"
fi

# Ensure that two parameters are provided.
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <template_file> <env_file>"
  exit 1
fi

INPUT_TEMPLATE="${1%}"
ENV_FILE="$2"
OUTPUT_FILE="${1%}.ready"

# Check if the input template file exists.
if [ ! -f "$INPUT_TEMPLATE" ]; then
  echo "Error: template file '$INPUT_TEMPLATE' does not exist."
  exit 1
fi

# Check if the environment file exists.
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: environment file '$ENV_FILE' does not exist."
  exit 1
fi

# Set environment variables from the environment file.
set -a
source "$PWD/$ENV_FILE"
set +a

# Substitute environment variables in the template file.
envsubst < "$INPUT_TEMPLATE" > "$OUTPUT_FILE"
rm $INPUT_TEMPLATE
mv $OUTPUT_FILE $INPUT_TEMPLATE
echo "Generated $INPUT_TEMPLATE"
