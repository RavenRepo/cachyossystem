# 13 — Terminals

Ghostty is the primary terminal. Ptyxis and Alacritty are installed as
alternatives. GNOME Terminal is intentionally not installed.

```bash
sudo pacman -S --needed ghostty ptyxis alacritty
```

Verify:

```bash
ghostty --version
ptyxis --version
alacritty --version
```

## Ghostty configuration

`~/.config/ghostty/config.ghostty` on this workstation (2026-09):

- font: `JetBrainsMono Nerd Font Mono`, size 13
- background `#181825`, foreground `#cdd6f4`, opacity 0.94
- padding 12×10, GTK tabs on top

Key lines:

```text
font-family = JetBrainsMono Nerd Font Mono
font-size = 13
background = #181825
foreground = #cdd6f4
background-opacity = 0.94
window-padding-x = 12
window-padding-y = 10
```

Copy only the lines you understand. Keep terminal configuration free of secrets.

## Nerd Fonts

This workstation carries JetBrainsMono Nerd Font under
`~/.local/share/fonts/` (manual install). The reproducible alternative:

```bash
sudo pacman -S --needed ttf-jetbrains-mono-nerd
```

After manual installs refresh and verify:

```bash
fc-cache -f
fc-list | grep -i "JetBrainsMono Nerd Font"
```

## Fish integration

CachyOS ships tested fish defaults. Source them instead of reinventing:

```fish
source /usr/share/cachyos-fish-config/cachyos-config.fish
```

This workstation disables the greeting (and its fastfetch block):

```fish
function fish_greeting
end
```

The Bun installer appends:

```fish
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
```

Never export API keys or tokens in `config.fish`.
