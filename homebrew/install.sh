#!/bin/sh
#
# Homebrew
#
# Installs Homebrew if missing, then installs packages from the Brewfile.
# Work-specific packages go in ~/.Brewfile.local (not committed to this repo).

# Put an installed-but-not-on-PATH brew on PATH: the installer doesn't touch
# the invoking shell, and on a fresh machine zprofile hasn't been sourced yet.
wire_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
}

wire_brew

if ! command -v brew >/dev/null 2>&1; then
  echo "  Installing Homebrew for you."
  yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  wire_brew
fi

echo "  Installing Homebrew packages..."
brew bundle --file="$DOTFILES/homebrew/Brewfile"

if [ -f "$HOME/.Brewfile.local" ]; then
  echo "  Installing local Homebrew packages..."
  brew bundle --file="$HOME/.Brewfile.local"
fi

exit 0
