# Contributing

Thanks for helping improve this workstation guide. Fixes to docs and scripts,
corrections for newer CachyOS/GNOME releases, and well-reasoned additions are
all welcome.

By participating you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).
For security problems, do not open an issue: see [SECURITY.md](SECURITY.md).

## How the repo is organised

| Path | Purpose |
|---|---|
| `README.md` | Entry point and overview |
| `docs/00-*.md` to `docs/15-*.md` | One document per setup phase |
| `scripts/NN-*.sh` | Automation for a phase, run in numeric order |
| `scripts/verify.sh` | Read-only verification of the whole workstation |

## Ground rules

- **Review before running.** This is a guide, not a one-click installer. Keep
  each phase readable and independently runnable.
- **Never commit secrets**, tokens, keys, `.env` files with values, VPN or mesh
  auth keys, or browser profiles.
- **Do not publish host-specific details** such as IP addresses, hostnames,
  open ports, firewall rule sets, or key material. Describe the approach, not
  the specifics of one machine.
- **Prefer official repositories over the AUR.** Use upstream installers only
  for fast-moving tools (for example AI CLIs), and say so in the doc.
- **Verify before you claim.** Version numbers and "installed" statements
  should come from a real system, with the observation date.
- Keep changes small and focused: one concern per pull request.

## Making a change

1. Fork the repository and create a branch from `main`
   (`docs/<topic>`, `fix/<topic>` or `feat/<topic>`).
2. Edit the relevant doc, and the matching script in `scripts/` if the change
   affects what gets installed. Keep the two in sync.
3. For shell scripts, run `bash -n script.sh` and, if available,
   `shellcheck script.sh`. Use `set -euo pipefail` for new scripts and quote
   variables.
4. Run `scripts/verify.sh` and confirm it passes on your system. It is
   read-only and exits non-zero if anything prescribed is missing.
5. Update the README or related docs if behaviour or recommendations changed.
6. Open a pull request using the template and describe what you tested.

## Commit messages

Use a short imperative summary with an optional prefix, for example:

```text
docs: record obs-studio as installed
fix(scripts): quote package list in 02-development.sh
feat(gnome): add theming phase
```

## Reporting bugs and requesting features

Use the issue templates. For a bug, include your CachyOS and GNOME versions
(`fastfetch` or `gnome-shell --version`), the phase or script involved, and the
exact output. Remove any personal or host-specific details before pasting.

## License

Contributions are licensed under the [MIT License](LICENSE).
