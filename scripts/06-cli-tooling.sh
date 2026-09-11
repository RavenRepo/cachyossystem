#!/usr/bin/env bash
#
# 06 — CLI tooling
#
# Advanced-workflow tooling that the base phases do not cover. Every package
# name below was verified against the live repositories on 2026-09-11; the
# comments record the traps found while verifying, because several obvious
# guesses are wrong.
#
# Run after 00-system-update.sh. Safe to re-run (--needed).

set -euo pipefail

sudo pacman -S --needed \
  tree zip 7zip \
  neovim tmux mosh mtr nmap \
  git-delta lazygit \
  mise uv \
  zoxide go-yq \
  age sops \
  buildah skopeo

# ---------------------------------------------------------------------------
# Package-name notes (verified with `pacman -Si`)
#
#   7zip        The current package is `7zip` (26.03). `p7zip` no longer
#               exists in the official repositories. Binary is `7z`.
#
#   git-delta   The package is `git-delta`; `delta` is not a package name.
#               The binary it installs *is* called `delta`.
#
#   go-yq       Deliberate. There are two different tools called yq:
#                 extra/yq  4.1.2  — kislyuk, a Python wrapper around jq
#                 go-yq     4.53.3 — mikefarah, the Go YAML processor
#               They declare a mutual conflict, so only one can be installed.
#               This setup wants the Go implementation for editing compose
#               files and manifests in place. It provides the `yq` binary.
#
#   mise        Replaces the need for nvm/fnm/pyenv. The system `nodejs`
#               package tracks current (v26), which is not an LTS release;
#               mise supplies per-project versions without fighting pacman.
#
#   uv          Project-level Python dependency and venv management. pipx is
#               retained for globally installed Python CLIs; the two do not
#               overlap.
#
#   age, sops   Encrypted-secret workflow, so that secrets can live in Git
#               safely instead of only being forbidden. See docs/09-security.md.
#
#   buildah,
#   skopeo      Already prescribed by 02-development.sh; included here too
#               because --needed makes that harmless and this script is the
#               one that gets re-run.
# ---------------------------------------------------------------------------

# Configure delta as git's pager. Doing this in the same script that installs
# it avoids leaving git pointing at a non-existent pager.
if command -v delta >/dev/null; then
  git config --global core.pager delta
  git config --global interactive.diffFilter 'delta --color-only'
  git config --global delta.navigate true
  git config --global merge.conflictstyle zdiff3
fi

echo
echo "Installed. Verify with: bash scripts/verify.sh"
echo
echo "Not installed by this script — each needs a decision, not just a package:"
echo "  restic     backups are useless without a destination and a timer"
echo "  stow       requires choosing a dotfiles repository layout first"
echo "  atuin      commits you to a shell-history sync model"
echo "  git-lfs    install when a repository actually needs it"
echo "  distrobox  the right way to get Go/Rust without polluting the host"
echo "  pgcli      prefer 'pipx install pgcli' to keep Python deps isolated"
echo "  just, direnv, lazydocker, a password-manager CLI"
