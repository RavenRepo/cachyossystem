# 05 — AI tooling

AI installers change frequently. Prefer official upstream installation instructions.

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

## Security

Never commit agent credentials, MCP tokens, provider keys, or personal prompt/configuration data containing secrets.
