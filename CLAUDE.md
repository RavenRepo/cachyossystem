# CLAUDE.md

This repo documents a reproducible CachyOS + GNOME workstation. README.md is the entry point; `docs/00-15` carry phase detail; `scripts/` carry automation.

## Skill routing

When the user's request matches an available skill, invoke it via the Skill tool. When in doubt, invoke the skill.

Key routing rules:
- Product ideas/brainstorming → invoke /office-hours
- Strategy/scope → invoke /plan-ceo-review
- Architecture → invoke /plan-eng-review
- Design system/plan review → invoke /design-consultation or /plan-design-review
- Full review pipeline → invoke /autoplan
- Bugs/errors → invoke /investigate
- QA/testing site behavior → invoke /qa or /qa-only
- Code review/diff check → invoke /review
- Visual polish → invoke /design-review
- Ship/deploy/PR → invoke /ship or /land-and-deploy
- Save progress → invoke /context-save
- Resume context → invoke /context-restore
- Author a backlog-ready spec/issue → invoke /spec
- Sync docs after shipping → invoke /document-release
- Generate missing docs → invoke /document-generate

## Repo rules

- Review each phase before running on another machine; not a one-click installer.
- Never commit secrets, tokens, keys, `.env` with values, Tailscale keys, browser profiles.
- Prefer official repos over AUR; upstream installers for fast-moving AI tools.
- `scripts/verify.sh` must pass (clean-login PATH probe + `pacman -Qq` parity).
- Jev gate (`jev-gate --request`) before mass/deletes/deploys/schema edits.
