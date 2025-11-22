# Xeams Email Server - Docker

Docker image for running Xeams, a Java-based email server, with Java 21.

## Prerequisites

- Docker installed on your system
- Ports 25, 80, 110, 143, 443, 465, 587, 993, 995, and 5272 available on your host machine

## Building the Image

Clone this repository and build the Docker image:

```bash
docker build -t xeams-server .
```

## Running the Container

### Option 1: Using Named Volumes (Recommended)

Named volumes are managed by Docker and work across all platforms. Data persists even if you remove the container.

```bash
docker run -d \
  --name xeams-server \
  -v xeams-data:/opt/Xeams \
  -p 25:25 \
  -p 80:80 \
  -p 110:110 \
  -p 143:143 \
  -p 443:443 \
  -p 465:465 \
  -p 587:587 \
  -p 993:993 \
  -p 995:995 \
  -p 5272:5272 \
  xeams-server
```

### Option 2: Using Bind Mounts

Bind mounts let you specify an exact host directory. Useful for direct file access.

**Windows (CMD):**
```cmd
docker run -d ^
  --name xeams-server ^
  -v C:\xeams-data:/opt/Xeams ^
  -p 25:25 -p 80:80 -p 110:110 -p 143:143 -p 443:443 ^
  -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 5272:5272 ^
  xeams-server
```

**Linux/Mac:**
```bash
docker run -d \
  --name xeams-server \
  -v /path/to/xeams-data:/opt/Xeams \
  -p 25:25 -p 80:80 -p 110:110 -p 143:143 -p 443:443 \
  -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 5272:5272 \
  xeams-server
```

### Option 3: Without Volumes (Testing Only)

For testing purposes, you can run without volumes. Note that data will be lost when the container is removed.

```bash
docker run -d \
  --name xeams-server \
  -p 25:25 -p 80:80 -p 110:110 -p 143:143 -p 443:443 \
  -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 5272:5272 \
  xeams-server
```

## Managing the Container

### Stop the container
```bash
docker stop xeams-server
```

### Start the container
```bash
docker start xeams-server
```

### View logs
```bash
docker logs xeams-server
```

### View real-time logs
```bash
docker logs -f xeams-server
```

### Remove the container
```bash
docker stop xeams-server
docker rm xeams-server
```

Note: Removing the container does NOT delete named volumes. Your data remains safe.

## Accessing Xeams

Once the container is running, access Xeams web interface at:

- HTTP: `http://localhost:80`
- HTTPS: `https://localhost:443`

## Exposed Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 25   | SMTP     | Mail Transfer |
| 80   | HTTP     | Web Interface |
| 110  | POP3     | Mail Retrieval |
| 143  | IMAP     | Mail Access |
| 443  | HTTPS    | Secure Web Interface |
| 465  | SMTPS    | Secure SMTP |
| 587  | SMTP     | Mail Submission |
| 993  | IMAPS    | Secure IMAP |
| 995  | POP3S    | Secure POP3 |
| 5272 | XMPP     | Messaging |

## Persistent Data

The entire Xeams installation directory (`/opt/Xeams`) is persisted as a single volume. This includes:

- Configuration files
- Log files
- Database files
- Email storage (good emails, spam, possible spam)
- Mail queues
- User data and repositories
- SSL certificates
- Search indexes
- Reports and templates

On first run, the container automatically initializes the volume with all necessary Xeams files.

## Volume Management

### List all volumes
```bash
docker volume ls
```

### Inspect the Xeams volume
```bash
docker volume inspect xeams-data
```

### Remove unused volumes
```bash
docker volume prune
```

### Backup the volume
```bash
docker run --rm -v xeams-data:/data -v $(pwd):/backup ubuntu tar czf /backup/xeams-backup.tar.gz -C /data .
```

### Restore the volume
```bash
docker run --rm -v xeams-data:/data -v $(pwd):/backup ubuntu tar xzf /backup/xeams-backup.tar.gz -C /data
```

## Troubleshooting

### Container won't start
Check the logs:
```bash
docker logs xeams-server
```

### Port already in use
Stop any services using the required ports, or modify the port mappings:
```bash
-p 8080:80  # Maps host port 8080 to container port 80
```

### Data not persisting
Ensure you're using `docker stop` and `docker start` instead of removing and recreating the container. Use named volumes for guaranteed persistence.

### Access volume data on Windows
Named volumes are stored in WSL2:
```
\\wsl$\docker-desktop-data\data\docker\volumes\xeams-data\_data
```

Or access via File Explorer by pressing `Win + R` and pasting the path above.

## License

Xeams is a product of Synametrics Technologies. Please refer to their licensing terms at https://www.xeams.com

## Support

For Xeams-specific issues, visit: https://www.xeams.com/KnowledgeBase.htm
