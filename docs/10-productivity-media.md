# 10 — Productivity and media

## Proton VPN

```bash
sudo pacman -S --needed proton-vpn-gtk-app gnome-keyring
```

Launch:

```bash
protonvpn-app
```

Do not enable a kill switch until Tailscale and firewall routing are tested.

## Obsidian / Thunderbird / Telegram

```bash
sudo pacman -S --needed obsidian thunderbird telegram-desktop
```

Observed 2026-09-19: `obsidian`, `thunderbird` present; `telegram-desktop`
7.2.8 installed but `command -v telegram-desktop` misses — list with
`pacman -Ql telegram-desktop` to confirm the binary name.

## OBS / Kooha / KTorrent

```bash
sudo pacman -S --needed obs-studio kooha ktorrent
```

Observed 2026-09-19: `kooha`, `ktorrent` present; `obs-studio` not installed.

OBS should be the primary production recorder; Kooha is useful for quick captures.
