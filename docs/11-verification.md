# 11 — Verification

Run:

```bash
bash scripts/verify.sh
```

Also inspect:

```bash
systemctl --failed
sudo ufw status verbose
sudo ss -lntup
tailscale status
tailscale netcheck
podman ps -a
```
