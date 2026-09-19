#!/usr/bin/env bash
set -euo pipefail

echo "Installing upstream AI tooling."
echo "Review each installer before running it on production machines."

curl -fsSL https://claude.ai/install.sh | bash
curl -fsSL https://cli.kiro.dev/install | bash
curl -fsSL https://opencode.ai/install | bash
curl -fsSL https://herdr.dev/install.sh | sh

echo
echo "Codex/Pi/omp follow their official installers (here: ~/.local/bin, omp via Bun)."
echo "opencode upstream lands in ~/.opencode/bin — add it to PATH (docs/14-shell.md)."
echo "antigravity/hermes-agent/jev-gate/agent-memory follow their official installers to ~/.local/bin."
echo "opencode is also available via pacman; authenticate and configure everything interactively."
