#!/bin/bash

# Build and Push Docker Image to GitHub Container Registry
# Usage: ./build-and-push.sh [version]

set -e  # Exit on any error

# Configuration variables
REGISTRY="ghcr.io"
USERNAME="akrasnikov79"
IMAGE_NAME="gateway-service"
VERSION="${1:-latest}"
FULL_IMAGE_PATH="${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}"
TOKEN=""

echo "=== Docker Build and Push Configuration ==="
echo "Registry: $REGISTRY"
echo "Username: $USERNAME"
echo "Image Name: $IMAGE_NAME"
echo "Version: $VERSION"
echo "Full Image Path: $FULL_IMAGE_PATH"
echo "============================================="

echo "🚀 Starting Docker build and push process..."

# Login to GitHub Container Registry
echo "🔑 Logging in to GitHub Container Registry..."
echo "$TOKEN" | docker login "$REGISTRY" -u "$USERNAME" --password-stdin

echo "✅ Login successful!"

# Build Docker image
echo "🏗️  Building Docker image: $FULL_IMAGE_PATH..."
docker build -t "$FULL_IMAGE_PATH" .

echo "✅ Build successful!"

# Push Docker image
echo "📤 Pushing Docker image to registry..."
docker push "$FULL_IMAGE_PATH"

echo "✅ Push successful!"
echo "🎉 Docker image published to: $FULL_IMAGE_PATH"

# Also tag as latest if version is not latest
if [ "$VERSION" != "latest" ]; then
    LATEST_IMAGE_PATH="${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest"
    echo "🏷️  Tagging as latest: $LATEST_IMAGE_PATH..."
    docker tag "$FULL_IMAGE_PATH" "$LATEST_IMAGE_PATH"
    docker push "$LATEST_IMAGE_PATH"
    echo "✅ Latest tag pushed successfully!"
fi

echo "✨ Process completed successfully!" 