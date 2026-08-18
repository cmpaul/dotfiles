#!/bin/sh
# Install oh-my-zsh and the powerlevel10k theme, which zshrc.symlink expects
# at ~/.oh-my-zsh. Plain clones — oh-my-zsh's own in-shell updater handles
# keeping them fresh; this only fills in what's missing.

ZSH_DIR="$HOME/.oh-my-zsh"
P10K_DIR="$ZSH_DIR/custom/themes/powerlevel10k"

if [ ! -d "$ZSH_DIR" ]; then
  echo "  Installing oh-my-zsh..."
  git clone --quiet --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_DIR"
fi

if [ ! -d "$P10K_DIR" ]; then
  echo "  Installing powerlevel10k..."
  git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Machine-local override files: untracked, and sourced only when present. Seed
# commented-out stubs so the pattern is discoverable instead of folklore — a
# hook nothing creates is a hook nobody remembers. Lives here rather than in
# bootstrap so `dot` backfills it on machines set up before these existed.
# Avoids `local`: this runs under whatever /bin/sh start.sh hands it.
seed_local_file() {
  _seed_dst=$1
  _seed_mode=$2

  if [ -e "$_seed_dst" ]; then
    cat > /dev/null   # consume the caller's heredoc, leave the file alone
    return 0
  fi

  cat > "$_seed_dst"
  chmod "$_seed_mode" "$_seed_dst"
  echo "  Created $_seed_dst"
}

seed_local_file "$HOME/.zshrc.local" 644 <<'EOF'
# Machine-specific interactive shell config — not tracked in ~/.dotfiles.
# Sourced last by ~/.zshrc, so it can override anything the tracked config
# sets. Nothing here may write to stdout — powerlevel10k's instant prompt
# flags any output during zshrc. To print at session start, use a one-shot
# precmd hook (see _secrets_reminder in zsh/zshrc.symlink).
EOF

seed_local_file "$HOME/.localaliases" 644 <<'EOF'
# Machine-specific aliases — not tracked in ~/.dotfiles.
# Sourced by ~/.zshrc after ~/.aliases, so definitions here win.
# Edit with `localaliases`.
EOF

seed_local_file "$HOME/.zprofile.local" 600 <<'EOF'
# Machine-specific login-shell environment — not tracked in ~/.dotfiles.
# Sourced by ~/.zprofile. Use this for PATH entries and env vars that should
# exist in login shells (including non-interactive ones).
#
# Do NOT put secrets here. Secrets live in 1Password: add a mapping line to
# ~/.secrets.conf.local and run `load-secrets`.
EOF

seed_local_file "$HOME/.secrets.conf.local" 600 <<'EOF'
# Machine-specific secret mappings — not tracked in ~/.dotfiles.
# Read by load-secrets (zsh/zshrc.symlink) in addition to the tracked
# zsh/secrets.conf. Values are 1Password references, never secrets themselves.
#
# Format (no spaces around the =):
#   ENV_VAR=op://<vault>/<item>/<field>
EOF
