# 08 — Networking

## Tailscale

```bash
sudo pacman -S --needed tailscale
sudo systemctl enable --now tailscaled
sudo tailscale up
```

Verify:

```bash
tailscale status
tailscale ip
tailscale netcheck
```

Observed 2026-09-19: `tailscale` 1.102.4, 4-node tailnet (this host + goku
reachable, 2 offline).

## Tailscale SSH

If intentionally used:

```bash
sudo tailscale set --ssh
```

## Caddy

Install, but do **not** enable the service in the same step:

```bash
sudo pacman -S --needed caddy
caddy version
```

The packaged unit ships a default `/etc/caddy/Caddyfile`. Enabling the service
before reading it means starting a listener whose configuration you have not
seen. Inspect first, then decide:

```bash
cat /etc/caddy/Caddyfile          # what would it actually serve?
caddy validate --config /etc/caddy/Caddyfile
```

Write your own configuration, keep it bound to loopback or a Tailscale
address, and only then:

```bash
sudo systemctl enable --now caddy
sudo ss -lntp | grep caddy        # confirm the bind address, not just "it works"
```

Observed 2026-09-19: `caddy` v2.11.4 installed, service `disabled` +
`inactive` (on-demand only).

A reverse proxy on `0.0.0.0:80` with no authentication in front of a
development application is the single easiest way to expose this workstation.
`README.md` §26 lists the preconditions; treat them as blocking, not advisory.

## SSHFS

```bash
sudo pacman -S --needed sshfs
mkdir -p ~/mnt/remote
```

Prefer Tailscale for private remote access.
