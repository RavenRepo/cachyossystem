# 15 — CLI tooling

Installed by `scripts/06-cli-tooling.sh`. Every package name here was verified
against the live repositories on 2026-09-11.

```bash
sudo pacman -S --needed \
  tree zip 7zip \
  neovim tmux mosh mtr nmap \
  git-delta lazygit \
  mise uv \
  zoxide go-yq \
  age sops \
  buildah skopeo
```

## What each addresses

| Tool | Gap it closes |
|---|---|
| `neovim` | Only `vim`/`nano` existed. Every Tailscale SSH session needs a real terminal editor. |
| `tmux` | No multiplexer of any kind was installed — not tmux, zellij, or screen. Required for detach/reattach over an unreliable link. |
| `mosh` | Roaming SSH that survives suspend and network changes; pairs with Tailscale. |
| `mtr`, `nmap` | `docs/09-security.md` instructs you to audit listeners and classify them; there was no tooling to do it with. |
| `git-delta` | Readable diffs. Wired into git by the install script. |
| `lazygit` | Fast interactive staging. |
| `mise` | The system Node is current, not LTS, with no version switcher installed. |
| `uv` | Project-level Python management; `pipx` keeps global CLIs. |
| `zoxide` | Frecency-based directory jumping. |
| `go-yq` | In-place YAML/manifest editing for compose files and configs. |
| `age`, `sops` | Encrypted secrets that can safely live in Git. See `docs/09-security.md`. |
| `buildah`, `skopeo` | Already prescribed by `02-development.sh`; were never actually installed. |
| `tree`, `zip`, `7zip` | Parity with `01-base-packages.sh`, which listed `tree` and `zip` but was never run. |

## Package-name traps

These are the ones worth writing down, because the obvious guess is wrong.

**`go-yq`, not `yq`.** Two unrelated tools share the name:

| Package | Version | Upstream | What it is |
|---|---|---|---|
| `extra/yq` | 4.1.2 | kislyuk | Python wrapper around `jq` |
| `go-yq` | 4.53.3 | mikefarah | Go YAML/JSON/XML processor |

They declare a mutual `Conflicts`, so only one can be installed. Nearly every
tutorial and CI snippet on the internet means mikefarah's. Both provide a `yq`
binary, which is how people install the wrong one and get confusing errors. The
similar-looking version numbers make this worse, not better.

**`git-delta`, not `delta`.** `delta` is not a package name. The binary
installed by `git-delta` is `delta`.

**`7zip`, not `p7zip`.** `p7zip` has been dropped from the official
repositories.

**`corepack` is not part of `nodejs`.** It is a separate `extra` package and is
absent here. `pnpm` from pacman works standalone.

## Deliberately not installed

Each of these is a decision rather than an install, so `06-cli-tooling.sh`
prints them as a reminder instead of installing them.

| Tool | Why deferred |
|---|---|
| `restic` | A backup tool with no configured destination and no systemd timer is a no-op. Track it as the roadmap item it is. |
| `stow` | Requires first deciding the dotfiles repository layout. |
| `atuin` | Commits you to a shell-history sync model. It is the right answer if you want history shared across zsh and fish. |
| `git-lfs` | A one-line install on the day a repository needs it. |
| `distrobox` | The correct way to get Go/Rust toolchains without installing them on the host. |
| `pgcli` | Use `pipx install pgcli` so its Python dependencies stay isolated. |
| `just`, `direnv`, `lazydocker` | Real value, but only once matching usage patterns exist. `~/.zshrc` already has a guarded `direnv` hook. |
| password-manager CLI (`pass` / `bw` / `op`) | Pick the one matching what you already use, then wire `age`/`sops` to it. |
| `kubectl`, `k9s`, `helm` | The container stack is podman-only, correctly so. Add if Kubernetes work actually arrives. |
| `ollama` | Only for local-model work; the cloud agent CLIs already cover this workstation. |
| `starship` | Powerlevel10k already owns the prompt. Installing both is a conflict, not an upgrade. |
| VS Code | Zed has supported SSH remote development since 2024, so the only real gap is devcontainers. Install `visual-studio-code-bin` from the AUR the day that gap bites. |

## Verification

```bash
bash scripts/verify.sh
```
