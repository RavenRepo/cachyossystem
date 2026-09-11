#!/usr/bin/env bash
set -euo pipefail

echo "=== UFW ==="
sudo ufw status verbose || true

echo
echo "=== Failed services ==="
systemctl --failed || true

echo
echo "=== Listening sockets ==="
sudo ss -lntup || true

echo
echo "=== Tailscale ==="
tailscale status || true

echo
echo "=== Tailscale netcheck ==="
tailscale netcheck || true

echo
echo "=== Podman ==="
podman ps -a || true
