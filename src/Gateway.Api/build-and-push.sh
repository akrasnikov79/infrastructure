#!/bin/bash

# Build and Push Docker Image to GitHub Container Registry
# Usage: ./build-and-push.sh [version]

set -e

VERSION=${1:-latest}
REGISTRY="ghcr.io"
USERNAME="akrasnikov79"
IMAGE_NAME="gateway-service"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function echo_color() {
    echo -e "${1}${2}${NC}"
}

# Check if GitHub token is provided
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo_color $RED "Error: GITHUB_TOKEN environment variable is not set!"
    echo_color $YELLOW "Set it with: export GITHUB_TOKEN='your_token_here'"
    exit 1
fi

FULL_IMAGE_NAME="$REGISTRY/$USERNAME/$IMAGE_NAME:$VERSION"

echo_color $GREEN "=== Building and Pushing Docker Image ==="
echo_color $YELLOW "Image: $FULL_IMAGE_NAME"

# Login to GitHub Container Registry
echo_color $GREEN "Logging in to $REGISTRY..."
echo "$GITHUB_TOKEN" | docker login $REGISTRY -u $USERNAME --password-stdin

# Build Docker image
echo_color $GREEN "Building Docker image..."
docker build -t "$FULL_IMAGE_NAME" .

# Push Docker image
echo_color $GREEN "Pushing Docker image to registry..."
docker push "$FULL_IMAGE_NAME"

echo_color $GREEN "=== Successfully built and pushed $FULL_IMAGE_NAME ==="

# Optional: Tag as latest if version is not latest
if [[ "$VERSION" != "latest" ]]; then
    LATEST_IMAGE_NAME="$REGISTRY/$USERNAME/$IMAGE_NAME:latest"
    echo_color $GREEN "Tagging as latest..."
    docker tag "$FULL_IMAGE_NAME" "$LATEST_IMAGE_NAME"
    docker push "$LATEST_IMAGE_NAME"
    echo_color $GREEN "Also pushed as: $LATEST_IMAGE_NAME"
fi 