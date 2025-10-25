# Uptime Kuma - Docker Hub Deployment

This guide explains how to build and deploy a security-enhanced Uptime Kuma Docker image to Docker Hub with minimal vulnerabilities.

## Security-Enhanced Docker Image Features

Our security-enhanced Docker image includes several improvements:

1. **Latest Base Image**: Uses the most recent Node.js LTS with Debian Bookworm for up-to-date security patches
2. **System Updates**: All system packages are updated to their latest versions during build
3. **Non-root Execution**: Runs as a non-root user to minimize potential damage
4. **Minimal Attack Surface**: Only essential packages are installed
5. **Clean Layers**: Package cache is cleaned to reduce image size and vulnerabilities
6. **Content Addressable Base**: Uses SHA256 digest for base image to ensure integrity

## Prerequisites

- Docker installed and running
- Docker Hub account
- (Optional) Trivy for vulnerability scanning

## Building the Image

### Using the Build Script

1. Make the script executable:
```bash
chmod +x docker-build.sh
```

2. Run the build script:
```bash
./docker-build.sh
```

### Manual Build

```bash
# Build the security-enhanced image
docker build -f Dockerfile.security -t uptime-kuma-secure:latest .
```

## Vulnerability Scanning

Before pushing to Docker Hub, scan the image for vulnerabilities:

### Using Trivy
```bash
# Install Trivy (if not already installed)
# For Debian/Ubuntu:
sudo apt-get install trivy

# Scan the image
trivy image uptime-kuma-secure:latest
```

### Using Docker Scout
```bash
# Install Docker Scout (if not already installed)
# Scan the image
docker scout cves uptime-kuma-secure:latest
```

## Pushing to Docker Hub

### 1. Tag the Image
```bash
# Replace 'your-dockerhub-username' with your actual Docker Hub username
docker tag uptime-kuma-secure:latest your-dockerhub-username/uptime-kuma-secure:latest
docker tag uptime-kuma-secure:latest your-dockerhub-username/uptime-kuma-secure:2.0.2  # Use actual version
```

### 2. Log in to Docker Hub
```bash
docker login
```

### 3. Push the Image
```bash
docker push your-dockerhub-username/uptime-kuma-secure:latest
docker push your-dockerhub-username/uptime-kuma-secure:2.0.2
```

## Multi-Platform Builds

To support multiple architectures (amd64, arm64, arm/v7):

```bash
# Create a builder instance
docker buildx create --name multi-arch-builder --use

# Build and push for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -f Dockerfile.security -t your-dockerhub-username/uptime-kuma-secure:latest --push .
```

## Running the Image from Docker Hub

Once pushed to Docker Hub, users can run the image:

```bash
# Pull and run the latest image
docker run -d \
  --name uptime-kuma \
  -p 3001:3001 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v uptime-kuma-data:/app/data \
  your-dockerhub-username/uptime-kuma-secure:latest
```

## Security Best Practices for Docker Hub

### 1. Automated Builds
Consider setting up automated builds that rebuild the image when:
- Base image is updated
- Security patches are released
- Source code is updated

### 2. Image Signing
Sign your images for authenticity:
```bash
# Using Docker Content Trust
export DOCKER_CONTENT_TRUST=1
docker push your-dockerhub-username/uptime-kuma-secure:latest
```

### 3. Vulnerability Monitoring
- Regularly scan your images with tools like Trivy, Clair, or Docker Scout
- Subscribe to security advisories for your base image and dependencies
- Update and rebuild images regularly

### 4. Minimal Permissions
- The image runs as a non-root user
- Only necessary ports are exposed
- Minimal packages are installed

## Image Verification

Users can verify the integrity of the image:

```bash
# Pull the image
docker pull your-dockerhub-username/uptime-kuma-secure:latest

# Check image layers and size
docker images your-dockerhub-username/uptime-kuma-secure

# Run a security scan
trivy image your-dockerhub-username/uptime-kuma-secure:latest
```

## Docker Hub Repository Setup

### 1. Create Repository
- Go to Docker Hub
- Create a new repository named `uptime-kuma-secure`
- Set visibility (public or private)

### 2. Repository Configuration
- Add description and documentation
- Configure automated builds if desired
- Set up vulnerability scanning

### 3. Tags Strategy
- Use semantic versioning (e.g., 2.0.2)
- Use `latest` for the most recent stable version
- Consider date-based tags for regular updates

## Troubleshooting

### Build Issues
- Ensure Docker is running
- Check available disk space
- Verify internet connectivity

### Push Issues
- Verify Docker Hub credentials
- Check repository permissions
- Ensure repository name is available

### Security Scan Issues
- Update Trivy to the latest version
- Check for network connectivity to vulnerability databases
- Verify the image exists locally

## Updating the Image

When new security patches are available:

1. Update the base image version in Dockerfile.security
2. Rebuild the image
3. Scan for vulnerabilities
4. Push to Docker Hub with new version tag

## Verification Commands

To verify a successful build and security posture:

```bash
# Build the image
docker build -f Dockerfile.security -t uptime-kuma-test .

# Scan for vulnerabilities
trivy image uptime-kuma-test

# Run a quick test
docker run --rm uptime-kuma-test npm audit

# Check that it runs properly
docker run --rm uptime-kuma-test node -v
```

## Conclusion

This security-enhanced Docker image provides a more secure deployment option for Uptime Kuma with reduced vulnerabilities. Always keep your images updated and regularly scan for new vulnerabilities.
