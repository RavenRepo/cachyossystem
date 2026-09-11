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

Tooling for this is installed by `scripts/06-cli-tooling.sh`:

```bash
sudo nmap -sT -p- 127.0.0.1        # what is actually reachable locally
mtr <host>                          # path and loss to a remote host
```

## Secrets

### The failure mode this section exists for

On 2026-09-11 this workstation was found with a live API key assigned inline in
`~/.bashrc`:

```bash
export SOME_API_KEY=<plaintext value>
```

`~/.bashrc` is mode `644`, so the credential was readable by any local process
running as any user. The README already said "do not put the actual value in
`.bashrc`" — the rule existed and was still violated, because forbidding a
practice without providing a mechanism does not work. So here is the mechanism.

### Layer 1 — machine-local secrets

For values that only ever need to exist on this machine:

```bash
mkdir -p ~/.config/secrets
chmod 700 ~/.config/secrets
touch ~/.config/secrets/env
chmod 600 ~/.config/secrets/env
```

Put assignments in `~/.config/secrets/env`:

```bash
export SOME_API_KEY="..."
```

Source it from the end of `~/.zshrc` and `~/.bashrc`:

```bash
[[ -r "$HOME/.config/secrets/env" ]] && source "$HOME/.config/secrets/env"
```

The rc files stay committable; the secret file never enters Git.

`scripts/verify.sh` enforces both halves: it fails if
`~/.config/secrets/env` is not mode `600`, and it fails if it finds any inline
`export *KEY=`, `*TOKEN=`, or `*SECRET=` in a shell rc file.

### Layer 2 — secrets that must be shared or versioned

`age` and `sops` let encrypted secrets live in Git safely.

Generate a key once and protect it:

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

Record the public key in the repository (`.sops.yaml`), never the private one:

```yaml
creation_rules:
  - path_regex: \.enc\.(yaml|json|env)$
    age: age1... # public key only
```

Encrypt and edit:

```bash
sops -e secrets.yaml > secrets.enc.yaml
sops secrets.enc.yaml      # decrypts to $EDITOR, re-encrypts on save
```

Only `*.enc.*` files are committed. Back up `~/.config/sops/age/keys.txt`
outside the repository — losing it means losing every encrypted secret.

### Rotation

Treat any credential that has ever been in a shell rc file, a shell history
file, or a Git object as compromised and rotate it. Removing the line does not
un-leak it: it stays in `~/.bash_history`, in shell session logs, and in Git
history if it was ever committed.

## No AppArmor

This baseline intentionally does not install or configure AppArmor.
