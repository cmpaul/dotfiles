# CLAUDE.md

macOS dotfiles repo (Holman-style topics), installed by symlinking files into
`$HOME`. Owner: Chris Paul. Changes here affect the live shell/git/tooling
environment of every machine that installs them — be conservative.

## How installation works

- `script/bootstrap.sh` — full setup: symlinks every `topic/*.symlink` file to
  `~/.<basename>` (e.g. `zsh/zshrc.symlink` → `~/.zshrc`), installs Homebrew +
  Brewfile via `bin/dot`, applies macOS defaults, generates
  `git/gitconfig.local.symlink` (name/email/GPG key) on first run.
- `bin/dot` — periodic refresher: macOS defaults (`osx/set-defaults.sh`, needs
  sudo), brew update/upgrade, then `script/start.sh`, which runs every
  `topic/install.sh`. Successful runs are stamped in
  `~/.cache/dotfiles/dot-lastrun`; `_dot_reminder` in `zshrc.symlink` offers to
  run it (with confirmation) when the stamp is 30+ days old. NB: a bare `dot`
  in a shell resolves to graphviz's dot — use `$DOTFILES/bin/dot`.
- `set-defaults.sh` must stay safe to re-run: no Spotlight reindex
  (`mdutil -E`), and never `killall` Terminal/iTerm — it runs on every `dot`,
  from the terminal that invoked it.
- macOS `softwareupdate` only runs when `DOTFILES_SOFTWAREUPDATE=1` is set.
- Bootstrap is idempotent: it skips existing correct symlinks, prompts on
  conflicts, and offers to keep (Enter) or change the current hostname —
  applied directly via scutil, not via set-defaults.sh.
- **The `.symlink` suffix is the contract.** A new file meant for `$HOME` must
  end in `.symlink` and live one directory deep. After adding one, symlink it
  manually or re-run `script/bootstrap.sh`.

## Layout

- `zsh/` — `zshrc.symlink`, `zprofile.symlink`, `aliases.symlink`,
  `p10k.zsh.symlink` (Powerlevel10k prompt), `secrets.conf`; `install.sh`
  clones oh-my-zsh + powerlevel10k into `~/.oh-my-zsh` when missing, and
  seeds the untracked `~/.zshrc.local`, `~/.localaliases`, `~/.zprofile.local`,
  and `~/.secrets.conf.local` stubs
- `git/` — `gitconfig.symlink` (delta pager, GPG signing, rebase/rerere),
  `gitignore.symlink`, `gitmessage.symlink`; `gitconfig.local.symlink` is
  machine-generated and **gitignored — never commit it**
- `bin/` — on `$PATH`; mostly `git-*` subcommands wired up as git aliases in
  `gitconfig.symlink` via absolute `$DOTFILES/bin/...` paths
- `homebrew/Brewfile` — all brew packages; keep alphabetized within sections
- `mise/mise.toml.symlink` — global runtimes (Python, Node). mise replaced
  nvm/pyenv; don't reintroduce version-manager shims
- `osx/set-defaults.sh` — macOS defaults; `gnupg/install.sh` — GPG agent setup
- `fonts/` — MesloLGS NF (patched font powerlevel10k needs), vendored from
  romkatv/powerlevel10k-media; installed into `~/Library/Fonts`
- `terminal/` — `Clear Dark.terminal` profile for Terminal.app (the stock
  Clear Dark profile with MesloLGS NF 11pt), imported and set as
  default/startup profile by its `install.sh`

## zshrc ordering constraints (do not reorder)

1. p10k instant prompt block stays at the very top. **Nothing may write to
   stdout during zshrc execution** — p10k flags it every session. To print at
   session start, use a one-shot `precmd` hook (see `_secrets_reminder`).
2. Personal aliases (`~/.aliases`, `~/.localaliases`) are sourced **after**
   oh-my-zsh, deliberately: OMZ plugin aliases must not shadow them. The OMZ
   `git` plugin was removed for this reason — don't re-add it.
   `~/.zshrc.local` is sourced **last**, at the very bottom, so machine-local
   config can override everything above it.
3. `compinit` runs only inside oh-my-zsh. Don't add a manual call (slow,
   duplicate). Use `$HOMEBREW_PREFIX` (set by zprofile) instead of spawning
   `brew --prefix`.
4. Warm interactive startup is ~0.22s; verify with
   `/usr/bin/time zsh -i -c exit` after touching zshrc.

## Secrets

- **Never** commit or write secrets to disk, including untracked files.
  Secrets live in 1Password; `zsh/secrets.conf` maps env var names to
  `op://vault/item/field` references (format: `NAME=ref`, no spaces around
  `=`, `#` comments).
- The `load-secrets` zsh function signs in via `op` and exports every mapped
  entry; a padlock reminder prints on new sessions while any mapped var is
  unset. To add a secret: create the 1Password item, add one line to
  `secrets.conf`.
- Machine-specific mappings go in `~/.secrets.conf.local` (untracked, 600),
  which `load-secrets` and `_secrets_reminder` read in addition to
  `secrets.conf`. Same format. Never put secret *values* in
  `~/.zprofile.local` — it's for env/PATH only.

## Conventions and expectations

- Aliases are muscle memory — never rename or repurpose an existing alias
  without explicit approval. Machine-specific aliases belong in
  `~/.localaliases`, packages in `~/.Brewfile.local`, login env in
  `~/.zprofile.local`, secret mappings in `~/.secrets.conf.local`, and any
  other per-machine shell config in `~/.zshrc.local` (all untracked; keep it
  that way). `zsh/install.sh` seeds a stub for the shell ones and
  `homebrew/install.sh` for `~/.Brewfile.local`, so `dot` backfills them on
  older machines; both skip files that already exist. **Never append
  machine-specific config to a tracked `*.symlink` file** — that's what these
  are for.
- Commits are GPG-signed automatically (gitconfig), messages are lowercase
  imperative summaries with a body explaining why. Group changes logically.
- Test before committing: `zsh -n <file>` for zsh, `bash -n` / `sh -n` for
  scripts, then open a real shell (`zsh -i -c ...`) to confirm behavior.
  For alias/function changes, verify resolution with `zsh -i -c 'alias <name>'`.
- No test framework, no linter — the "tests" are the syntax checks and a
  working shell. `git status` must stay clean after any install script runs.
