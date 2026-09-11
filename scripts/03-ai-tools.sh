#!/usr/bin/env bash
set -euo pipefail

echo "Installing upstream AI tooling."
echo "Review each installer before running it on production machines."

curl -fsSL https://claude.ai/install.sh | bash
curl -fsSL https://cli.kiro.dev/install | bash
curl -fsSL https://opencode.ai/install | bash
curl -fsSL https://herdr.dev/install.sh | sh

echo
echo "Codex/Pi/Oh-My-* integrations are intentionally not automated here."
echo "Authenticate and configure them interactively."
