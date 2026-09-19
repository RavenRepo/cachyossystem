# 14 — Shell (zsh + oh-my-zsh)

This workstation uses **zsh with oh-my-zsh and Powerlevel10k** as the primary
interactive shell. fish remains installed as a fallback.

## Why zsh rather than fish

fish is a good shell, but this workstation installs a lot of software through
upstream `curl | bash` installers — Bun, Claude Code, Kiro CLI, Herdr, OpenCode.
Those installers append POSIX `export VAR=...` lines to `~/.zshrc`,
`~/.bashrc`, or `~/.profile`, and **fish silently ignores all of them** because
its syntax is not POSIX-compatible. Every such tool then needs its environment
re-created by hand in fish syntax, which is why the Bun block in
`~/.config/fish/config.fish` had to be written manually.

zsh also gets first-class shell hooks from the tooling in
`scripts/06-cli-tooling.sh` (`mise`, `zoxide`, `direnv`, `atuin`), and lets
documentation snippets be pasted without translation.

## How oh-my-zsh is packaged on CachyOS

This differs from the usual upstream install and matters:

| Component | Location | Owner |
|---|---|---|
| oh-my-zsh | `/usr/share/oh-my-zsh` | pacman (`oh-my-zsh-git`) |
| CachyOS zsh defaults | `/usr/share/cachyos-zsh-config/cachyos-config.zsh` | pacman (`cachyos-zsh-config`) |
| Powerlevel10k | `/usr/share/zsh-theme-powerlevel10k/` | pacman (`zsh-theme-powerlevel10k`) |
| Skeleton rc | `/etc/skel/.zshrc` | pacman (`cachyos-zsh-config`) |

Consequences:

- `$ZSH` is `/usr/share/oh-my-zsh`, **not** `~/.oh-my-zsh`.
- Updates come from `pacman -Syu`. Do not run `upgrade_oh_my_zsh`, and do not
  clone oh-my-zsh into `$HOME` on top of the packaged copy.
- Custom plugins and themes belong in `$ZSH_CUSTOM`, not in `/usr/share`,
  which pacman will overwrite.

`cachyos-config.zsh` handles the Powerlevel10k instant prompt (line 4), sets
`plugins=(git fzf extract)` only if `$plugins` is unset (line 26), sources
oh-my-zsh, sources the p10k theme (line 88), and sources `~/.p10k.zsh` if it
exists (line 101). Because it only sets `plugins` when empty, you can override
the plugin list by assigning `plugins=(...)` *before* sourcing it.

It also sources three plugins **directly**, outside the oh-my-zsh `plugins`
array:

```zsh
# lines 91, 92, 95 of cachyos-config.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
```

This matters when reading the config: those three are active even though they
do not appear in `$plugins`, so do not add them to the array as well or they
will load twice. `zsh-completions` needs no `source` line at all — it installs
into `/usr/share/zsh/site-functions`, which `compinit` picks up automatically.

Confirm what is actually loaded rather than assuming:

```bash
env -i HOME="$HOME" USER="$USER" TERM=xterm /usr/bin/zsh -ic '
  echo "ZSH=$ZSH"; echo "plugins=$plugins"
  echo "syntax-highlighting loaded: $(( ${+ZSH_HIGHLIGHT_VERSION} ))"
  echo "autosuggestions loaded:     $(( ${+ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE} ))"'
```

## What belongs in `~/.zshrc` and what does not

Keep `~/.zshrc` minimal. Everything oh-my-zsh-related is supplied by the
package; the only things that belong in your own rc file are machine-specific:
PATH, tool hooks, aliases, and the secrets source. Anything you are tempted to
add that duplicates `cachyos-config.zsh` is a future merge conflict.

## The PATH trap

**This is the one thing that will break a naive shell switch.**

fish receives its extra PATH entries from two places:

```fish
# /usr/share/cachyos-fish-config/cachyos-config.fish, line 25
fish_add_path ~/.local/bin ~/.cargo/bin ~/Applications/depot_tools
```

plus a hand-written Bun block in `~/.config/fish/config.fish`.

The CachyOS **zsh** config has no equivalent. A clean zsh login therefore
produces only:

```text
~/.npm-global/bin  /bin  /usr/bin  /usr/ucb  /usr/local/bin
```

No `~/.local/bin` and no `~/.bun/bin`. Since `claude`, `codex`, `kiro-cli`,
`pi`, `herdr`, and `antigravity` all live in `~/.local/bin`, `bun` and `omp`
live in `~/.bun/bin`, and `opencode` v2.x lives in `~/.opencode/bin`, running
`chsh -s /usr/bin/zsh` without fixing PATH first removes the entire AI
toolchain from the shell.

This is invisible if you test with `zsh -ic ...` from an existing fish session,
because the child process inherits the parent's PATH. Always test with a
scrubbed environment:

```bash
env -i HOME="$HOME" USER="$USER" TERM=xterm /usr/bin/zsh -ic 'print -l $path'
```

### Required `~/.zshrc` block

Place this **above** the `source` of the CachyOS config. Assigning variables
produces no output, so it is safe ahead of the p10k instant prompt.

```zsh
export BUN_INSTALL="$HOME/.bun"

typeset -U path PATH            # keep PATH deduplicated
path=(
  "$HOME/.local/bin"            # claude, codex, kiro-cli, pi, herdr, antigravity, jev-gate
  "$HOME/.bun/bin"              # bun, omp
  "$HOME/.npm-global/bin"       # npm global prefix
  "$HOME/.opencode/bin"         # opencode (upstream installer, v2.x)
  $path
)
export PATH

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# Guarded so the file stays valid before scripts/06-cli-tooling.sh has run.
command -v mise   >/dev/null && eval "$(mise activate zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"
command -v atuin  >/dev/null && eval "$(atuin init zsh)"

[[ -r "$HOME/.config/secrets/env" ]] && source "$HOME/.config/secrets/env"
```

`typeset -U path` matters: without it, repeated PATH prepending across nested
shells produces duplicate entries. The pre-existing environment had
`~/.bun/bin` listed three times.

## Migration procedure

Do not change the login shell first. Verify, then commit.

```bash
# 1. Patch ~/.zshrc with the PATH block above.

# 2. Prove a fresh login works — not an inherited one.
for b in claude codex kiro-cli pi herdr antigravity jev-gate bun omp opencode; do
  env -i HOME="$HOME" USER="$USER" TERM=xterm /usr/bin/zsh -ic "command -v $b"
done

# 3. Live in it before committing.
exec zsh -l
p10k configure          # writes ~/.p10k.zsh

# 4. Full check.
bash scripts/verify.sh

# 5. Only now make it the login shell.
chsh -s /usr/bin/zsh
```

Log out and back in for GNOME session services to pick up the new shell.

Keep `fish` and `~/.config/fish/config.fish` in place. Reverting is
`chsh -s /usr/bin/fish`.

## Shell history

zsh and fish do not share history, and fish's history
(`~/.local/share/fish/fish_history`) is not importable into zsh's format
directly. If cross-shell searchable history matters, `atuin` is the tool for it
— it keeps a shared SQLite history across both shells. It is deliberately left
out of `06-cli-tooling.sh` because enabling it is a decision about a sync
model, not just an install.

## Secrets

Never assign credentials inline in `~/.zshrc` or `~/.bashrc`; those files are
world-readable by default and are exactly what gets committed by accident. See
`docs/09-security.md` for the `~/.config/secrets/env` pattern and the
`age`/`sops` workflow. `scripts/verify.sh` fails if it finds an inline
`export *KEY=`, `*TOKEN=`, or `*SECRET=` in a shell rc file.
