# 12 — Maintenance

Update:

```bash
sudo pacman -Syu
```

Review AUR:

```bash
yay
```

Review failures:

```bash
systemctl --failed
```

Review listeners:

```bash
sudo ss -lntup
```

Review firewall:

```bash
sudo ufw status numbered
```

Review containers:

```bash
podman ps -a
podman images
```

Keep this repository updated when an upstream installation method changes.
