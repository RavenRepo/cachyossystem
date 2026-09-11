# CachyOS Developer Workstation

> A reproducible, security-conscious developer workstation setup for **CachyOS + GNOME** with modern web development, AI coding agents, containers, databases, remote access, media tools, and everyday productivity software.

![CachyOS](https://img.shields.io/badge/OS-CachyOS-1793D1?logo=archlinux&logoColor=white)
![Desktop](https://img.shields.io/badge/Desktop-GNOME-4A86CF?logo=gnome&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-fish-4EAA25?logo=fish&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## What this repository does

This repository documents and automates a **professional CachyOS developer workstation** from a clean installation to a complete daily-driver environment.

It is designed around:

- CachyOS / Arch Linux
- GNOME + Orchis-Dark / Papirus-Dark / Bibata cursor theme
- GNOME Shell extensions (dash-to-dock, blur-my-shell, Vitals, user-theme, gsconnect, tilingshell, just-perfection)
- Ghostty (+ Ptyxis, Alacritty)
- fish with CachyOS defaults
- Git + GitHub
- Node.js, npm, pnpm, Bun
- Python + pipx
- PostgreSQL + sqlite3
- Podman
- Playwright
- Postman
- Zed (VS Code optional)
- Firefox + Chrome + Zen + Brave
- Claude Code, Codex, Kiro CLI, Pi, OpenCode, Herdr, Hermes
- Oh My Pi / Oh My Claude / Oh My Codex (oh-my-claude-sisyphus via npm)
- Tailscale
- Caddy
- Proton VPN
- Kooha (+ OBS Studio optional) + KTorrent
- Obsidian
- Thunderbird
- Telegram Desktop
- SSHFS
- Modern CLIs: bat, eza, btop, fastfetch, duf, ripgrep, fd, fzf
- UFW and additional system hardening

The goal is **repeatability without blindly copying a personal machine configuration**.

---

## Important

This repository is a **setup guide and automation starting point**, not a universal one-click installer.

Review each phase before executing it on another machine.

Do **not** commit:

- SSH private keys
- API keys
- cloud credentials
- `.env` files containing secrets
- Tailscale auth keys
- GitHub tokens
- AI provider credentials
- browser profiles
- personal databases
- personal shell history

---

# 1. Target architecture

```text
                           Internet
                              │
                 ┌────────────┴────────────┐
                 │                         │
             Proton VPN                Tailscale
                 │                         │
                 │                 Private remote access
                 │                         │
          Normal outbound             SSH / services
                 │                         │
                 └────────────┬────────────┘
                              │
                    ┌─────────▼─────────┐
                    │  CachyOS + GNOME  │
                    └─────────┬─────────┘
                              │
       ┌──────────────────────┼──────────────────────┐
       │                      │                      │
   Development              AI                  Infrastructure
       │                      │                      │
 Node / Bun / pnpm       Claude / Codex        PostgreSQL
 Python / Playwright     Kiro / Pi             Podman
 VS Code / Zed           OpenCode / Herdr      Caddy
       │                      │                      │
       └──────────────────────┼──────────────────────┘
                              │
                       Daily productivity
                              │
          Obsidian / Thunderbird / Telegram
             OBS / Kooha / KTorrent
```

---

# 2. Repository structure

```text
cachyos-dev-workstation/
├── README.md
├── LICENSE
├── .gitignore
├── docs/
│   ├── 00-overview.md
│   ├── 01-installation.md
│   ├── 02-base-system.md
│   ├── 03-gnome.md
│   ├── 04-development.md
│   ├── 05-ai-tooling.md
│   ├── 06-browsers-editors.md
│   ├── 07-databases-containers.md
│   ├── 08-networking.md
│   ├── 09-security.md
│   ├── 10-productivity-media.md
│   ├── 11-verification.md
│   ├── 12-maintenance.md
│   └── 13-terminals.md
├── scripts/
│   ├── 00-system-update.sh
│   ├── 01-base-packages.sh
│   ├── 02-development.sh
│   ├── 03-ai-tools.sh
│   ├── 04-applications.sh
│   ├── 05-security-audit.sh
│   └── verify.sh
└── .github/
    └── workflows/
        └── markdown.yml
```

The scripts are intentionally separated. You can execute the documentation manually or use the scripts as a starting point.

---

# 3. Quick start

## Fresh CachyOS installation

Install CachyOS using the official installer and select:

- GNOME
- UEFI
- your intended filesystem
- your intended bootloader
- your normal user account

Then reboot into the installed system.

CachyOS provides multiple desktop environments through its current installer, including GNOME.

## Clone this repository

```bash
git clone https://github.com/YOUR_USERNAME/cachyos-dev-workstation.git
cd cachyos-dev-workstation
```

## Run the phases

```bash
bash scripts/00-system-update.sh
bash scripts/01-base-packages.sh
bash scripts/02-development.sh
bash scripts/03-ai-tools.sh
bash scripts/04-applications.sh
bash scripts/05-security-audit.sh
bash scripts/verify.sh
```

**Do not run all phases blindly on an existing machine.** Read the corresponding documentation first.

---

# 4. Phase map

| Phase | Purpose |
|---|---|
| 00 | System update and baseline |
| 01 | Git, build tools, shell and common utilities |
| 02 | Node, Bun, pnpm, Python, PostgreSQL, Podman, Playwright |
| 03 | AI coding agents and agent runtimes |
| 04 | Browsers, editors, terminals, themes, VPN, productivity and media |
| Verify | Validate the installation |

---

# 5. Base system

Update first:

```bash
sudo pacman -Syu
```

Install core tooling:

```bash
sudo pacman -S --needed \
  base-devel \
  git \
  curl \
  wget \
  unzip \
  zip \
  jq \
  ripgrep \
  fd \
  fzf \
  tree \
  rsync \
  openssh \
  man-db \
  man-pages \
  bat \
  eza \
  btop \
  fastfetch \
  duf \
  sqlite3
```

Install the AUR helper used by this setup:

```bash
sudo pacman -S --needed yay
```

Verify:

```bash
git --version
yay --version
curl --version
rg --version
bat --version
eza --version
sqlite3 --version
```

---

# 6. Shell

This workstation uses **fish** as the primary interactive shell.

```bash
sudo pacman -S --needed fish
```

Check:

```bash
fish --version
```

Change the login shell if desired:

```bash
chsh -s /usr/bin/fish
```

CachyOS ships tested fish defaults. Source them instead of reinventing:

```fish
source /usr/share/cachyos-fish-config/cachyos-config.fish
```

This workstation disables the greeting (and its fastfetch block):

```fish
function fish_greeting
end
```

Log out and back in.

If you use Zsh instead, do not blindly mix shell initialization from this guide with a Powerlevel10k or CachyOS-generated configuration. Keep shell configuration modular.

---

# 7. GNOME

Install GNOME components as needed:

```bash
sudo pacman -S --needed \
  gnome-shell \
  gnome-control-center \
  gnome-tweaks \
  gnome-keyring \
  gnome-terminal \
  nautilus \
  file-roller \
  xdg-user-dirs
```

For GNOME extensions:

```bash
sudo pacman -S --needed gnome-extensions-app
```

Verify:

```bash
gnome-shell --version
gnome-extensions version
```

## Themes, extensions, terminals

This workstation uses Orchis-Dark (GTK/shell), Papirus-Dark (icons),
Bibata-Modern-Classic (cursor), Adwaita Sans 11, purple accent; see
`docs/03-gnome.md` for the exact packages, `gsettings` commands, and the
reproducible extension list (dash-to-dock, blur-my-shell, Vitals,
user-theme, gsconnect, CoverflowAltTab, tilingshell, just-perfection).

Ghostty is the primary terminal (Ptyxis and Alacritty as alternatives);
see `docs/13-terminals.md`. GNOME Terminal is intentionally not installed.

Recommended philosophy:

- keep the desktop minimal
- install extensions deliberately
- avoid extensions that duplicate core GNOME functionality
- remove abandoned extensions
- review extension compatibility after GNOME upgrades

---

# 8. Git and GitHub

Configure Git identity:

```bash
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR_EMAIL"
```

Recommended defaults:

```bash
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global fetch.prune true
git config --global core.editor "code --wait"
```

Verify:

```bash
git config --global --list
```

## SSH authentication

Generate an Ed25519 key:

```bash
ssh-keygen -t ed25519 -C "YOUR_EMAIL"
```

Start the agent:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Print the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Add it to GitHub.

Test:

```bash
ssh -T git@github.com
```

Never publish `~/.ssh/id_ed25519`.

---

# 9. Node.js

Install Node.js and npm from the system repositories:

```bash
sudo pacman -S --needed nodejs npm
```

Verify:

```bash
node --version
npm --version
```

For projects that require multiple Node versions, use a version manager rather than replacing system packages manually.

---

# 10. pnpm

Install:

```bash
sudo pacman -S --needed pnpm
```

Verify:

```bash
pnpm --version
```

Enable the package manager where supported:

```bash
corepack enable
```

Check:

```bash
corepack --version
```

---

# 11. Bun

Install Bun using its upstream installer:

```bash
curl -fsSL https://bun.sh/install | bash
```

Reload your shell or source the generated environment.

Verify:

```bash
bun --version
```

---

# 12. Python

Install the system Python stack:

```bash
sudo pacman -S --needed \
  python \
  python-pip \
  python-pipx
```

Initialize pipx:

```bash
pipx ensurepath
```

Verify:

```bash
python --version
pip --version
pipx --version
```

Use virtual environments for project dependencies.

---

# 13. PostgreSQL

Install:

```bash
sudo pacman -S --needed postgresql
```

Initialize the database cluster:

```bash
sudo -u postgres initdb -D /var/lib/postgres/data
```

Enable and start:

```bash
sudo systemctl enable --now postgresql
```

Verify:

```bash
systemctl status postgresql --no-pager
```

Open PostgreSQL:

```bash
sudo -u postgres psql
```

Create a development role/database according to the project instead of exposing PostgreSQL to the network by default.

Check listening sockets:

```bash
sudo ss -lntp | grep postgres
```

Prefer local-only PostgreSQL for development.

---

# 14. Podman

Install:

```bash
sudo pacman -S --needed \
  podman \
  podman-compose \
  buildah \
  skopeo
```

Verify:

```bash
podman --version
podman info
```

Rootless containers are preferred.

Test:

```bash
podman run --rm docker.io/library/hello-world
```

Check:

```bash
podman ps
podman images
```

Do not globally expose container ports through the firewall. Audit each published port first.

---

# 15. Playwright

For Node projects:

```bash
pnpm add -D playwright
```

Install browsers:

```bash
pnpm exec playwright install
```

For a system-wide development environment, keep Playwright browser installation project-specific whenever possible.

Verify:

```bash
pnpm exec playwright --version
```

---

# 16. Editors

## VS Code

Choose **one** installation source.

Repository package:

```bash
sudo pacman -S --needed code
```

Or AUR binary package:

```bash
yay -S visual-studio-code-bin
```

Do not install both unless you intentionally need both variants.

Verify:

```bash
code --version
```

## Zed

```bash
sudo pacman -S --needed zed
```

Verify:

```bash
zeditor --version
```

## API clients

```bash
yay -S --needed postman-bin
```

Verify with the real binary name:

```bash
command -v postman
```

---

# 17. Browsers

Install the browsers you actually use.

```bash
yay -S --needed \
  google-chrome \
  zen-browser-bin \
  brave-bin
```

Verify:

Firefox ships with CachyOS GNOME. Verify with the real binary names:

```bash
google-chrome-stable --version
zen-browser --version
brave --version
firefox --version
```

Keep browser profiles separate from the configuration repository.

---

# 18. AI development tools

AI tools change quickly. Prefer their official installers and verify versions after installation.

## Claude Code

Current upstream installation:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Verify:

```bash
claude --version
```

Authenticate:

```bash
claude
```

Do not use `sudo npm install -g @anthropic-ai/claude-code`.

## Kiro CLI

Current upstream installer:

```bash
curl -fsSL https://cli.kiro.dev/install | bash
```

Verify:

```bash
kiro-cli --version
```

If the command name differs in a future release, follow the current Kiro CLI documentation.

## Codex

Install using the current official OpenAI instructions for your account/platform.

Keep authentication outside this repository.

## OpenCode

Prefer the current upstream installer:

```bash
curl -fsSL https://opencode.ai/install | bash
```

Alternatively, if the Arch package is current on your system:

```bash
sudo pacman -S --needed opencode
```

Verify:

```bash
opencode --version
```

## Herdr

Herdr is an AI-agent runtime, not Laravel Herd.

Install:

```bash
curl -fsSL https://herdr.dev/install.sh | sh
```

Verify:

```bash
herdr --version
```

Install integrations as needed:

```bash
herdr integration install pi
herdr integration install omp
herdr integration install claude
herdr integration install codex
herdr integration install opencode
herdr integration install hermes
```

Only install integrations you actually use.

Observed on this workstation (2026-09): `claude` 2.1.268, `codex` 0.153.4,
`kiro-cli` 2.21.2, `pi` 0.85.1, `herdr` 0.9.0 (all `~/.local/bin` via
upstream installers), `opencode` 1.18.29 (pacman), `omp` 18.1.17
(`~/.bun/bin/omp` via Bun), plus `hermes`/`hermes-acp`/`hermes-agent`.
npm global: `oh-my-claude-sisyphus`. Agent state (`~/.claude/`,
`~/.codex/config.toml`) stays out of Git. Details: `docs/05-ai-tooling.md`.

---

# 19. Agent ecosystem

This setup can include:

```text
Claude Code
Codex
Kiro CLI
Pi
OpenCode
Herdr
Oh My Pi
Oh My Claude
Oh My Codex
Hermes
```

Treat each tool as an independent executable.

Do not put:

- provider tokens
- MCP credentials
- agent secrets
- personal prompts containing secrets
- private project data

into this repository.

---

# 20. MCP servers

Recommended MCP categories:

```text
Codebase MCP
Context7
Sequential Thinking
Exa
Browserbase
```

Install and configure them at the appropriate agent/client layer.

Do not copy credentials into Git.

A safe repository pattern is:

```text
docs/
  ai-tooling.md

examples/
  mcp.example.json

.local/
  # ignored
```

Use placeholders in example configuration.

---

# 21. Tailscale

Install using the official package/instructions appropriate for your system.

```bash
sudo pacman -S --needed tailscale
```

Enable:

```bash
sudo systemctl enable --now tailscaled
```

Authenticate:

```bash
sudo tailscale up
```

Check:

```bash
tailscale status
tailscale ip
tailscale netcheck
```

Tailscale should be the preferred path for private remote access.

Avoid exposing SSH globally to the public internet.

---

# 22. Tailscale SSH

If you intentionally use Tailscale SSH:

```bash
sudo tailscale set --ssh
```

Then verify:

```bash
tailscale debug prefs
tailscale status
```

Tailscale SSH still depends on your tailnet access policy.

Do not assume that knowing a Tailscale IP automatically grants SSH access.

---

# 23. OpenSSH hardening

Install:

```bash
sudo pacman -S --needed openssh
```

Create a drop-in:

```bash
sudo nano /etc/ssh/sshd_config.d/10-hardening.conf
```

Suggested baseline:

```text
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitEmptyPasswords no
PubkeyAuthentication yes
X11Forwarding no
MaxAuthTries 3
LoginGraceTime 20
ClientAliveInterval 300
ClientAliveCountMax 2
```

Before restarting SSH, validate the configuration:

```bash
sudo sshd -t
```

Then:

```bash
sudo systemctl restart sshd
```

If your workflow uses Tailscale SSH exclusively, do not expose TCP/22 globally through UFW.

---

# 24. UFW

Check current status:

```bash
sudo ufw status verbose
```

Set the baseline:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

Enable:

```bash
sudo ufw enable
```

Do **not** blindly run:

```bash
sudo ufw allow 22/tcp
```

For this workstation, SSH should preferably remain private through Tailscale.

Inspect:

```bash
sudo ufw status numbered
```

Remove an accidental global SSH rule:

```bash
sudo ufw delete allow 22/tcp
```

---

# 25. Firewall audit

Before opening any port:

```bash
sudo ss -lntup
```

Also inspect:

```bash
sudo ss -lntp
sudo ss -lnup
```

Categorize every listener:

```text
127.0.0.1 / ::1
    Local-only service.

Tailscale IP
    Private tailnet service.

0.0.0.0 / ::
    Potentially network-accessible service.
```

Never open a port simply because an application says it can use one.

---

# 26. Caddy

Caddy is intended for controlled reverse proxying and local/Tailscale service exposure.

Install:

```bash
sudo pacman -S --needed caddy
```

Enable:

```bash
sudo systemctl enable --now caddy
```

Verify:

```bash
systemctl status caddy --no-pager
caddy version
```

Start with local services.

Example conceptual configuration:

```text
service.example.internal {
    reverse_proxy 127.0.0.1:3000
}
```

Do not publish a development application to the public internet until:

1. authentication exists
2. firewall rules are reviewed
3. Caddy configuration is validated
4. logs are monitored
5. secrets are protected

---

# 27. SSHFS

Install:

```bash
sudo pacman -S --needed sshfs
```

Prefer Tailscale addresses for remote machines.

Example:

```bash
mkdir -p ~/mnt/remote
sshfs user@tailscale-host:/path ~/mnt/remote
```

For permanent mounts, use a systemd user mount rather than an ad-hoc shell command.

Unmount:

```bash
fusermount3 -u ~/mnt/remote
```

---

# 28. Proton VPN

Current Arch installation:

```bash
sudo pacman -S --needed proton-vpn-gtk-app gnome-keyring
```

Proton VPN's Linux documentation also calls out NetworkManager and systemd-resolved requirements for relevant functionality.

Launch:

```bash
protonvpn-app
```

Do not enable a VPN kill switch until you have tested interaction with:

- Tailscale
- UFW
- local development
- DNS
- Podman
- Caddy

A kill switch can intentionally break remote-access and development workflows if routing is not designed first.

---

# 29. Productivity and communication

Install:

```bash
sudo pacman -S --needed \
  obsidian \
  thunderbird \
  telegram-desktop
```

Launch:

```bash
obsidian
thunderbird
telegram-desktop
```

Keep application profiles outside this repository.

---

# 30. Recording and media

## OBS Studio

Install:

```bash
sudo pacman -S --needed obs-studio
```

Verify:

```bash
obs --version
```

Recommended architecture:

```text
Webcam
   │
   └── Rounded webcam overlay
             │
Screen ──────┼──► OBS
             │
Mic ─────────┘
```

For the described workflow:

- use the boAt earbuds microphone as the primary microphone
- avoid relying on desktop audio as the primary recording source
- configure PipeWire routing in OBS
- use mic filters
- keep desktop audio optional

## Kooha

```bash
sudo pacman -S --needed kooha
```

Launch:

```bash
kooha
```

Kooha is useful for quick screen recordings; OBS remains the full production workflow.

---

# 31. KTorrent

Install:

```bash
sudo pacman -S --needed ktorrent
```

Launch:

```bash
ktorrent
```

Do not automatically open a torrent listening port through UFW.

First inspect:

```bash
sudo ss -lntup
```

Then decide whether inbound peer connectivity is actually needed.

---

# 32. Security baseline

## Update regularly

```bash
sudo pacman -Syu
```

## Review failed services

```bash
systemctl --failed
```

## Review enabled services

```bash
systemctl list-unit-files --state=enabled
```

## Review listening sockets

```bash
sudo ss -lntup
```

## Review firewall

```bash
sudo ufw status verbose
```

## Review Tailscale

```bash
tailscale status
tailscale netcheck
```

## Review disk permissions

```bash
ls -ld ~
ls -ld ~/.ssh
```

SSH directory should normally be:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/* 2>/dev/null || true
chmod 644 ~/.ssh/*.pub 2>/dev/null || true
```

---

# 33. No AppArmor policy

This setup does **not** require AppArmor.

Security layers are instead built around:

- timely updates
- least privilege
- rootless containers
- UFW
- Tailscale private networking
- SSH key authentication
- systemd service management
- controlled reverse proxying
- careful port exposure
- secrets outside Git
- GitHub repository security
- application-level authentication

If you later add another mandatory access-control framework, document it as a separate architectural decision.

---

# 34. Secrets management

Never commit:

```text
.env
.env.*
*.pem
*.key
id_rsa
id_ed25519
credentials.json
service-account.json
tokens.json
```

Use:

- environment variables
- `~/.config`
- `~/.local/share`
- GNOME Keyring
- application credential stores
- password managers
- secret managers

Example:

```bash
export OPENAI_API_KEY="..."
```

Do not put the actual value in `.bashrc`, `.config/fish/config.fish`, or Git unless the file is intentionally encrypted and managed as a secret.

---

# 35. Development project conventions

Recommended workspace:

```text
~/Projects/
├── personal/
├── work/
├── experiments/
├── open-source/
└── archived/
```

Example:

```bash
mkdir -p ~/Projects/{personal,work,experiments,open-source,archived}
```

A typical project:

```text
project/
├── .github/
├── docs/
├── src/
├── tests/
├── scripts/
├── public/
├── .env.example
├── .gitignore
├── README.md
├── package.json
└── pnpm-lock.yaml
```

---

# 36. Verification

Run:

```bash
bash scripts/verify.sh
```

Manual verification:

```bash
echo "=== OS ==="
cat /etc/os-release

echo
echo "=== Kernel ==="
uname -r

echo
echo "=== Git ==="
git --version

echo
echo "=== Node ==="
node --version

echo
echo "=== pnpm ==="
pnpm --version

echo
echo "=== Bun ==="
bun --version

echo
echo "=== Python ==="
python --version

echo
echo "=== PostgreSQL ==="
psql --version

echo
echo "=== Podman ==="
podman --version

echo
echo "=== Tailscale ==="
tailscale version

echo
echo "=== Firewall ==="
sudo ufw status verbose

echo
echo "=== Listening sockets ==="
sudo ss -lntup
```

---

# 37. Maintenance

Monthly:

```bash
sudo pacman -Syu
```

Review AUR packages:

```bash
yay
```

Review services:

```bash
systemctl --failed
```

Review network exposure:

```bash
sudo ss -lntup
sudo ufw status numbered
```

Review Tailscale devices:

```bash
tailscale status
```

Review containers:

```bash
podman ps -a
podman images
```

Review PostgreSQL:

```bash
systemctl status postgresql --no-pager
```

Review Caddy:

```bash
systemctl status caddy --no-pager
```

---

# 38. Troubleshooting philosophy

When something breaks, inspect the system before changing configuration.

Use:

```bash
systemctl status SERVICE --no-pager
journalctl -u SERVICE -b --no-pager
ss -lntup
ip addr
ip route
resolvectl status
```

For user services:

```bash
systemctl --user status SERVICE --no-pager
journalctl --user -u SERVICE -b --no-pager
```

For PipeWire:

```bash
wpctl status
```

For Tailscale:

```bash
tailscale status
tailscale netcheck
tailscale debug prefs
```

For firewall:

```bash
sudo ufw status verbose
```

Avoid random fixes from old blog posts.

---

# 39. What should NOT be automated

The following should remain deliberate:

- bootloader replacement
- disk partitioning
- filesystem formatting
- SSH key creation
- GitHub authentication
- Tailscale authentication
- VPN kill-switch activation
- firewall port opening
- public reverse proxy exposure
- database network exposure
- AI credentials
- browser profile migration
- secret manager configuration

---

# 40. Roadmap

- [x] Baseline GNOME configuration (Orchis-Dark / Papirus-Dark / Bibata, `docs/03-gnome.md`)
- [x] Reproducible GNOME extension list (`docs/03-gnome.md`)
- [ ] Add Caddy templates
- [ ] Add rootless Podman Quadlet examples
- [ ] Add systemd user SSHFS examples
- [ ] Add hardened sysctl profile
- [ ] Add security audit script
- [ ] Add workstation backup strategy
- [ ] Add dotfiles repository integration
- [ ] Add optional NVIDIA/Wayland tuning
- [ ] Add developer project bootstrap scripts
- [ ] Add CI for Markdown/link validation

---

# 41. References

Official documentation should take precedence over this repository when software changes.

- CachyOS Wiki: https://wiki.cachyos.org/
- Arch Linux: https://archlinux.org/
- GitHub Docs: https://docs.github.com/
- Claude Code: https://code.claude.com/
- Kiro CLI: https://kiro.dev/cli/
- Tailscale: https://tailscale.com/docs/
- Proton VPN: https://protonvpn.com/support/linux-vpn-arch

---

# 42. License

MIT. See [LICENSE](LICENSE).

---

## Maintainer

Replace this section with your GitHub profile and preferred contact information.

```text
Maintainer: YOUR NAME
GitHub: https://github.com/YOUR_USERNAME
```
