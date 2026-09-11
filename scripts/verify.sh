#!/usr/bin/env bash
#
# verify.sh — honest verification of the workstation.
#
# WHY THIS IS NOT `bash -lc "some --version"`:
#   The previous implementation probed tools with `bash -lc`, which inherits
#   PATH from whatever shell invoked verify.sh. A binary reachable only because
#   your *current* interactive shell added a directory would report OK, while a
#   fresh login would fail to find it. That produced false confidence — this
#   repository's own scripts listed packages (tree, zip, buildah, skopeo) that
#   were never installed, and verify.sh never caught it.
#
#   Instead we do two independent things:
#     1. PARITY  — ask pacman which prescribed packages are actually installed.
#     2. RESOLVE — probe a clean-environment login of the account's real login
#                  shell, so the result reflects a genuine fresh session.
#
# Exit status is non-zero if anything is missing, so this is CI/hook friendly.

set -u

PASS=0
FAIL=0

c_ok()   { printf '\033[32m%s\033[0m' "$1"; }
c_bad()  { printf '\033[31m%s\033[0m' "$1"; }
c_head() { printf '\n\033[1m%s\033[0m\n' "$1"; }

LOGIN_SHELL="$(getent passwd "$USER" | awk -F: '{print $NF}')"
case "$(basename "$LOGIN_SHELL")" in
  fish) PROBE_FLAGS="-c" ;;
  *)    PROBE_FLAGS="-ic" ;;
esac

# Run a command inside a pristine login of the real login shell.
probe() {
  env -i HOME="$HOME" USER="$USER" TERM="${TERM:-xterm}" \
    "$LOGIN_SHELL" $PROBE_FLAGS "$1" 2>/dev/null
}

# resolve <label> <binary> [version-flag]
resolve() {
  local label="$1" bin="$2" flag="${3:---version}" path ver
  printf '  %-18s' "$label"
  path="$(probe "command -v $bin" | tail -1)"
  if [ -z "$path" ]; then
    c_bad "MISSING"; echo "  (not on PATH in a clean $LOGIN_SHELL login)"
    FAIL=$((FAIL + 1)); return
  fi
  ver="$(probe "$bin $flag" | head -1 | tr -d '\r' | cut -c1-40)"
  c_ok "OK"; printf '  %-38s %s\n' "${ver:-(no version output)}" "$path"
  PASS=$((PASS + 1))
}

# pkg <package>...  — pacman-level parity check, independent of PATH
pkg() {
  local p
  for p in "$@"; do
    printf '  %-28s' "$p"
    if pacman -Qq "$p" >/dev/null 2>&1; then
      c_ok "installed"; echo
      PASS=$((PASS + 1))
    else
      c_bad "NOT INSTALLED"; echo
      FAIL=$((FAIL + 1))
    fi
  done
}

echo "=============================================="
echo " CachyOS workstation verification"
echo " login shell: $LOGIN_SHELL"
echo " host: $(uname -srm)"
echo "=============================================="

c_head "Base packages (pacman parity)"
pkg base-devel git curl wget unzip zip tree jq ripgrep fd fzf rsync \
    openssh man-db man-pages yay bat eza btop fastfetch duf sqlite3 7zip

c_head "Shell"
pkg zsh oh-my-zsh-git cachyos-zsh-config zsh-theme-powerlevel10k \
    zsh-autosuggestions zsh-completions zsh-syntax-highlighting

c_head "Terminal editor / multiplexer / remote"
resolve "neovim"     nvim
resolve "tmux"       tmux -V
resolve "mosh"       mosh
resolve "mtr"        mtr
resolve "nmap"       nmap

c_head "Git tooling"
resolve "git"        git
resolve "delta"      delta
resolve "lazygit"    lazygit --version
# delta is only useful if git is actually configured to use it
printf '  %-18s' "git pager=delta"
if [ "$(git config --global --get core.pager)" = "delta" ]; then
  c_ok "OK"; echo
  PASS=$((PASS + 1))
else
  c_bad "NOT CONFIGURED"; echo "  (git config --global core.pager delta)"
  FAIL=$((FAIL + 1))
fi

c_head "Runtimes and version management"
resolve "mise"       mise
resolve "node"       node
resolve "npm"        npm
resolve "pnpm"       pnpm
resolve "bun"        bun
resolve "python"     python
resolve "uv"         uv
resolve "pipx"       pipx

c_head "Shell productivity"
resolve "zoxide"     zoxide
resolve "yq (go-yq)" yq

c_head "Secrets"
resolve "age"        age --version
resolve "sops"       sops --version
printf '  %-18s' "secrets file perms"
if [ -f "$HOME/.config/secrets/env" ]; then
  perm="$(stat -c '%a' "$HOME/.config/secrets/env")"
  if [ "$perm" = "600" ]; then
    c_ok "OK"; echo "  600"
    PASS=$((PASS + 1))
  else
    c_bad "TOO OPEN"; echo "  $perm (expected 600)"
    FAIL=$((FAIL + 1))
  fi
else
  c_bad "ABSENT"; echo "  (~/.config/secrets/env)"
  FAIL=$((FAIL + 1))
fi
# Regression guard: the exposure this repo already had once.
printf '  %-18s' "no inline secrets"
if grep -qEi '^[[:space:]]*export[[:space:]]+[A-Z0-9_]*(KEY|TOKEN|SECRET)[A-Z0-9_]*=' \
     "$HOME/.bashrc" "$HOME/.zshrc" 2>/dev/null; then
  c_bad "FOUND"; echo "  credential assigned inline in a shell rc file"
  FAIL=$((FAIL + 1))
else
  c_ok "OK"; echo
  PASS=$((PASS + 1))
fi

c_head "Databases and containers"
resolve "psql"       psql
resolve "podman"     podman
resolve "buildah"    buildah
resolve "skopeo"     skopeo

c_head "Networking"
resolve "tailscale"  tailscale version
resolve "caddy"      caddy version
resolve "sshfs"      sshfs

c_head "Editors and terminals"
resolve "zed"        zeditor
resolve "ghostty"    ghostty
resolve "alacritty"  alacritty

c_head "AI agent CLIs"
resolve "claude"     claude
resolve "codex"      codex
resolve "kiro-cli"   kiro-cli
resolve "pi"         pi
resolve "herdr"      herdr
resolve "opencode"   opencode
resolve "omp"        omp

c_head "GNOME extension consistency"
if command -v gsettings >/dev/null; then
  for u in $(gsettings get org.gnome.shell enabled-extensions | tr -d "[],'"); do
    printf '  %-56s' "$u"
    if [ -d "$HOME/.local/share/gnome-shell/extensions/$u" ] ||
       [ -d "/usr/share/gnome-shell/extensions/$u" ]; then
      c_ok "present"; echo
      PASS=$((PASS + 1))
    else
      c_bad "ENABLED BUT NOT INSTALLED"; echo
      FAIL=$((FAIL + 1))
    fi
  done
else
  echo "  gsettings unavailable — skipped"
fi

c_head "Summary"
printf '  passed: %d\n  failed: %d\n' "$PASS" "$FAIL"
echo
echo "Privileged checks (run manually, they need sudo):"
echo "  sudo ufw status verbose"
echo "  sudo ss -lntup"
echo "  systemctl --failed"

[ "$FAIL" -eq 0 ]
