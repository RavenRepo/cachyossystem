# 03 — GNOME

Target: **GNOME Shell 50.4 on Wayland** (CachyOS, verified 2026-09-11).
The GNOME version matters more than usual here — see
[Version constraints](#version-constraints).

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

## Current appearance

Applied state on this workstation (2026-09-11):

| Layer | Value | Source |
|---|---|---|
| GTK3 theme | `Colloid-Purple-Dark-Catppuccin` | `~/.themes` (built from source) |
| GTK4 / libadwaita | same, via `~/.config/gtk-4.0/gtk.css` | Colloid installer `-l` |
| Icons | `Tela-circle-purple-dark` | `~/.local/share/icons` |
| Cursor | `Bibata-Modern-Ice` (size 24) | `bibata-cursor-theme-bin` (pacman) |
| Shell theme | *none* (stock) | intentional — see below |
| Panel styling | Blur My Shell, `corner-radius 18` | extension |
| UI font | `Adwaita Sans 11` | GNOME 48+ default |
| Mono font | `Adwaita Mono 11` | GNOME 48+ default |
| Colour scheme | `prefer-dark`, accent `purple` | GNOME native |

Nothing in this stack required root. Both vinceliuice installers fall back to
`~/.themes` and `~/.local/share/icons` when not run as root, which is the
preferred install path here — it keeps pacman's `/usr/share/themes` clean and
makes the theme trivially removable.

## What GNOME Tweaks actually controls

Worth stating plainly, because the Tweaks labels mislead and most theming
advice online predates GNOME 47:

| Tweaks row | gsettings key | Actually affects |
|---|---|---|
| Legacy Applications | `org.gnome.desktop.interface gtk-theme` | **GTK3 apps only** |
| Shell | `org.gnome.shell.extensions.user-theme name` | top bar, overview, notifications |
| Icons | `org.gnome.desktop.interface icon-theme` | app and folder icons |
| Cursor | `org.gnome.desktop.interface cursor-theme` | pointer |

**No row in Tweaks themes GTK4/libadwaita apps.** That is the single most
common failure mode: setting a GTK3 theme leaves Files, Settings, Text Editor,
Console and every modern app on stock Adwaita, producing a desktop with two
visual languages. The only thing that themes GTK4 is
`~/.config/gtk-4.0/gtk.css`.

The previous configuration on this machine (`Orchis-Dark` for both GTK3 and
shell, empty `~/.config/gtk-4.0/`) had exactly this split.

## Stage 1 — toolkit consistency

Applied first, and still the recommended fallback if the Catppuccin setup
becomes a maintenance burden. `adw-gtk-theme` is already in `extra` and
provides `adw-gtk3` / `adw-gtk3-dark` in `/usr/share/themes`.

```bash
sudo pacman -S --needed adw-gtk-theme
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.shell.extensions.user-theme name ''
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'purple'
gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
gsettings set org.gnome.desktop.interface font-hinting 'slight'
```

`adw-gtk3` is libadwaita backported to GTK3, so GTK3 and GTK4 match *and* both
honour the native `accent-color`. This survives GNOME major upgrades untouched,
which no custom theme does.

Gradience is **archived** and no longer in the repos; GNOME 47+ native accent
colours replaced it. Do not follow guides that recommend it. `refine`
(`extra/refine`, or `page.tesk.Refine` on Flathub) is the current tool for
GNOME settings not exposed in Settings or Tweaks.

## Stage 2 — Catppuccin Mocha via Colloid

Colloid is vinceliuice's actively maintained theme and its `catppuccin`
ColorScheme uses the Mocha palette for its dark variant. `-t purple` maps to
Mocha's mauve accent.

```bash
git clone --depth 1 https://github.com/vinceliuice/Colloid-gtk-theme
cd Colloid-gtk-theme
./install.sh -c dark -s standard -t purple --tweaks catppuccin -l
```

`-l/--libadwaita` is the flag that matters — it writes `~/.config/gtk-4.0/gtk.css`
(~437 KB) and the `assets/` directory. **The AUR packages
(`colloid-catppuccin-gtk-theme-git` and friends) do not do this**, which is why
the source build is used here despite being less convenient.

Verified against Colloid `fe11342` (2026-08-23).

### The sassc prerequisite

The ColorScheme variants (`nord`, `dracula`, `gruvbox`, `everforest`,
`catppuccin`) compile their SCSS at install time and need `sassc`; stock
Colloid ships precompiled CSS and does not. `install.sh` attempts
`sudo pacman -S sassc` itself and fails silently-ish in a non-interactive
shell, leaving a **partial install**: `assets/` present, `gtk.css` absent.

Correct fix:

```bash
sudo pacman -S sassc libsass
```

If root is unavailable, both packages can be extracted locally — Arch packages
are plain zstd tarballs and `pacman -Sp` prints their URLs without needing
root:

```bash
OPT=~/.local/opt/sassc
mkdir -p "$OPT/pkg" && cd "$OPT/pkg"
for u in $(pacman -Sp sassc libsass); do curl -sSLO "$u"; done
for f in *.pkg.tar.zst; do bsdtar -xf "$f" -C "$OPT"; done

export PATH="$OPT/usr/bin:$PATH"
export LD_LIBRARY_PATH="$OPT/usr/lib:$LD_LIBRARY_PATH"
sassc --version    # libsass: 3.6.6
```

This is what is currently in place. It is a workaround, not a package — those
two env vars must be exported before any rerun of Colloid's installer. Prefer
replacing it with the pacman install and deleting `~/.local/opt/sassc`.

### Icons

```bash
git clone --depth 1 https://github.com/vinceliuice/Tela-circle-icon-theme
cd Tela-circle-icon-theme
./install.sh purple          # ./install.sh -h for variants; -c = circular folders
```

Verified against Tela-circle `ee3cf47` (2026-08-16).

The installer produces three themes and the suffixes are **not** self-evident —
`index.theme` is identical across all three. The difference is panel icon
colour:

| Variant | Panel icon fill | Intended for |
|---|---|---|
| `Tela-circle-purple` | `#dfdfdf` | dark desktop |
| `Tela-circle-purple-dark` | `#dfdfdf` | dark desktop |
| `Tela-circle-purple-light` | `#505050` | light desktop |

So `-dark` means *for a dark desktop*, not *dark-coloured icons*. Confirm
rather than guess:

```bash
grep -oE '#[0-9a-fA-F]{6}' \
  ~/.local/share/icons/Tela-circle-purple-dark/16/panel/user-desktop-symbolic.svg \
  | sort -u
```

### Apply

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Purple-Dark-Catppuccin'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-purple-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

printf '[Settings]\ngtk-application-prefer-dark-theme=1\n' > ~/.config/gtk-4.0/settings.ini
```

The `settings.ini` line matters: Colloid's `gtk.css` is a *fixed* dark theme
(its own help warns ColorScheme variants cannot follow the light/dark switch),
so the dark hint must agree with it or GTK4 apps can disagree with their own
stylesheet.

Icons and cursor apply immediately; GTK apps need a relaunch.

Trade-off accepted: Catppuccin hardcodes its palette, so `accent-color purple`
becomes cosmetic for GTK apps. It still drives the shell.

## Panel styling

The shell theme is deliberately left **empty**. Custom shell themes break on
every GNOME major release, and setting Colloid's shell component would fight
Blur My Shell's `override-background` and undo the rounded corners.

Rounded panel corners come from a Blur My Shell key that is **not exposed in
its preferences UI**:

```bash
export GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas
P=org.gnome.shell.extensions.blur-my-shell.panel

gsettings set $P customize true
gsettings set $P corner-radius 18     # default 0
gsettings set $P sigma 40             # default 30
gsettings set $P brightness 0.72      # default 0.6
gsettings set $P static-blur true
gsettings set $P unblur-in-overview true
```

Applies live, no reload. `override-background true` (the default) is what lets
the blur replace the panel background at all.

All four corners are rounded, but the top two sit flush against the screen edge
and are not visible. A genuinely *floating* panel needs a margin, which only
shell CSS can provide. Two options, neither yet applied:

- `--tweaks float` in Colloid's installer — a supported "floating gnome-shell
  panel style", and the lower-risk choice.
- A hand-built user shell theme. GNOME 50's stylesheets live in
  `/usr/share/gnome-shell/gnome-shell-theme.gresource` as
  `gnome-shell-dark.css` / `gnome-shell-light.css` / `gnome-shell-high-contrast.css`
  (no plain `gnome-shell.css`). The default rule is
  `#panel { background-color: #000000; font-weight: bold; height: 2.2em }`.
  `.panel-corner` no longer exists in GNOME 50 — do not copy older theme
  snippets that target it. Note `gresource` ships in a package that is not
  installed here; the resource can be read via `Gio.Resource.load` from
  `python-gobject` instead.

Any such theme must be regenerated after each GNOME major upgrade.

## Version constraints

Checked against the extensions.gnome.org API on 2026-09-11:

| Extension | Max shell version | Usable on 50.4 |
|---|---|---|
| Blur my Shell | 50 (v72) | yes |
| Rounded Window Corners Reborn | 50 (v25) | yes |
| **Open Bar** | **49** | **no** |

Open Bar is the extension most commonly recommended for panel styling. It does
not load on GNOME 50, which is why panel work here goes through Blur My Shell
and CSS instead. Re-check before assuming this is still true:

```bash
curl -sG https://extensions.gnome.org/extension-info/ \
  --data-urlencode uuid=openbar@neuromorph | python3 -m json.tool | grep -A2 shell_version
```

This is the general rule for this desktop: **verify extension compatibility
against the API before installing, not after the shell breaks.**

## Flatpak theming

Flatpak apps do not see host themes without explicit filesystem access. There
are currently **no flatpak apps installed** on this workstation; these
overrides are pre-seeded so future installs inherit the theme:

```bash
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
flatpak override --user --filesystem=/usr/share/themes:ro
flatpak override --user --filesystem=xdg-data/icons:ro
flatpak override --user --filesystem=~/.themes:ro
```

GTK3 flatpaks additionally need the matching runtime, e.g.
`flatpak install flathub org.gtk.Gtk3theme.adw-gtk3-dark`.

## Extensions

User extensions live in `~/.local/share/gnome-shell/extensions/`. Manage them
with Extension Manager (`extension-manager`), which installs from
extensions.gnome.org. Do not install extensions or themes from arbitrary
gnome-look.org tarballs.

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

Installed but not active: `dash-in-panel@fthx`.

`user-theme` is retained even though no shell theme is set — it is the
mechanism for setting one, and removing it would mean reinstalling to
experiment.

```bash
gnome-extensions list --enabled
```

Keep extensions minimal, install deliberately, and review after every GNOME
upgrade. Remove abandoned extensions rather than working around them.

## Backup and rollback

Always snapshot before theming. Every appearance setting lives in dconf:

```bash
dconf dump /org/gnome/ > ~/gnome-theme-backup/gnome-$(date +%Y%m%d-%H%M%S).dconf
```

Rollback:

```bash
dconf load /org/gnome/ < ~/gnome-theme-backup/<snapshot>.dconf
rm -rf ~/.config/gtk-4.0/gtk.css ~/.config/gtk-4.0/assets   # drop the GTK4 theme
```

Snapshots retained on this machine:

| File | State |
|---|---|
| `gnome-20260911-200458.dconf` | original Orchis-Dark / Papirus-Dark |
| `gnome-pre-catppuccin-20260911-201615.dconf` | stage 1 adw-gtk3-dark |

Uninstall the themes themselves with the installers' own flags
(`./install.sh -r`) or by deleting `~/.themes/Colloid-*` and
`~/.local/share/icons/Tela-circle-*`.

Reverting only the panel rounding:

```bash
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas \
  gsettings set org.gnome.shell.extensions.blur-my-shell.panel corner-radius 0
```

## Verification

`org.gnome.Shell.Screenshot` over D-Bus returns
`AccessDenied: Screenshot is not allowed` under GNOME 50's permission policy,
so visual checks cannot be scripted from a plain shell — take screenshots
interactively.

Settings-level check:

```bash
for k in gtk-theme icon-theme cursor-theme cursor-size color-scheme \
         accent-color font-name monospace-font-name; do
  printf '%-22s %s\n' "$k" "$(gsettings get org.gnome.desktop.interface $k)"
done
gsettings get org.gnome.shell.extensions.user-theme name

test -s ~/.config/gtk-4.0/gtk.css && echo "GTK4 theme present"
test -d ~/.themes/Colloid-Purple-Dark-Catppuccin/gtk-3.0 && echo "GTK3 theme present"
test -d ~/.local/share/icons/Tela-circle-purple-dark && echo "icons present"
```

The real check is visual: open a GTK4 app (Files, Text Editor) beside a GTK3
app (GIMP, gnome-tweaks). If they disagree, `~/.config/gtk-4.0/gtk.css` is
missing or stale.

## Known outstanding

- `refine` is **not installed**. Available as `extra/refine` (needs root) or
  `page.tesk.Refine` on Flathub (user install, no root).
- `morewaita-icon-theme` was planned for the stage 1 look and is moot now that
  Tela-circle is in use.
- Floating panel not applied — see [Panel styling](#panel-styling).
- `sassc` is a local extraction rather than a package.
- `orchis-theme`, `papirus-icon-theme` and `papirus-folders` are still
  installed but unused. Harmless; `orchis-theme` is a reasonable fallback.
