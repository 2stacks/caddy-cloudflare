# caddy-cloudflare

[Caddy](https://caddyserver.com) with the [caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare)
module, for ACME DNS-01 certificates through Cloudflare. The official Caddy
image ships without DNS provider modules, so this builds one with `xcaddy`.

```
ghcr.io/2stacks/caddy-cloudflare:<caddy version>             e.g. 2.11.9
ghcr.io/2stacks/caddy-cloudflare:<caddy version>-cf<plugin>  e.g. 2.11.9-cf0.2.4 (records the plugin version)
```

Pin by digest (`ghcr.io/2stacks/caddy-cloudflare:2.11.9@sha256:…`). A
plugin-only update rebuilds the same `<caddy version>` tag with a new digest.

## Build

`.github/workflows/build.yml`: pull requests build and smoke-test only
(`caddy version`, `dns.providers.cloudflare` module present). Pushes to
`main` also push both tags and sign the digest with cosign (keyless).
Base images are pinned `tag@sha256`, the plugin by version, and the
workflow's actions by commit SHA; Renovate keeps them current.

amd64 only. Go builds for baseline x86-64, so the binary runs on CPUs
without AVX2.

## Verify the signature

```sh
cosign verify ghcr.io/2stacks/caddy-cloudflare@sha256:<digest> \
  --certificate-identity-regexp '^https://github.com/2stacks/caddy-cloudflare/\.github/workflows/build\.yml@refs/heads/main$' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

## Use

```yaml
services:
  caddy:
    image: ghcr.io/2stacks/caddy-cloudflare:2.11.9@sha256:<digest>
    environment:
      CF_API_TOKEN: ${CF_API_TOKEN:?}   # Zone.DNS edit for the zones in the Caddyfile
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
```

```caddyfile
example.com {
	tls {
		dns cloudflare {env.CF_API_TOKEN}
	}
	reverse_proxy app:8080
}
```
