#!/bin/bash

# Uptime Kuma Secure Docker Image Build Script
# This script builds a security-enhanced Docker image for Uptime Kuma

set -e # Exit immediately if a command exits with a non-zero status

# Configuration
IMAGE_NAME="uptime-kuma-secure"
DOCKERFILE="Dockerfile.security"
TAG="latest"
DOCKERHUB_REPO=""  # Set this to your Docker Hub repository, e.g. "yourusername/uptime-kuma"

echo "Building Uptime Kuma Security-Enhanced Docker Image..."
echo "====================================================="

# Build the Docker image
echo "Building the image..."
docker build -f $DOCKERFILE -t $IMAGE_NAME:$TAG .

echo "Build completed successfully!"
echo ""

# Optional: Run vulnerability scan with Trivy if available
if command -v trivy &> /dev/null; then
    echo "Running vulnerability scan with Trivy..."
    trivy image $IMAGE_NAME:$TAG
else
    echo "Trivy not found. Install Trivy to scan for vulnerabilities:"
    echo "  - https://aquasecurity.github.io/trivy/"
    echo "  - For Debian/Ubuntu: apt-get install trivy"
    echo "  - For other systems: Check Trivy documentation"
fi

echo ""
echo "To tag and push to Docker Hub, use:"
echo "  docker tag $IMAGE_NAME:$TAG \$DOCKERHUB_REPO:$TAG"
echo "  docker push \$DOCKERHUB_REPO:$TAG"
echo ""
echo "To run the container:"
echo "  docker run -d --name uptime-kuma -p 3001:3001 -v uptime-kuma-data:/app/data $IMAGE_NAME:$TAG"
