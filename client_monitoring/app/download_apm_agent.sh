#!/bin/bash

# Define variables
DOCKER_IMAGE="docker.elastic.co/observability/apm-agent-java:1.52.1"
CONTAINER_NAME="temp-apm-container"
SOURCE_PATH="/usr/agent/elastic-apm-agent.jar"
DESTINATION_PATH="./elastic-apm-agent.jar"

# Exit on any error
set -e

# Create and run a temporary container
echo "Creating temporary container..."
docker create --name "$CONTAINER_NAME" "$DOCKER_IMAGE"

# Copy the file from the container
echo "Copying APM agent..."
docker cp "${CONTAINER_NAME}:${SOURCE_PATH}" "$DESTINATION_PATH"

# Remove the temporary container
echo "Cleaning up..."
docker rm "$CONTAINER_NAME"

echo "Download complete! File saved to: $DESTINATION_PATH"
