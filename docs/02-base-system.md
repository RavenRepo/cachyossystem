# 02 — Base system

```bash
sudo pacman -Syu

sudo pacman -S --needed \
  base-devel git curl wget unzip zip jq ripgrep fd fzf tree rsync \
  openssh man-db man-pages fish yay \
  bat eza btop fastfetch duf sqlite3
```

Notes:

- `bat` replaces `cat`, `eza` replaces `ls` (it also provides `exa` compatibility).
- `btop` replaces `htop`, `duf` summarizes disk usage, `fastfetch` prints system info.
- `sqlite3` covers local single-file databases next to PostgreSQL.
- Use `pacman` for official repository packages and `yay` only where an AUR package is intentionally required.

Verify:

```bash
git --version
fish --version
yay --version
rg --version
bat --version
eza --version
btop --version
fastfetch --version
sqlite3 --version
```
