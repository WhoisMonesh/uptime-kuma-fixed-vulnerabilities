# Uptime Kuma - Secure Docker Image

This repository contains a security-enhanced Docker image for Uptime Kuma with reduced vulnerabilities and improved security practices.

## Security Enhancements

This Docker image includes several security improvements over the standard image:

1. **Non-root execution**: The application runs as a non-root user to minimize potential damage from security vulnerabilities
2. **Minimal attack surface**: Only essential packages are installed using `--no-install-recommends`
3. **Latest base image**: Uses the latest Node.js LTS with Debian Bookworm for up-to-date security patches
4. **Clean layers**: Proper cleanup of package cache to reduce image size and potential vulnerabilities
5. **Proper signal handling**: Uses dumb-init for proper process management

## Building the Image

To build the secure Docker image:

```bash
# Build the image
docker build -f dockerfile_secure -t uptime-kuma:secure .

# Or with a specific tag
docker build -f dockerfile_secure -t uptime-kuma:secure-v2.0.2 .
```

## Running the Container

### Basic Usage
```bash
# Run with default settings
docker run -d \
  --name uptime-kuma \
  -p 3001:3001 \
  -v uptime-kuma-data:/app/data \
  uptime-kuma:secure
```

### Production Usage
```bash
# Run with recommended production settings
docker run -d \
  --name uptime-kuma \
  -p 3001:3001 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v uptime-kuma-data:/app/data \
  --restart=unless-stopped \
  uptime-kuma:secure
```

### With Docker Compose
```yaml
version: "3.3"
services:
  uptime-kuma:
    image: uptime-kuma:secure
    container_name: uptime-kuma
    restart: unless-stopped
    ports:
      - "3001:3001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - uptime-kuma-data:/app/data
    environment:
      - NODE_ENV=production
```

## Security Best Practices

### 1. Use Named Volumes
Always use named volumes instead of bind mounts when possible for better security isolation.

### 2. Run with Limited Capabilities
Consider running with limited capabilities:
```bash
docker run -d \
  --name uptime-kuma \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  -p 3001:3001 \
  -v uptime-kuma-data:/app/data \
  uptime-kuma:secure
```

### 3. Use a Dedicated Network
```bash
# Create a dedicated network
docker network create uptime-kuma-network

# Run with the dedicated network
docker run -d \
  --name uptime-kuma \
  --network uptime-kuma-network \
  -p 3001:3001 \
  -v uptime-kuma-data:/app/data \
  uptime-kuma:secure
```

## Vulnerability Scanning

To scan the image for vulnerabilities, you can use tools like Trivy:

```bash
# Install Trivy (if not already installed)
# Then scan the image
trivy image uptime-kuma:secure
```

## Comparison with Standard Image

| Feature | Standard Image | Secure Image |
|---------|----------------|--------------|
| User | root or node | non-root user |
| Package Cache | May remain | Cleaned up |
| Base Image Updates | Fixed version | Latest LTS |
| Attack Surface | Larger | Minimized |
| Signal Handling | Basic | Enhanced with dumb-init |

## Environment Variables

The image supports the following environment variables:

- `UPTIME_KUMA_IS_CONTAINER`: Automatically set to 1
- `NODE_ENV`: Set to production by default
- All standard Uptime Kuma environment variables are supported

## Ports

- `3001`: Main application port (HTTP)

## Volumes

- `/app/data`: For persistent data storage (SQLite database, settings, etc.)

## Health Checks

The image includes a built-in health check that verifies the application is running properly. The health check runs every 60 seconds with a 30-second timeout, starting after 180 seconds with 5 retries.

## Troubleshooting

### Container Won't Start
- Check logs: `docker logs uptime-kuma`
- Ensure the data volume has proper permissions
- Verify port 3001 is not already in use

### Performance Issues
- Ensure adequate system resources
- Check that the data volume is on a fast storage device
- Monitor container resource usage

### Security Issues
- Regularly rebuild the image to get the latest security patches
- Monitor for new vulnerabilities using scanning tools
- Keep Docker engine updated

## Updating

To update to a new version:
1. Pull the latest source
2. Rebuild the image: `docker build -f dockerfile_secure -t uptime-kuma:secure .`
3. Stop the current container: `docker stop uptime-kuma`
4. Remove the old container: `docker rm uptime-kuma`
5. Run the new container with the same parameters

## Contributing

We welcome contributions to improve the security of this Docker image. Please submit pull requests with security enhancements.

## License

This Docker setup is provided under the same MIT License as the original Uptime Kuma project.
