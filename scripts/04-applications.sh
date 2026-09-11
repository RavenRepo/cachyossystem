#!/usr/bin/env bash
set -euo pipefail

sudo pacman -S --needed \
  gnome-keyring \
  obsidian \
  thunderbird \
  telegram-desktop \
  obs-studio \
  kooha \
  ktorrent \
  proton-vpn-gtk-app \
  tailscale \
  caddy \
  sshfs

echo
echo "Optional AUR applications:"
echo "  yay -S google-chrome zen-browser-bin brave-bin"
echo "  yay -S visual-studio-code-bin"
