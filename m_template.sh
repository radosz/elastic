#!/bin/bash
set -e

DIR_PATH="$1"
ENV_FILE=".env"

# Change to the specified directory
cd "$DIR_PATH"
echo $PWD
# Loop through all .yml files in current directory
for file in *.yml; do
    # Skip if no .yml files exist
    [[ -e "$file" ]] || break
    
    # Skip files with .docker.yml extension
    if [[ "$file" == *".docker.yml" ]]; then
        continue
    fi
    
    echo "Processing: $file"
    template.sh "$file" "$ENV_FILE"
done