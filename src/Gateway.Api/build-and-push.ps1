#!/usr/bin/env pwsh

# Build and Push Docker Image to GitHub Container Registry
# Usage: ./build-and-push.ps1 [version]

param(
    [string]$Version = "latest",
    [string]$Registry = "ghcr.io",
    [string]$Username = "akrasnikov79",
    [string]$ImageName = "gateway-service"
)

# Colors for output
$Green = "`e[32m"
$Yellow = "`e[33m"
$Red = "`e[31m"
$Reset = "`e[0m"

function Write-ColorOutput {
    param([string]$Message, [string]$Color)
    Write-Host "$Color$Message$Reset"
}

# Check if GitHub token is provided
if (-not $env:GITHUB_TOKEN) {
    Write-ColorOutput "Error: GITHUB_TOKEN environment variable is not set!" $Red
    Write-ColorOutput "Set it with: `$env:GITHUB_TOKEN = 'your_token_here'" $Yellow
    exit 1
}

$FullImageName = "$Registry/$Username/$ImageName`:$Version"

Write-ColorOutput "=== Building and Pushing Docker Image ===" $Green
Write-ColorOutput "Image: $FullImageName" $Yellow

# Login to GitHub Container Registry
Write-ColorOutput "Logging in to $Registry..." $Green
echo $env:GITHUB_TOKEN | docker login $Registry -u $Username --password-stdin

if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput "Error: Failed to login to $Registry" $Red
    exit 1
}

# Build Docker image
Write-ColorOutput "Building Docker image..." $Green
docker build -t $FullImageName .

if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput "Error: Failed to build Docker image" $Red
    exit 1
}

# Push Docker image
Write-ColorOutput "Pushing Docker image to registry..." $Green
docker push $FullImageName

if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput "Error: Failed to push Docker image" $Red
    exit 1
}

Write-ColorOutput "=== Successfully built and pushed $FullImageName ===" $Green

# Optional: Tag as latest if version is not latest
if ($Version -ne "latest") {
    $LatestImageName = "$Registry/$Username/$ImageName`:latest"
    Write-ColorOutput "Tagging as latest..." $Green
    docker tag $FullImageName $LatestImageName
    docker push $LatestImageName
    Write-ColorOutput "Also pushed as: $LatestImageName" $Green
} 