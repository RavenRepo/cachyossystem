# 11 — Verification

```bash
bash scripts/verify.sh
```

Exit status is `0` only when every check passes, so this is usable in a hook or
in CI.

## What it checks, and why it is built this way

`verify.sh` originally probed tools with `bash -lc "some --version"`. That is
unreliable: the child shell **inherits PATH from whatever shell invoked
verify.sh**. A binary reachable only because your current interactive session
added a directory reports `OK`, while a fresh login would fail to find it.

That blind spot had a concrete cost. `scripts/01-base-packages.sh` listed
`tree` and `zip`, and `scripts/02-development.sh` listed `buildah` and
`skopeo`. None of the four were installed — the phase scripts had never been
executed at all — and verify.sh reported no problem.

The current script therefore does three independent things:

1. **Package parity** — `pacman -Qq` for every package the phase scripts
   prescribe. This is PATH-independent and catches "the script says it, the
   system does not have it".
2. **Clean-environment resolution** — probes a scrubbed login of the account's
   real login shell:

   ```bash
   env -i HOME="$HOME" USER="$USER" TERM=xterm "$LOGIN_SHELL" -ic 'command -v tool'
   ```

   This answers the question that actually matters: would this work in a fresh
   session, not merely in this one.
3. **Configuration and consistency assertions** rather than mere presence:
   - `git config core.pager` is actually `delta`, not just that delta exists
   - `~/.config/secrets/env` is mode `600`
   - no inline `export *KEY=` / `*TOKEN=` / `*SECRET=` in shell rc files
   - every UUID in GNOME `enabled-extensions` exists on disk

## Privileged checks

Kept out of the script so it never needs sudo:

```bash
sudo ufw status verbose
sudo ss -lntup
systemctl --failed
```

## Also worth inspecting periodically

```bash
tailscale status
tailscale netcheck
podman ps -a
pacman -Qm            # AUR/foreign packages
pacman -Qdt           # orphans
```
