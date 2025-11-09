# Caddy with DuckDNS - Examples

This directory contains ready-to-use examples for deploying Caddy with DuckDNS DNS plugin in various scenarios.

## Quick Start

1. **Get a free DuckDNS subdomain** at [https://www.duckdns.org/](https://www.duckdns.org/)
2. **Copy your token** from the top of the DuckDNS page when logged in
3. **Choose an example** that matches your use case
4. **Create `.env` file** from `.env.example` and fill in your token
5. **Update the Caddyfile** with your DuckDNS subdomain
6. **Run** `docker-compose up -d`

## Available Examples

### 1. Simple Single Domain

**Files:**
- `Caddyfile.simple`
- `docker-compose.yml`

**Use case:** Basic setup for a DuckDNS subdomain with automatic HTTPS.

**Features:**
- Single domain HTTPS
- Automatic certificate renewal
- Simple response handler

**Quick start:**
```bash
cp Caddyfile.simple Caddyfile
cp .env.example .env
# Edit .env with your DuckDNS token
# Edit Caddyfile: replace "yourdomain" with your actual DuckDNS subdomain
docker-compose up -d
```

---

### 2. Reverse Proxy

**Files:**
- `Caddyfile.reverse-proxy`
- `docker-compose.full-stack.yml`

**Use case:** Reverse proxy for web applications and APIs.

**Features:**
- Multiple DuckDNS subdomains
- Backend health checks
- CORS support
- Access logging
- Custom headers

**Quick start:**
```bash
cp Caddyfile.reverse-proxy Caddyfile
cp docker-compose.full-stack.yml docker-compose.yml
cp .env.example .env
# Edit files with your DuckDNS details
docker-compose up -d
```

---

### 3. Multiple Domains

**Files:**
- `Caddyfile.multiple-domains`
- `docker-compose.yml`

**Use case:** Hosting multiple DuckDNS subdomains.

**Features:**
- Multiple DuckDNS subdomains (e.g., app.mydomain.duckdns.org, blog.mydomain.duckdns.org)
- Subdomain routing
- Different backends per subdomain

**Important:** DuckDNS does not support wildcard certificates. Each subdomain must be listed explicitly.

**Quick start:**
```bash
cp Caddyfile.multiple-domains Caddyfile
cp .env.example .env
# Register all needed subdomains at duckdns.org first
# Edit Caddyfile with your subdomains
docker-compose up -d
```

---

### 4. Advanced Production Setup

**Files:**
- `Caddyfile.advanced`
- `docker-compose.full-stack.yml`

**Use case:** Production-ready configuration with security and performance.

**Features:**
- Security headers (HSTS, CSP, etc.)
- Compression (gzip, zstd)
- Static file caching
- WebSocket support
- Load balancing
- Custom error pages
- Structured logging

**Quick start:**
```bash
cp Caddyfile.advanced Caddyfile
cp docker-compose.full-stack.yml docker-compose.yml
cp .env.example .env
# Edit files with your details
docker-compose up -d
```

---

### 5. WordPress

**Files:**
- `Caddyfile.wordpress`
- `docker-compose.wordpress.yml`

**Use case:** WordPress site with automatic HTTPS via DuckDNS.

**Features:**
- WordPress + MySQL
- Automatic HTTPS via DuckDNS
- Security headers
- Persistent data volumes

**Quick start:**
```bash
cp Caddyfile.wordpress Caddyfile
cp docker-compose.wordpress.yml docker-compose.yml
cp .env.example .env
# Edit .env with your DuckDNS token and WordPress passwords
# Edit Caddyfile with your DuckDNS subdomain
docker-compose up -d
```

Access: `https://yourdomain.duckdns.org/wp-admin`

---

### 6. Monitoring Stack

**Files:**
- `Caddyfile.monitoring`
- `docker-compose.monitoring.yml`
- `prometheus.yml`

**Use case:** Prometheus + Grafana monitoring with Caddy.

**Features:**
- Grafana dashboard
- Prometheus metrics
- Node exporter
- Caddy exporter
- Basic authentication
- Subdomain routing

**Quick start:**
```bash
cp Caddyfile.monitoring Caddyfile
cp docker-compose.monitoring.yml docker-compose.yml
cp .env.example .env
# Register subdomains: grafana.yourdomain.duckdns.org, prometheus.yourdomain.duckdns.org
# Edit files with your details
docker-compose up -d
```

Access:
- Grafana: `https://grafana.yourdomain.duckdns.org`
- Prometheus: `https://prometheus.yourdomain.duckdns.org`

---

## Configuration Guide

### DuckDNS Setup

1. **Create a free account** at [https://www.duckdns.org/](https://www.duckdns.org/)
   - Login with your preferred OAuth provider (Google, GitHub, etc.)

2. **Create your subdomain(s)**
   - Enter desired subdomain name
   - Point it to your server's public IP address
   - Click "add domain"

3. **Get your API token**
   - Your token is displayed at the top of the page when logged in
   - It's a long string like: `a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6`

### Environment Variables

Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

Edit `.env` with your token:
```bash
# DuckDNS Token (from duckdns.org when logged in)
DUCKDNS_API_TOKEN=a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6

# Your DuckDNS subdomain
DOMAIN=yourdomain.duckdns.org
```

### Domain Configuration

In your Caddyfile, replace placeholder domains with your actual DuckDNS subdomain:
```caddyfile
yourdomain.duckdns.org {
    tls {
        dns duckdns
    }
    respond "Hello World!"
}
```

## Common Tasks

### View Logs

```bash
# All logs
docker-compose logs -f

# Just Caddy
docker-compose logs -f caddy

# Last 100 lines
docker-compose logs --tail=100 caddy
```

### Reload Configuration

After editing Caddyfile:
```bash
docker-compose exec caddy caddy reload --config /etc/caddy/Caddyfile
```

Or restart:
```bash
docker-compose restart caddy
```

### Check Certificate Status

```bash
docker-compose exec caddy caddy list-certificates
```

### Test Configuration

Before applying:
```bash
docker-compose exec caddy caddy validate --config /etc/caddy/Caddyfile
```

### Backup Certificates

```bash
docker run --rm -v caddy_data:/data -v $(pwd):/backup alpine \
  tar czf /backup/caddy-data-backup.tar.gz /data
```

### Restore Certificates

```bash
docker run --rm -v caddy_data:/data -v $(pwd):/backup alpine \
  tar xzf /backup/caddy-data-backup.tar.gz -C /
```

## Troubleshooting

### Certificate Provisioning Fails

**Problem:** Certificate not being issued

**Solutions:**
1. Verify DuckDNS token is correct
2. Check your subdomain exists at duckdns.org
3. Verify subdomain points to correct IP address
4. Check Caddy logs: `docker-compose logs caddy`
5. Test DNS resolution: `dig yourdomain.duckdns.org`
6. Ensure DuckDNS service is not down (check duckdns.org)

### Connection Timeout

**Problem:** Cannot connect to domain

**Solutions:**
1. Verify ports 80 and 443 are open in firewall
2. Check subdomain IP points to your server at duckdns.org
3. Test DNS: `dig yourdomain.duckdns.org`
4. If behind NAT, ensure port forwarding is configured
5. Wait a few minutes for DNS propagation

### Backend Connection Refused

**Problem:** Caddy can't reach backend service

**Solutions:**
1. Ensure backend is running: `docker-compose ps`
2. Check service names match in docker-compose and Caddyfile
3. Verify backend is listening on correct port
4. Check backend health: `docker-compose logs backend`

### Permission Denied

**Problem:** Caddy can't write to volumes

**Solutions:**
1. Check volume permissions
2. Try with sudo: `sudo docker-compose up`
3. Fix volume ownership:
   ```bash
   sudo chown -R 1000:1000 ./caddy_data
   ```

### DuckDNS Token Not Working

**Problem:** Authentication fails

**Solutions:**
1. Verify you copied the entire token (it's quite long)
2. Check for extra spaces or newlines in .env file
3. Get a fresh token from duckdns.org
4. Ensure token is not expired (re-login to duckdns.org)

## Best Practices

### Security

- ✅ Always use HTTPS in production
- ✅ Enable HSTS headers
- ✅ Keep your DuckDNS token secret
- ✅ Use strong passwords for databases
- ✅ Restrict access to admin panels
- ✅ Keep credentials in `.env`, never commit to git
- ✅ Enable logging for audit trails
- ✅ Use basic auth for sensitive endpoints

### Performance

- ✅ Enable compression (gzip, zstd)
- ✅ Cache static assets
- ✅ Use HTTP/3 (enabled by default)
- ✅ Configure connection pooling
- ✅ Set up health checks

### Maintenance

- ✅ Monitor logs regularly
- ✅ Backup certificate data
- ✅ Test configuration changes before applying
- ✅ Keep Docker images updated
- ✅ Update DuckDNS IP if your public IP changes
- ✅ Check duckdns.org periodically to ensure domains are active

## DuckDNS Limitations

### No Wildcard Support

DuckDNS does not support wildcard DNS records. You must:
- Register each subdomain separately at duckdns.org
- List each subdomain explicitly in your Caddyfile
- Obtain separate certificates for each subdomain

Example of what **doesn't work**:
```caddyfile
*.yourdomain.duckdns.org {  # ❌ This won't work with DuckDNS
    tls {
        dns duckdns
    }
}
```

Example of what **does work**:
```caddyfile
app.yourdomain.duckdns.org {  # ✅ Explicit subdomain
    tls {
        dns duckdns
    }
}

api.yourdomain.duckdns.org {  # ✅ Another explicit subdomain
    tls {
        dns duckdns
    }
}
```

### Free Service

- DuckDNS is free and supported by donations
- Domains may expire if not updated regularly
- Consider donating if you rely on the service

## Advanced Usage

### Custom Plugins

To add more Caddy plugins, fork the repository and modify the `Dockerfile`:

```dockerfile
RUN xcaddy build \
    --with github.com/caddy-dns/duckdns \
    --with github.com/caddy-dns/cloudflare \
    --with your-custom-plugin
```

### Multiple Environments

Create separate docker-compose files:
- `docker-compose.prod.yml`
- `docker-compose.staging.yml`

Run specific environment:
```bash
docker-compose -f docker-compose.staging.yml up -d
```

### External Configuration

Mount configuration from external source:
```yaml
volumes:
  - /etc/caddy/Caddyfile:/etc/caddy/Caddyfile:ro
  - /var/caddy/data:/data
```

## Resources

- [Caddy Documentation](https://caddyserver.com/docs/)
- [DuckDNS Plugin Docs](https://github.com/caddy-dns/duckdns)
- [DuckDNS Service](https://www.duckdns.org/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Let's Encrypt](https://letsencrypt.org/)

## Support

- GitHub Issues: [Report a bug](https://github.com/ivannco/caddy_xcaddy_duckdns/issues)
- Caddy Community: [forum.caddyserver.com](https://caddy.community/)
- DuckDNS FAQ: [duckdns.org/faqs.jsp](https://www.duckdns.org/faqs.jsp)

## License

These examples are provided as-is for use with the Caddy DuckDNS Docker image.
