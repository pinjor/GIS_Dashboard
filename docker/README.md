# 🐳 Docker Configuration

This directory contains Docker configuration files for containerized deployment of the GIS Dashboard Flutter web application.

## 📁 Directory Structure

```
docker/
├── Dockerfile              # Multi-stage build for Flutter web app
├── docker-compose.yml      # Docker Compose configuration
├── nginx/
│   └── nginx.conf         # Nginx configuration for serving the web app
└── README.md              # This file
```

## 🚀 Quick Start

### Prerequisites

- Docker Engine 20.10+ installed
- Docker Compose 2.0+ installed (optional, for docker-compose usage)
- At least 4GB of free disk space
- Internet connection for downloading dependencies

### Build and Run with Docker Compose (Recommended)

```bash
# Navigate to docker directory
cd docker

# Build and start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

The application will be available at `http://localhost:8080`

### Build Docker Image Manually

```bash
# Build the image
docker build -f docker/Dockerfile -t gis-dashboard:latest .

# Run the container
docker run -d -p 8080:80 --name gis-dashboard gis-dashboard:latest

# View logs
docker logs -f gis-dashboard

# Stop the container
docker stop gis-dashboard
docker rm gis-dashboard
```

## 📋 Configuration Files

### Dockerfile

The Dockerfile uses a multi-stage build process:

1. **Build Stage**: 
   - Uses Ubuntu 22.04 base image
   - Installs Flutter SDK 3.8.1
   - Installs project dependencies
   - Generates code with build_runner
   - Builds the Flutter web application

2. **Runtime Stage**:
   - Uses Nginx Alpine base image (lightweight)
   - Copies built web files
   - Configures Nginx for SPA routing

### docker-compose.yml

Docker Compose configuration includes:
- Service definition for the web application
- Port mapping (8080:80)
- Network configuration
- Restart policy
- Environment variables

### nginx/nginx.conf

Nginx configuration provides:
- SPA routing support (all routes redirect to index.html)
- Gzip compression for better performance
- Security headers (X-Frame-Options, X-Content-Type-Options, etc.)
- Static asset caching (1 year)
- Error page handling

## 🔧 Customization

### Environment Variables

You can customize the deployment using environment variables in `docker-compose.yml`:

```yaml
environment:
  - NODE_ENV=production
  # Add your custom environment variables here
```

### Port Configuration

To change the port mapping, modify `docker-compose.yml`:

```yaml
ports:
  - "YOUR_PORT:80"  # Change YOUR_PORT to your desired port
```

### Nginx Configuration

To customize Nginx settings, edit `docker/nginx/nginx.conf` and rebuild the image.

## 🏭 Production Deployment

### Production Considerations

1. **SSL/TLS Certificates**:
   - Use a reverse proxy (e.g., Traefik, Nginx Proxy Manager) with SSL
   - Or configure SSL directly in Nginx (requires certificate files)

2. **Environment Variables**:
   - Use Docker secrets or environment files for sensitive data
   - Never commit `.env` files to version control

3. **Domain Configuration**:
   - Update `server_name` in `nginx.conf` with your domain
   - Configure DNS records to point to your server

4. **Monitoring and Logging**:
   - Set up log aggregation (e.g., ELK stack, Loki)
   - Configure health checks
   - Monitor container resources

5. **Reverse Proxy**:
   - Use a reverse proxy for load balancing
   - Configure rate limiting
   - Set up caching strategies

6. **Security**:
   - Keep base images updated
   - Scan images for vulnerabilities
   - Use non-root user in containers (if possible)
   - Implement proper firewall rules

### Example Production Setup

```bash
# Build production image
docker build -f docker/Dockerfile -t gis-dashboard:prod .

# Tag for registry
docker tag gis-dashboard:prod your-registry.com/gis-dashboard:latest

# Push to registry
docker push your-registry.com/gis-dashboard:latest

# Deploy to production server
docker pull your-registry.com/gis-dashboard:latest
docker run -d \
  -p 80:80 \
  -p 443:443 \
  --name gis-dashboard-prod \
  --restart unless-stopped \
  your-registry.com/gis-dashboard:latest
```

## 🧪 Testing

### Test the Container Locally

```bash
# Build and run
docker-compose up -d

# Test the application
curl http://localhost:8080

# Check container health
docker ps
docker logs gis-dashboard-web
```

### Verify Nginx Configuration

```bash
# Check Nginx configuration syntax
docker exec gis-dashboard-web nginx -t

# Reload Nginx configuration
docker exec gis-dashboard-web nginx -s reload
```

## 🐛 Troubleshooting

### Container Won't Start

1. Check logs: `docker-compose logs`
2. Verify Docker is running: `docker ps`
3. Check port availability: `netstat -an | grep 8080`
4. Verify image built successfully: `docker images`

### Application Not Loading

1. Check container status: `docker ps`
2. View application logs: `docker logs gis-dashboard-web`
3. Verify Nginx is running: `docker exec gis-dashboard-web ps aux`
4. Test Nginx configuration: `docker exec gis-dashboard-web nginx -t`

### Build Failures

1. Ensure Flutter SDK version matches Dockerfile
2. Check internet connection for dependency downloads
3. Verify sufficient disk space
4. Review build logs for specific errors

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)

## 🤝 Contributing

When updating Docker configuration:

1. Test locally before committing
2. Update this README if configuration changes
3. Document any new environment variables
4. Ensure backward compatibility when possible

## 📝 Notes

- The Dockerfile builds the Flutter web application in release mode
- Nginx is used to serve the static files efficiently
- The configuration includes SPA routing support for Flutter web
- Gzip compression is enabled for better performance
- Security headers are configured for production use
- Static assets are cached for 1 year to improve performance

---

**Last Updated**: January 2025  
**Docker Version**: Tested with Docker 20.10+ and Docker Compose 2.0+
