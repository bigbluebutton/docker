ARG CADDY_TAG latest
FROM caddy:${CADDY_TAG}-builder AS builder

RUN xcaddy build \
    --with github.com/mholt/caddy-l4

FROM caddy:${CADDY_TAG}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy