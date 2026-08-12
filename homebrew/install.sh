#!/bin/sh
#
# Homebrew
#
# Installs Homebrew if missing, then installs packages from the Brewfile.
# Work-specific packages go in ~/.Brewfile.local (not committed to this repo).

if test ! $(which brew); then
  echo "  Installing Homebrew for you."
  yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # The installer doesn't modify this shell's PATH (new logins get it from
  # zprofile), so wire brew up here for the bundle steps below.
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

echo "  Installing Homebrew packages..."
brew bundle --file="$DOTFILES/homebrew/Brewfile"

if [ -f "$HOME/.Brewfile.local" ]; then
  echo "  Installing local Homebrew packages..."
  brew bundle --file="$HOME/.Brewfile.local"
fi

exit 0
