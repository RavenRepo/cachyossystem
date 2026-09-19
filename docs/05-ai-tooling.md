# 05 — AI tooling

AI installers change frequently. Prefer official upstream installation instructions.

Observed on this workstation (2026-09-19):

| Tool | Version | Install source |
|---|---|---|
| `claude` | 2.1.278 | upstream installer → `~/.local/bin` |
| `codex` | 0.155.0 | upstream installer → `~/.local/bin` |
| `kiro-cli` | 2.21.2 | upstream installer → `~/.local/bin` |
| `pi` | 0.85.1 | upstream installer → `~/.local/bin` |
| `herdr` | 0.9.0 | upstream installer → `~/.local/bin` |
| `hermes`, `hermes-acp`, `hermes-agent` | v0.21.1 | alongside the herdr integrations |
| `opencode` | v2.0.9 | upstream installer → `~/.opencode/bin` (PATH addition required) |
| `omp` | 18.2.5 | bun (`~/.bun/bin/omp`) |
| `antigravity` | IDE v2.13.0 | upstream installer → `~/.local/bin` |
| `agent-memory`, `jev-gate` | — | `~/.local/bin` (Neon memory / Jev risk gate) |

npm global: `oh-my-claude-sisyphus`, `neon`, `llm-checker`. Bun global: `@oh-my-pi/pi-coding-agent`.

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

Upstream installs to `~/.opencode/bin` (requires PATH addition, see
`docs/14-shell.md`). Also available from Arch repos:

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
~/.config/opencode/
~/.opencode/
~/.hermes/
~/.gemini/
~/.kiro/
```

## Skills (2026-09-19)

`~/.claude/skills` carries ~70 entries: the gstack suite, 8 Neon skills
(`neon`, `neon-ai-gateway`, `neon-auth`, `neon-functions`,
`neon-object-storage`, `neon-postgres`, `neon-postgres-branches`,
`neon-postgres-egress-optimizer`, pinned in `~/skills-lock.json`), plus
`orca-cli` / `orchestration`. VS Code carries `anthropic.claude-code`.
Keep skill credentials out of Git.

## Antigravity / Hermes / Jev gate

- Antigravity IDE (`antigravity`, v2.13.0) lives in `~/.local/bin`.
- Hermes Agent (`hermes-agent` v0.21.1) is installed via git to
  `~/.hermes/hermes-agent`.
- `jev-gate` (`~/.local/bin`, canonical `/mnt/kronos/jev`) fronts risky
  actions: exit 0 = proceed, exit 3 = escalate. Never print or store
  `TYPESAFE_API_KEY`; source `/mnt/kronos/jev/.env` silently.

## Security

Never commit agent credentials, MCP tokens, provider keys, or personal prompt/configuration data containing secrets.
