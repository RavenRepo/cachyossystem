# 03 — GNOME

## Base desktop

Install the core desktop tools:

```bash
sudo pacman -S --needed \
  gnome-shell \
  gnome-control-center \
  gnome-tweaks \
  gnome-keyring \
  nautilus \
  file-roller \
  xdg-user-dirs \
  gnome-extensions-app
```

## Themes and fonts

Theme packages used on this workstation (2026-09):

```bash
sudo pacman -S --needed \
  orchis-theme \
  papirus-icon-theme \
  papirus-folders \
  bibata-cursor-theme-bin \
  extension-manager
```

Apply them (GNOME 50 on Wayland):

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans 11'
gsettings set org.gnome.desktop.interface accent-color 'purple'
gsettings set org.gnome.shell.extensions.user-theme name 'Orchis-Dark'
```

Verify:

```bash
gsettings get org.gnome.desktop.interface gtk-theme
gsettings get org.gnome.desktop.interface icon-theme
gsettings get org.gnome.desktop.interface cursor-theme
gsettings get org.gnome.shell.extensions.user-theme name
```

WM preferences on this workstation: `appmenu:minimize,maximize,close` buttons,
center-new-windows on.

## Extensions

User extensions live in `~/.local/share/gnome-shell/extensions/`.
Manage them with Extension Manager (`extension-manager`).

Enabled on this workstation:

```text
dash-to-dock@micxgx.gmail.com
blur-my-shell@aunetx
Vitals@CoreCoding.com
user-theme@gnome-shell-extensions.gcampax.github.com
gsconnect@andyholmes.github.io
CoverflowAltTab@palatis.blogspot.com
tilingshell@ferrarodomenico.com
just-perfection-desktop@just-perfection
```

`user-theme` is required for the Orchis shell theme.
Installed but not active here: `clipboard-indicator@tudmotu.com`,
`dash-in-panel@fthx`.

Verify:

```bash
gnome-extensions list --enabled
```

Keep extensions minimal and review them after every GNOME upgrade.
Remove abandoned extensions instead of working around them.
