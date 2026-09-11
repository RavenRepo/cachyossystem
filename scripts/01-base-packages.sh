#!/usr/bin/env bash
#
# 01 — Base packages and shell
#
# NOTE ON HISTORY: this script was written retroactively to describe a machine
# that had been built by hand, and was never executed. Two packages it listed
# (tree, zip) were therefore never actually installed. Treat the phase scripts
# as reproducible only after `scripts/verify.sh` passes.

set -euo pipefail

# Core utilities
sudo pacman -S --needed \
  base-devel git curl wget unzip zip jq ripgrep fd fzf tree rsync \
  openssh man-db man-pages yay \
  bat eza btop fastfetch duf sqlite3

# Primary interactive shell: zsh with oh-my-zsh.
#
# CachyOS packages oh-my-zsh system-wide at /usr/share/oh-my-zsh rather than
# ~/.oh-my-zsh, and pacman owns updates. Do not clone oh-my-zsh into $HOME on
# top of this; you will end up with two copies and a confusing $ZSH.
#
# cachyos-zsh-config provides /usr/share/cachyos-zsh-config/cachyos-config.zsh,
# which enables the Powerlevel10k instant prompt, sets ZSH=/usr/share/oh-my-zsh,
# sets plugins=(git fzf extract), sources oh-my-zsh, then sources the p10k
# theme. All of these are in official repositories; none need the AUR.
sudo pacman -S --needed \
  zsh oh-my-zsh-git cachyos-zsh-config zsh-theme-powerlevel10k \
  zsh-autosuggestions zsh-completions zsh-syntax-highlighting \
  zsh-history-substring-search

# fish is retained as a fallback shell. CachyOS installs it by default and
# removing it buys nothing.
sudo pacman -S --needed fish cachyos-fish-config

cat <<'EOF'

Base packages installed.

Shell activation is deliberately NOT automated. See docs/14-shell.md, but in
short:

  1. Add the PATH block from docs/14-shell.md to ~/.zshrc FIRST. A bare zsh
     login does not inherit ~/.local/bin or ~/.bun/bin the way fish does, so
     skipping this step makes every upstream-installed CLI disappear.
  2. Run `exec zsh -l`, then `p10k configure`.
  3. Confirm with:  bash scripts/verify.sh
  4. Only then:     chsh -s /usr/bin/zsh

EOF
