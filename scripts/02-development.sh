#!/usr/bin/env bash
set -euo pipefail

sudo pacman -S --needed \
  nodejs npm \
  pnpm \
  python python-pip python-pipx \
  postgresql \
  podman podman-compose buildah skopeo

pipx ensurepath

echo
echo "NOTE: Initialize PostgreSQL manually after reviewing the target machine:"
echo "  sudo -u postgres initdb -D /var/lib/postgres/data"
echo "  sudo systemctl enable --now postgresql"
echo
echo "Bun and Playwright are installed/configured separately."
