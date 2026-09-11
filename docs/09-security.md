# 09 — Security

## Firewall baseline

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw status verbose
```

Do not globally allow SSH unless that is an intentional architecture decision.

## SSH hardening

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

Validate before restarting:

```bash
sudo sshd -t
```

## Audit listeners

```bash
sudo ss -lntup
```

Classify each listener as local-only, Tailscale-only, LAN-accessible, or public.

## No AppArmor

This baseline intentionally does not install or configure AppArmor.
