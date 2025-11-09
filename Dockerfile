# Use CADDY_VERSION to specify a version like "2.8.4" or leave empty for latest
# Use DUCKDNS_VERSION to specify plugin version like "v0.5.0" or leave empty for latest
# Examples:
#   docker build --build-arg CADDY_VERSION=2.10.2 --build-arg DUCKDNS_VERSION=v0.5.0 .
#   docker build .  (uses latest versions)
ARG CADDY_VERSION=
ARG DUCKDNS_VERSION=

FROM caddy:${CADDY_VERSION:+${CADDY_VERSION}-}builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/duckdns${DUCKDNS_VERSION:+@$DUCKDNS_VERSION}

FROM caddy:${CADDY_VERSION:+${CADDY_VERSION}-}alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
