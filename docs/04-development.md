# 04 — Development

## Node

```bash
sudo pacman -S --needed nodejs npm
```

The repository `nodejs` package tracks the current release (v26.8.2 observed
2026-09-19), which is **not** an LTS version. Do not fight pacman over this — use
`mise` for per-project versions:

```bash
mise use -g node@lts        # default for new shells
mise use node@24            # pinned per project, writes .mise.toml
```

## pnpm

```bash
sudo pacman -S --needed pnpm
```

`corepack` is a separate `extra` package and is not installed here. Standalone
`pnpm` works without it, so there is no `corepack enable` step. Install the
`corepack` package explicitly only if a project actually requires it, and note
that it conflicts with managing pnpm through pacman.

## Bun

```bash
curl -fsSL https://bun.sh/install | bash
```

Bun also provides the `omp` CLI on this workstation (`~/.bun/bin/omp`).

The installer appends a POSIX `export` block to `~/.zshrc` / `~/.bashrc`. It
does nothing for fish, which is one of the reasons this workstation uses zsh —
see `docs/14-shell.md`.

## Python

```bash
sudo pacman -S --needed python python-pip python-pipx
pipx ensurepath
```

Division of responsibility:

- `pipx` — globally installed Python **applications** (`pgcli`, linters, etc.)
- `uv` — per-project dependencies and virtual environments, replacing direct
  `pip` use inside projects

```bash
uv venv
uv pip install -r requirements.txt
```

`uv` is installed by `scripts/06-cli-tooling.sh`.

## PostgreSQL

```bash
sudo pacman -S --needed postgresql
sudo -u postgres initdb -D /var/lib/postgres/data
sudo systemctl enable --now postgresql
```

Observed 2026-09-19: `psql` 18.6, service `enabled` + `active`.

## Podman

```bash
sudo pacman -S --needed podman podman-compose buildah skopeo
```

## Playwright

Inside a project:

```bash
pnpm add -D playwright
pnpm exec playwright install
```

## API clients

```bash
yay -S --needed postman-bin
```

Verify:

```bash
command -v postman
```
