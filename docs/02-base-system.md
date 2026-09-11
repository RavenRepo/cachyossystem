# 02 — Base system

```bash
sudo pacman -Syu

sudo pacman -S --needed \
  base-devel git curl wget unzip zip jq ripgrep fd fzf tree rsync \
  openssh man-db man-pages fish yay
```

Verify:

```bash
git --version
fish --version
yay --version
```

Use `pacman` for official repository packages and `yay` only where an AUR package is intentionally required.
