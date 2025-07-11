#!/usr/bin/env pwsh

# Build and Push Docker Image to GitHub Container Registry
# Usage: ./build-and-push.ps1 [version]

# Configuration variables
$REGISTRY = "ghcr.io"
$USERNAME = "akrasnikov79"
$IMAGE_NAME = "gateway-service"
$VERSION = if ($args.Count -gt 0) { $args[0] } else { "latest" }
$FULL_IMAGE_PATH = "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:${VERSION}"
$TOKEN = ""

Write-Host "=== Docker Build and Push Configuration ===" -ForegroundColor Cyan
Write-Host "Registry: $REGISTRY" -ForegroundColor White
Write-Host "Username: $USERNAME" -ForegroundColor White
Write-Host "Image Name: $IMAGE_NAME" -ForegroundColor White
Write-Host "Version: $VERSION" -ForegroundColor White
Write-Host "Full Image Path: $FULL_IMAGE_PATH" -ForegroundColor White
Write-Host "=============================================" -ForegroundColor Cyan

Write-Host "Starting Docker build and push process..." -ForegroundColor Green

try {
    # Login to GitHub Container Registry
    Write-Host "Logging in to GitHub Container Registry..." -ForegroundColor Yellow
    echo $TOKEN | docker login $REGISTRY -u $USERNAME --password-stdin
    
    if ($LASTEXITCODE -ne 0) {
        throw "Docker login failed"
    }
    
    Write-Host "Login successful!" -ForegroundColor Green
    
    # Build Docker image
    Write-Host "Building Docker image: $FULL_IMAGE_PATH..." -ForegroundColor Yellow
    docker build -t $FULL_IMAGE_PATH .
    
    if ($LASTEXITCODE -ne 0) {
        throw "Docker build failed"
    }
    
    Write-Host "Build successful!" -ForegroundColor Green
    
    # Push Docker image
    Write-Host "Pushing Docker image to registry..." -ForegroundColor Yellow
    docker push $FULL_IMAGE_PATH
    
    if ($LASTEXITCODE -ne 0) {
        throw "Docker push failed"
    }
    
    Write-Host "Push successful!" -ForegroundColor Green
    Write-Host "Docker image published to: $FULL_IMAGE_PATH" -ForegroundColor Cyan
    
    # Also tag as latest if version is not latest
    if ($VERSION -ne "latest") {
        $LATEST_IMAGE_PATH = "${REGISTRY}/${USERNAME}/${IMAGE_NAME}:latest"
        Write-Host "Tagging as latest: $LATEST_IMAGE_PATH..." -ForegroundColor Yellow
        docker tag $FULL_IMAGE_PATH $LATEST_IMAGE_PATH
        docker push $LATEST_IMAGE_PATH
        Write-Host "Latest tag pushed successfully!" -ForegroundColor Green
    }
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "Process completed successfully!" -ForegroundColor Green 