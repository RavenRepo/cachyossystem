# Security Policy

This repository documents and scripts a CachyOS + GNOME developer workstation.
It contains documentation and shell scripts, not a hosted service, but the
scripts install software and change system configuration, so security matters.

## Supported versions

Only the latest commit on `main` is maintained. Docs are audited against a live
system periodically (see the "last audit" date in the README); older revisions
do not receive fixes.

## Reporting a vulnerability

**Do not open a public issue for security problems.**

Report privately through GitHub:
[Report a vulnerability](https://github.com/RavenRepo/cachyossystem/security/advisories/new).

Please include:

- The affected file(s) and the commit or date you looked at
- What an attacker could do, and under what conditions
- Steps to reproduce, or a minimal proof of concept
- A suggested fix, if you have one

You can expect an acknowledgement within 7 days and a fix or an explanation
within 30 days. Credit is given in the fix commit unless you ask otherwise.

## In scope

- Scripts in `scripts/` that could run attacker-controlled code, fetch
  software over an insecure channel, or leave files with unsafe permissions
- Documentation that recommends an insecure configuration (for example a
  firewall, SSH, secrets-handling, or privilege-escalation step that weakens
  the host)
- Accidentally committed secrets, tokens, keys, or personal data

## Out of scope

- Vulnerabilities in third-party software this repo only installs (report those
  to the upstream project)
- Issues that require an attacker to already have root on your machine
- Findings that depend on a configuration this repo does not recommend

## Repository hygiene

- No secrets, tokens, keys, `.env` files with values, VPN/mesh auth keys, or
  browser profiles are committed. If you find one, report it privately as
  above so it can be removed and rotated.
- Documentation describes how the workstation is built, and avoids publishing
  host-specific details (addresses, hostnames, open ports, rule sets, key
  material) that would help someone target a particular machine.
- Scripts are meant to be read before they are run. This is not a one-click
  installer, and nothing here should be piped to a shell without review.
