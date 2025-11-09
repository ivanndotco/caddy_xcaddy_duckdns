# Caddy with DuckDNS Plugin

Docker image with Caddy web server and DuckDNS DNS plugin for automatic HTTPS via DNS-01 ACME challenge.

## Why This Exists

>Hi!
>I'll probably rewrite this part a few more times, so make sure you're using the latest version of the repo.
>
>As someone who loves doing things fast, I prefer using ready-to-go containers instead of building them from scratch.
>This time, it's my turn to help others do things faster — without any builds.
>
>Here you'll find an automated setup that explains everything clearly, includes usage samples, and works right out of the box.
>
>To be honest, I built it first and only then realized that similar solutions already exist — but I'll try to make this one better.
>The repo includes all the samples and recommendations you need for a full understanding of how to use it.
>
>And the best part? It's fully automated.
>So even if I stop using it (or, you know, die 😅), the containers should keep updating — assuming GitHub doesn't delete my account!
>
> — **IvanN.co**

## Features

- **Latest Caddy**: Automatically updated when new versions are released
- **DuckDNS Plugin**: For ACME DNS-01 challenges with free DuckDNS subdomains
- **Multi-platform**: AMD64 and ARM64 support
- **Fully Automated**: CI/CD pipeline checks for Caddy AND DuckDNS plugin updates weekly
- **Version Pinning**: Each image tag reflects exact versions of Caddy and DuckDNS plugin used
- **Production Ready**: Optimized for security and performance
- **Free DNS**: Perfect for home labs and personal projects with free DuckDNS subdomains

## Quick Start

### Get a Free DuckDNS Domain

1. Go to [https://www.duckdns.org/](https://www.duckdns.org/)
2. Login with your preferred OAuth provider
3. Create a subdomain (e.g., `myapp.duckdns.org`)
4. Point it to your server's IP address
5. Copy your API token from the top of the page

### Pull the Image

```bash
docker pull ivannco/caddy_xcaddy_duckdns:latest
```

### Run with Docker

```bash
docker run -d \
  -p 80:80 \
  -p 443:443 \
  -p 443:443/udp \
  -e DUCKDNS_API_TOKEN=your_token_here \
  -v $PWD/Caddyfile:/etc/caddy/Caddyfile \
  -v caddy_data:/data \
  ivannco/caddy_xcaddy_duckdns:latest
```

### Run with Docker Compose

```bash
docker-compose up -d
```

See [examples/](examples/) for ready-to-use configurations.

## Available Tags

### Recommended (Full Version Info)
- `caddy-2.10.2-duckdns-0.5.0` - **Pinned versions** (Caddy 2.10.2 + DuckDNS 0.5.0)
- `c2.10.2-dd0.5.0` - **Short format** (same as above)

### Traditional Tags
- `latest` - Always the most recent build
- `2.10.2` - Specific Caddy version (with latest DuckDNS plugin at build time)
- `v2.10.2` - Same with 'v' prefix
- `caddy-v2.10.2` - Alternative format

**Recommendation:** Use the full version tags (e.g., `caddy-2.10.2-duckdns-0.5.0`) for production to ensure reproducible deployments with pinned plugin versions.

## Example Caddyfile

```caddyfile
myapp.duckdns.org {
    tls {
        dns duckdns
    }
    respond "Hello from Caddy with DuckDNS!"
}
```

### Multiple Subdomains

```caddyfile
app.mydomain.duckdns.org {
    tls {
        dns duckdns
    }
    reverse_proxy app:8080
}

api.mydomain.duckdns.org {
    tls {
        dns duckdns
    }
    reverse_proxy api:3000
}
```

**Note:** DuckDNS does not support wildcard certificates. Each subdomain must be registered at duckdns.org and listed explicitly in your Caddyfile.

## DuckDNS Setup

### 1. Register Domain

1. Visit [https://www.duckdns.org/](https://www.duckdns.org/)
2. Login with OAuth (Google, GitHub, Reddit, Twitter, or Persona)
3. Enter your desired subdomain name
4. Enter your server's public IP address
5. Click "add domain"

### 2. Get API Token

Your API token is displayed at the top of the page when logged in. It looks like:
```
a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6
```

### 3. Configure Environment

```bash
DUCKDNS_API_TOKEN=a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6
```

## Examples

The [examples/](examples/) directory contains ready-to-use configurations:

### Basic Examples
- **[Simple](examples/Caddyfile.simple)** - Single domain with HTTPS
- **[Reverse Proxy](examples/Caddyfile.reverse-proxy)** - Proxy to backend services
- **[Multiple Domains](examples/Caddyfile.multiple-domains)** - Multiple DuckDNS subdomains

### Full Stack Examples
- **[WordPress](examples/docker-compose.wordpress.yml)** - WordPress with MySQL
- **[Monitoring](examples/docker-compose.monitoring.yml)** - Prometheus + Grafana
- **[Full Stack](examples/docker-compose.full-stack.yml)** - Frontend + Backend + Database

### Production Ready
- **[Advanced](examples/Caddyfile.advanced)** - Security headers, caching, load balancing

See the [examples README](examples/README.md) for detailed guides.

## Common Use Cases

### Static Website

```caddyfile
mysite.duckdns.org {
    tls {
        dns duckdns
    }
    root * /var/www/html
    file_server
    encode gzip
}
```

### Reverse Proxy

```caddyfile
api.myapp.duckdns.org {
    tls {
        dns duckdns
    }
    reverse_proxy backend:8080 {
        health_uri /health
        health_interval 10s
    }
}
```

### Load Balancing

```caddyfile
app.myservice.duckdns.org {
    tls {
        dns duckdns
    }
    reverse_proxy backend1:8080 backend2:8080 backend3:8080 {
        lb_policy round_robin
        health_uri /health
    }
}
```

## Docker Compose Configuration

Minimal `docker-compose.yml`:

```yaml
version: '3.8'

services:
  caddy:
    image: ivannco/caddy_xcaddy_duckdns:latest
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
    environment:
      - DUCKDNS_API_TOKEN=${DUCKDNS_API_TOKEN}

volumes:
  caddy_data:
  caddy_config:
```

Create `.env` file:
```bash
DUCKDNS_API_TOKEN=your_token_here
```

Run:
```bash
docker-compose up -d
```

## Management

### View Logs

```bash
docker-compose logs -f caddy
```

### Reload Configuration

```bash
docker-compose exec caddy caddy reload --config /etc/caddy/Caddyfile
```

### List Certificates

```bash
docker-compose exec caddy caddy list-certificates
```

### Validate Configuration

```bash
docker-compose exec caddy caddy validate --config /etc/caddy/Caddyfile
```

## Troubleshooting

### Certificate Not Being Issued

1. Verify DuckDNS token is correct (check for extra spaces)
2. Ensure subdomain exists at duckdns.org
3. Verify subdomain points to correct IP address
4. Check logs: `docker-compose logs caddy`
5. Test DNS: `dig yourdomain.duckdns.org`
6. Verify DuckDNS service is operational

### Cannot Connect to Domain

1. Verify DNS resolves correctly: `dig yourdomain.duckdns.org`
2. Check firewall allows ports 80, 443
3. If behind NAT, ensure port forwarding is configured
4. Verify IP address at duckdns.org matches your public IP
5. Wait a few minutes for DNS propagation

### Backend Connection Error

1. Verify backend service is running
2. Check service names match in docker-compose
3. Test backend directly: `curl http://backend:8080`

### DuckDNS Token Authentication Fails

1. Verify entire token was copied (it's quite long)
2. Check for trailing spaces or newlines
3. Get a fresh token by logging back into duckdns.org
4. Ensure no special characters were accidentally added

## Security Best Practices

- ✅ Keep your DuckDNS token secret
- ✅ Use environment variables for credentials
- ✅ Never commit `.env` to version control
- ✅ Enable security headers (see [advanced example](examples/Caddyfile.advanced))
- ✅ Keep images updated
- ✅ Restrict access to sensitive endpoints
- ✅ Monitor logs for suspicious activity
- ✅ Use basic auth for admin panels

## Performance Tips

- ✅ Enable compression (`encode gzip`)
- ✅ Cache static assets
- ✅ Use HTTP/3 (enabled by default on port 443/udp)
- ✅ Configure health checks for backends
- ✅ Use connection pooling

## Version Tracking & Automation

This repository uses a fully automated version tracking system:

### How It Works

1. **Weekly Checks**: GitHub Actions checks for new Caddy and DuckDNS plugin releases every Monday at 2 AM UTC
2. **Version Detection**: Compares current versions (stored in `versions.json`) with latest GitHub releases
3. **Automatic Updates**: If either component has a new version:
   - Updates `versions.json` automatically
   - Triggers a new Docker build
   - Pushes images with updated version tags
4. **Zero Manual Intervention**: Everything happens automatically - no repo updates needed!

### Version File (`versions.json`)

```json
{
  "caddy": "v2.10.2",
  "duckdns": "v0.5.0",
  "last_checked": "2025-11-09T00:00:00Z",
  "changed": []
}
```

This file is the source of truth for which versions are built into each Docker image.

### Tag Format Explained

**Full version tag:** `caddy-2.10.2-duckdns-0.5.0`
- Caddy web server version: `2.10.2`
- DuckDNS DNS plugin version: `0.5.0`
- **Use this for production!** It guarantees exact versions for reproducible builds.

**Short version tag:** `c2.10.2-dd0.5.0`
- Same versions, compact format
- Useful when space is limited

**Traditional tags:** `latest`, `2.10.2`, `v2.10.2`
- Backward compatible with old deployments
- Caddy version is pinned, but DuckDNS plugin version is whatever was latest at build time

### Why This Matters

Using full version tags (`caddy-X.X.X-duckdns-Y.Y.Y`) ensures:
- ✅ **Reproducible builds**: Exact same versions every time
- ✅ **Audit trail**: Know exactly what's in your container
- ✅ **Easy rollback**: Pin to known-good version combinations
- ✅ **No surprises**: Plugin updates won't break your setup unexpectedly

## DuckDNS Specifics

### Free Service

DuckDNS is a free dynamic DNS service supported by donations:
- No payment required
- No ads
- Simple and reliable
- Consider [donating](https://www.duckdns.org/donate.jsp) if you use it regularly

### No Wildcard Support

DuckDNS does not support wildcard DNS records:
- Each subdomain must be registered separately at duckdns.org
- Each subdomain must be listed explicitly in Caddyfile
- Cannot use `*.mydomain.duckdns.org`

### IP Updates

If your public IP changes:
- Update it at duckdns.org
- Or use their update API to automate it
- DuckDNS provides scripts for automatic updates

## Building Your Own

Want to customize? Fork this repository and modify:

### Add More Plugins

Edit `Dockerfile`:
```dockerfile
RUN xcaddy build \
    --with github.com/caddy-dns/duckdns${DUCKDNS_VERSION:+@$DUCKDNS_VERSION} \
    --with github.com/caddy-dns/cloudflare \
    --with your-custom-plugin
```

### Build with Specific Versions

```bash
# Build with specific Caddy and DuckDNS versions
docker build \
  --build-arg CADDY_VERSION=2.10.2 \
  --build-arg DUCKDNS_VERSION=v0.5.0 \
  -t my-caddy:custom .

# Build with latest versions (default)
docker build -t my-caddy:latest .
```

### Configure CI/CD

The repository includes GitHub Actions workflows that:
- Check for Caddy AND DuckDNS plugin updates weekly
- Build multi-platform images (AMD64, ARM64)
- Push to Docker Hub with version-pinned tags
- Fully automated - no manual intervention needed

## Resources

- [Caddy Documentation](https://caddyserver.com/docs/)
- [DuckDNS Plugin](https://github.com/caddy-dns/duckdns)
- [DuckDNS Service](https://www.duckdns.org/)
- [DuckDNS FAQ](https://www.duckdns.org/faqs.jsp)
- [Examples](examples/)

## Support

- GitHub Issues: Report bugs and request features
- Caddy Community: [caddy.community](https://caddy.community/)
- DuckDNS FAQ: [duckdns.org/faqs.jsp](https://www.duckdns.org/faqs.jsp)

## License

This project follows Caddy's Apache 2.0 license.

---

**Built with:**
- [Caddy](https://caddyserver.com/) - Modern web server
- [xcaddy](https://github.com/caddyserver/xcaddy) - Caddy build tool
- [caddy-dns/duckdns](https://github.com/caddy-dns/duckdns) - DuckDNS DNS plugin
- [DuckDNS](https://www.duckdns.org/) - Free dynamic DNS service
