#!/usr/bin/env bash
set -euo pipefail

sudo pacman -S --needed \
  gnome-keyring \
  ghostty ptyxis alacritty \
  adw-gtk-theme bibata-cursor-theme-bin \
  sassc libsass \
  extension-manager \
  ttf-jetbrains-mono-nerd \
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
echo "  yay -S postman-bin"
echo
echo "Appearance is a separate, root-free phase:"
echo "  bash scripts/07-gnome-theming.sh"
echo "  adw-gtk-theme installed above is the upgrade-proof fallback theme."
