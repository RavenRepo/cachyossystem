# 05 — AI tooling

AI installers change frequently. Prefer official upstream installation instructions.

Observed on this workstation (2026-09):

| Tool | Version | Install source |
|---|---|---|
| `claude` | 2.1.268 | upstream installer → `~/.local/bin` |
| `codex` | 0.153.4 | upstream installer → `~/.local/bin` |
| `kiro-cli` | 2.21.2 | upstream installer → `~/.local/bin` |
| `pi` | 0.85.1 | upstream installer → `~/.local/bin` |
| `herdr` | 0.9.0 | upstream installer → `~/.local/bin` |
| `hermes`, `hermes-acp`, `hermes-agent` | — | alongside the herdr integrations |
| `opencode` | 1.18.29 | pacman (`opencode`) |
| `omp` | 18.1.17 | bun (`~/.bun/bin/omp`) |

npm global: `oh-my-claude-sisyphus`.

## Claude Code

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

## Kiro CLI

```bash
curl -fsSL https://cli.kiro.dev/install | bash
```

## OpenCode

```bash
curl -fsSL https://opencode.ai/install | bash
```

or from the Arch repositories:

```bash
sudo pacman -S --needed opencode
```

## Herdr

```bash
curl -fsSL https://herdr.dev/install.sh | sh
```

Then install only the integrations you use:

```bash
herdr integration install pi
herdr integration install omp
herdr integration install claude
herdr integration install codex
herdr integration install opencode
herdr integration install hermes
```

These six match the agent CLIs installed on this workstation.

## Codex / Pi / omp

Follow their official installers for your account and platform.
On this workstation they resolve to `~/.local/bin` (`omp` to `~/.bun/bin`).
Keep authentication outside this repository.

## Config locations

MCP and agent state live outside Git (names only, never commit contents):

```text
~/.claude/
~/.claude.json
~/.codex/config.toml
```

## Security

Never commit agent credentials, MCP tokens, provider keys, or personal prompt/configuration data containing secrets.
