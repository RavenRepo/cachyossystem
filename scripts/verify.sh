#!/usr/bin/env bash
set -u

check() {
  local name="$1"
  local cmd="$2"

  printf '%-20s' "$name"
  if bash -lc "$cmd" >/dev/null 2>&1; then
    echo "OK"
  else
    echo "MISSING / CHECK"
  fi
}

check "Git" "git --version"
check "rg" "rg --version"
check "bat" "bat --version"
check "eza" "eza --version"
check "btop" "btop --version"
check "fastfetch" "fastfetch --version"
check "SQLite" "sqlite3 --version"
check "Node" "node --version"
check "npm" "npm --version"
check "pnpm" "pnpm --version"
check "Bun" "bun --version"
check "Python" "python --version"
check "pipx" "pipx --version"
check "PostgreSQL" "psql --version"
check "Podman" "podman --version"
check "Tailscale" "tailscale version"
check "Caddy" "caddy version"
check "SSHFS" "sshfs --version"
check "Ghostty" "ghostty --version"
check "Ptyxis" "ptyxis --version"
check "Alacritty" "alacritty --version"
check "Firefox" "firefox --version"
check "Chrome" "google-chrome-stable --version"
check "Zen" "zen-browser --version"
check "Brave" "brave --version"
check "Zed" "zeditor --version"
check "VSCode" "code --version"
check "Postman" "command -v postman"
check "OBS" "obs --version"
check "Kooha" "command -v kooha"
check "KTorrent" "command -v ktorrent"
check "Obsidian" "command -v obsidian"
check "Thunderbird" "command -v thunderbird"
check "Telegram" "command -v Telegram"
check "Claude" "claude --version"
check "Codex" "codex --version"
check "Pi" "pi --version"
check "omp" "omp --version"
check "Kiro" "kiro-cli --version"
check "OpenCode" "opencode --version"
check "Herdr" "herdr --version"

echo
echo "=== Firewall ==="
sudo ufw status verbose || true

echo
echo "=== Listening sockets ==="
sudo ss -lntup || true
