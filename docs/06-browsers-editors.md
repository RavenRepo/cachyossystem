# 06 — Browsers and editors

## Editors

Zed (package `zed`, binary `zeditor`):

```bash
sudo pacman -S --needed zed
```

VS Code is installed from the repos on this workstation (`code` 1.138.0,
extension `anthropic.claude-code`):
Choose one source if you want it:

```bash
sudo pacman -S --needed code
```

or:

```bash
yay -S visual-studio-code-bin
```

Verify:

```bash
zeditor --version
```

## Browsers

Firefox ships with the CachyOS GNOME installation.

```bash
yay -S --needed google-chrome zen-browser-bin brave-bin
```

The binaries differ from the package names. Verify with the real names:

```bash
google-chrome-stable --version
zen-browser --version
brave --version
firefox --version
```

Keep browser profiles out of Git.
