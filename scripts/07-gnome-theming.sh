#!/usr/bin/env bash
# 07 — GNOME theming: Catppuccin Mocha (Colloid + Tela-circle + Bibata)
#
# Reproduces docs/03-gnome.md. Runs entirely as your own user: vinceliuice's
# installers fall back to ~/.themes and ~/.local/share/icons when not root.
#
# Prerequisites already provided by 04-applications.sh:
#   bibata-cursor-theme-bin, extension-manager, adw-gtk-theme
#
# Idempotent. Safe to re-run.

set -euo pipefail

SRC="$HOME/src/theming"
BACKUP="$HOME/gnome-theme-backup"
SASSC_OPT="$HOME/.local/opt/sassc"

GTK_THEME='Colloid-Purple-Dark-Catppuccin'
ICON_THEME='Tela-circle-purple-dark'
CURSOR_THEME='Bibata-Modern-Ice'

info() { printf '\n\033[1;35m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$1"; }

# --- 0. sanity ---------------------------------------------------------------
if [[ "${XDG_CURRENT_DESKTOP:-}" != *GNOME* ]]; then
  warn "XDG_CURRENT_DESKTOP is '${XDG_CURRENT_DESKTOP:-unset}', expected GNOME."
fi
info "GNOME $(gnome-shell --version 2>/dev/null || echo 'unknown')"

# --- 1. backup dconf before touching anything --------------------------------
info "Backing up GNOME settings"
mkdir -p "$BACKUP"
snapshot="$BACKUP/gnome-$(date +%Y%m%d-%H%M%S).dconf"
dconf dump /org/gnome/ > "$snapshot"
echo "    $snapshot ($(wc -l < "$snapshot") keys)"

# --- 2. sassc: required by Colloid's ColorScheme variants ---------------------
# Only the nord/dracula/gruvbox/everforest/catppuccin variants compile SCSS at
# install time. Without sassc the installer leaves a partial install (assets/
# but no gtk.css). Prefer the real package; fall back to local extraction.
if ! command -v sassc >/dev/null 2>&1; then
  if [[ -x "$SASSC_OPT/usr/bin/sassc" ]]; then
    info "Using locally extracted sassc"
  else
    info "sassc missing — extracting sassc + libsass locally (no root)"
    warn "Prefer: sudo pacman -S sassc libsass, then rm -rf $SASSC_OPT"
    mkdir -p "$SASSC_OPT/pkg"
    (
      cd "$SASSC_OPT/pkg"
      for url in $(pacman -Sp sassc libsass); do
        [[ -f "$(basename "$url")" ]] || curl -sSLO --max-time 120 "$url"
      done
      for pkg in *.pkg.tar.zst; do bsdtar -xf "$pkg" -C "$SASSC_OPT"; done
    )
  fi
  export PATH="$SASSC_OPT/usr/bin:$PATH"
  export LD_LIBRARY_PATH="$SASSC_OPT/usr/lib:${LD_LIBRARY_PATH:-}"
fi
sassc --version | head -2 | sed 's/^/    /'

# --- 3. GTK theme (GTK3 + GTK4/libadwaita) -----------------------------------
# -l is the only thing that themes GTK4 apps. The AUR packages omit it.
info "Installing Colloid (Catppuccin Mocha, purple/mauve accent)"
mkdir -p "$SRC"
if [[ -d "$SRC/Colloid-gtk-theme/.git" ]]; then
  git -C "$SRC/Colloid-gtk-theme" pull --quiet --ff-only || \
    warn "could not fast-forward Colloid; using existing checkout"
else
  git clone --depth 1 --quiet \
    https://github.com/vinceliuice/Colloid-gtk-theme "$SRC/Colloid-gtk-theme"
fi
(
  cd "$SRC/Colloid-gtk-theme"
  echo "    revision $(git log -1 --format='%h %ad' --date=short)"
  ./install.sh -c dark -s standard -t purple --tweaks catppuccin -l
)

# --- 4. Icons ----------------------------------------------------------------
# Suffixes describe the target desktop, not the icon colour: -dark and the base
# variant use #dfdfdf panel icons (for dark desktops), -light uses #505050.
info "Installing Tela-circle icons (purple)"
if [[ -d "$SRC/Tela-circle-icon-theme/.git" ]]; then
  git -C "$SRC/Tela-circle-icon-theme" pull --quiet --ff-only || \
    warn "could not fast-forward Tela-circle; using existing checkout"
else
  git clone --depth 1 --quiet \
    https://github.com/vinceliuice/Tela-circle-icon-theme "$SRC/Tela-circle-icon-theme"
fi
(
  cd "$SRC/Tela-circle-icon-theme"
  echo "    revision $(git log -1 --format='%h %ad' --date=short)"
  ./install.sh purple
)

# --- 5. Apply ----------------------------------------------------------------
info "Applying appearance settings"
gsettings set org.gnome.desktop.interface gtk-theme          "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme         "$ICON_THEME"
gsettings set org.gnome.desktop.interface cursor-theme       "$CURSOR_THEME"
gsettings set org.gnome.desktop.interface cursor-size        24
gsettings set org.gnome.desktop.interface color-scheme       'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color       'purple'
gsettings set org.gnome.desktop.interface font-antialiasing  'rgba'
gsettings set org.gnome.desktop.interface font-hinting       'slight'

# Colloid's ColorScheme gtk.css is fixed-dark and cannot follow the light/dark
# switch, so the GTK4 dark hint must agree with it.
mkdir -p "$HOME/.config/gtk-4.0"
printf '[Settings]\ngtk-application-prefer-dark-theme=1\n' \
  > "$HOME/.config/gtk-4.0/settings.ini"

# Stock shell theme on purpose: custom shell themes break on GNOME upgrades and
# would fight Blur My Shell's panel background override.
gsettings set org.gnome.shell.extensions.user-theme name ''

# --- 6. Panel: rounded corners via an unexposed Blur My Shell key -------------
BMS_SCHEMAS="$HOME/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas"
if [[ -f "$BMS_SCHEMAS/gschemas.compiled" ]]; then
  info "Rounding the top bar (Blur My Shell)"
  P=org.gnome.shell.extensions.blur-my-shell.panel
  GSETTINGS_SCHEMA_DIR="$BMS_SCHEMAS" bash -c "
    gsettings set $P customize true
    gsettings set $P corner-radius 18
    gsettings set $P sigma 40
    gsettings set $P brightness 0.72
    gsettings set $P static-blur true
    gsettings set $P unblur-in-overview true
  "
else
  warn "Blur My Shell not installed; skipping panel rounding."
  warn "Install via extension-manager, then re-run this script."
fi

# --- 7. Flatpak: let future apps see the user-installed theme -----------------
if command -v flatpak >/dev/null 2>&1; then
  info "Pre-seeding flatpak theme access"
  flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
  flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
  flatpak override --user --filesystem=/usr/share/themes:ro
  flatpak override --user --filesystem=xdg-data/icons:ro
  flatpak override --user --filesystem="$HOME/.themes:ro"
fi

# --- 8. Verify ---------------------------------------------------------------
info "Result"
for k in gtk-theme icon-theme cursor-theme color-scheme accent-color; do
  printf '    %-16s %s\n' "$k" "$(gsettings get org.gnome.desktop.interface "$k")"
done

fail=0
[[ -s "$HOME/.config/gtk-4.0/gtk.css" ]] \
  || { warn "MISSING ~/.config/gtk-4.0/gtk.css — GTK4 apps will stay stock Adwaita"; fail=1; }
[[ -d "$HOME/.themes/$GTK_THEME/gtk-3.0" ]] \
  || { warn "MISSING ~/.themes/$GTK_THEME/gtk-3.0"; fail=1; }
[[ -d "$HOME/.local/share/icons/$ICON_THEME" ]] \
  || { warn "MISSING icon theme $ICON_THEME"; fail=1; }
[[ -d "/usr/share/icons/$CURSOR_THEME" ]] \
  || { warn "MISSING cursor theme $CURSOR_THEME (pacman -S bibata-cursor-theme-bin)"; fail=1; }

if (( fail )); then
  warn "Incomplete. Roll back with:"
  warn "  dconf load /org/gnome/ < $snapshot"
  exit 1
fi

cat <<EOF

Done. Icons and cursor apply immediately; relaunch GTK apps to see the theme.

Check consistency by opening a GTK4 app (Files) beside a GTK3 app (gnome-tweaks).
If they disagree, ~/.config/gtk-4.0/gtk.css is missing or stale.

Roll back:
  dconf load /org/gnome/ < $snapshot
  rm -rf ~/.config/gtk-4.0/gtk.css ~/.config/gtk-4.0/assets
EOF
