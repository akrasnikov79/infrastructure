@echo off

REM Build and Push Docker Image to GitHub Container Registry
REM Usage: build-and-push.bat [version]

REM Configuration variables
set REGISTRY=ghcr.io
set USERNAME=akrasnikov79
set IMAGE_NAME=gateway-service
set VERSION=%1
if "%VERSION%"=="" set VERSION=latest
set FULL_IMAGE_PATH=%REGISTRY%/%USERNAME%/%IMAGE_NAME%:%VERSION%
set TOKEN=""

echo === Docker Build and Push Configuration ===
echo Registry: %REGISTRY%
echo Username: %USERNAME%
echo Image Name: %IMAGE_NAME%
echo Version: %VERSION%
echo Full Image Path: %FULL_IMAGE_PATH%
echo =============================================

echo Starting Docker build and push process...

REM Login to GitHub Container Registry
echo Logging in to GitHub Container Registry...
echo %TOKEN% | docker login %REGISTRY% -u %USERNAME% --password-stdin

if %ERRORLEVEL% neq 0 (
    echo Docker login failed!
    exit /b 1
)

echo Login successful!

REM Build Docker image
echo Building Docker image: %FULL_IMAGE_PATH%...
docker build -t %FULL_IMAGE_PATH% .

if %ERRORLEVEL% neq 0 (
    echo Docker build failed!
    exit /b 1
)

echo Build successful!

REM Push Docker image
echo Pushing Docker image to registry...
docker push %FULL_IMAGE_PATH%

if %ERRORLEVEL% neq 0 (
    echo Docker push failed!
    exit /b 1
)

echo Push successful!
echo Docker image published to: %FULL_IMAGE_PATH%

REM Also tag as latest if version is not latest
if not "%VERSION%"=="latest" (
    set LATEST_IMAGE_PATH=%REGISTRY%/%USERNAME%/%IMAGE_NAME%:latest
    echo Tagging as latest: %LATEST_IMAGE_PATH%...
    docker tag %FULL_IMAGE_PATH% %LATEST_IMAGE_PATH%
    docker push %LATEST_IMAGE_PATH%
    echo Latest tag pushed successfully!
)

echo Process completed successfully!
pause 