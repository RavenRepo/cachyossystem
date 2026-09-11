# 04 — Development

## Node

```bash
sudo pacman -S --needed nodejs npm
```

## pnpm

```bash
sudo pacman -S --needed pnpm
corepack enable
```

## Bun

```bash
curl -fsSL https://bun.sh/install | bash
```

## Python

```bash
sudo pacman -S --needed python python-pip python-pipx
pipx ensurepath
```

## PostgreSQL

```bash
sudo pacman -S --needed postgresql
sudo -u postgres initdb -D /var/lib/postgres/data
sudo systemctl enable --now postgresql
```

## Podman

```bash
sudo pacman -S --needed podman podman-compose buildah skopeo
```

## Playwright

Inside a project:

```bash
pnpm add -D playwright
pnpm exec playwright install
```
