# Caddy with the Cloudflare DNS provider (DNS-01 for Let's Encrypt), built by
# .github/workflows/build.yml and pushed to ghcr.io/2stacks/caddy-cloudflare
# (tags <caddy version> and <caddy version>-cf<plugin version>).
#
# Base images pinned tag@sha256 and the plugin by version. Renovate updates
# all three in one PR; merging rebuilds, pushes and signs the image.
# The workflow reads both versions from the lines below: keep their shape.
FROM caddy:2.11.9-builder@sha256:cda07fe9d82728c7ac44d844306d435e98131423dc7b114f05a8a8ecfff94707 AS builder
RUN xcaddy build --with github.com/caddy-dns/cloudflare@v0.2.4

FROM caddy:2.11.9@sha256:4851e54a46b206517c574821bb5cc67f170d2156041e9fbc4c9193b45e84a75b
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
