#!/usr/bin/env bash
set -euo pipefail

sudo pacman -S --needed \
  base-devel git curl wget unzip zip jq ripgrep fd fzf tree rsync \
  openssh man-db man-pages fish yay \
  bat eza btop fastfetch duf sqlite3
