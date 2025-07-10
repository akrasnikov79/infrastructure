#!/usr/bin/env pwsh

# Test Gateway API Setup
# This script verifies that all components are configured correctly

$Green = "`e[32m"
$Yellow = "`e[33m"
$Red = "`e[31m"
$Blue = "`e[34m"
$Reset = "`e[0m"

function Write-ColorOutput {
    param([string]$Message, [string]$Color)
    Write-Host "$Color$Message$Reset"
}

function Test-FileExists {
    param([string]$Path, [string]$Description)
    if (Test-Path $Path) {
        Write-ColorOutput "✓ $Description exists" $Green
        return $true
    } else {
        Write-ColorOutput "✗ $Description missing: $Path" $Red
        return $false
    }
}

function Test-DockerInstalled {
    try {
        $version = docker --version
        Write-ColorOutput "✓ Docker installed: $version" $Green
        return $true
    } catch {
        Write-ColorOutput "✗ Docker not installed or not running" $Red
        return $false
    }
}

function Test-GitHubToken {
    if ($env:GITHUB_TOKEN) {
        $tokenLength = $env:GITHUB_TOKEN.Length
        Write-ColorOutput "✓ GITHUB_TOKEN is set (length: $tokenLength)" $Green
        return $true
    } else {
        Write-ColorOutput "✗ GITHUB_TOKEN environment variable not set" $Red
        Write-ColorOutput "  Set it with: `$env:GITHUB_TOKEN = 'your_token_here'" $Yellow
        return $false
    }
}

Write-ColorOutput "=== Gateway API Setup Test ===" $Blue
Write-ColorOutput ""

$allGood = $true

# Test files
$allGood = (Test-FileExists "Gateway.Api.csproj" "Gateway.Api project file") -and $allGood
$allGood = (Test-FileExists "Program.cs" "Program.cs") -and $allGood
$allGood = (Test-FileExists "ocelot.json" "Ocelot configuration") -and $allGood
$allGood = (Test-FileExists "Dockerfile" "Dockerfile") -and $allGood
$allGood = (Test-FileExists ".dockerignore" ".dockerignore") -and $allGood
$allGood = (Test-FileExists "build-and-push.ps1" "PowerShell build script") -and $allGood
$allGood = (Test-FileExists "build-and-push.sh" "Bash build script") -and $allGood
$allGood = (Test-FileExists "Makefile" "Makefile") -and $allGood
$allGood = (Test-FileExists "BUILD.md" "Build documentation") -and $allGood

Write-ColorOutput ""

# Test Docker
$allGood = (Test-DockerInstalled) -and $allGood

Write-ColorOutput ""

# Test GitHub Token
$allGood = (Test-GitHubToken) -and $allGood

Write-ColorOutput ""

# Test docker-compose files
$allGood = (Test-FileExists "../../deploy/proxy/docker-compose.yml" "Proxy docker-compose.yml") -and $allGood
$allGood = (Test-FileExists "../../deploy/proxy/nginx/nginx.conf" "Nginx configuration") -and $allGood

Write-ColorOutput ""

if ($allGood) {
    Write-ColorOutput "🎉 All checks passed! You're ready to build and deploy." $Green
    Write-ColorOutput ""
    Write-ColorOutput "Next steps:" $Blue
    Write-ColorOutput "1. Set GITHUB_TOKEN if not already set" $Yellow
    Write-ColorOutput "2. Run: make push  (or ./build-and-push.ps1)" $Yellow
    Write-ColorOutput "3. Run: cd ../../deploy/proxy && docker-compose up -d" $Yellow
} else {
    Write-ColorOutput "❌ Some checks failed. Please fix the issues above." $Red
}

Write-ColorOutput "" 