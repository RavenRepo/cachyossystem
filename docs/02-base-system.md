# 02 — Base system

```bash
sudo pacman -Syu

sudo pacman -S --needed \
  base-devel git curl wget unzip zip jq ripgrep fd fzf tree rsync \
  openssh man-db man-pages yay \
  bat eza btop fastfetch duf sqlite3
```

Shell stack (see `docs/14-shell.md` before switching login shells):

```bash
sudo pacman -S --needed \
  zsh oh-my-zsh-git cachyos-zsh-config zsh-theme-powerlevel10k \
  zsh-autosuggestions zsh-completions zsh-syntax-highlighting \
  zsh-history-substring-search

# fallback shell, shipped by CachyOS
sudo pacman -S --needed fish cachyos-fish-config
```

Additional CLI tooling lives in `scripts/06-cli-tooling.sh` — see
`docs/15-cli-tooling.md`.

Notes:

- `bat` replaces `cat`, `eza` replaces `ls` (it also provides `exa` compatibility).
- `btop` replaces `htop`, `duf` summarizes disk usage, `fastfetch` prints system info.
- `sqlite3` covers local single-file databases next to PostgreSQL.
- Use `pacman` for official repository packages and `yay` only where an AUR package is intentionally required.
- The whole zsh/oh-my-zsh stack is in official CachyOS/`extra` repositories. It
  does **not** require the AUR, and oh-my-zsh must not be cloned into `$HOME`
  on top of the packaged copy at `/usr/share/oh-my-zsh`.
- `7zip` is the current package name; `p7zip` no longer exists in the official
  repositories.

Verify:

```bash
bash scripts/verify.sh
```

`verify.sh` performs two independent checks: a `pacman -Qq` parity check that
every prescribed package is genuinely installed, and a resolution check inside
a scrubbed login of your real login shell. Do not substitute ad-hoc
`some-tool --version` calls from an interactive shell — those inherit your
current PATH and will report success for tools a fresh login cannot find.
