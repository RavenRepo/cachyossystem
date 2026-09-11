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

## Tailscale SSH

If intentionally used:

```bash
sudo tailscale set --ssh
```

## Caddy

```bash
sudo pacman -S --needed caddy
sudo systemctl enable --now caddy
caddy version
```

## SSHFS

```bash
sudo pacman -S --needed sshfs
mkdir -p ~/mnt/remote
```

Prefer Tailscale for private remote access.
