#!/bin/sh
#
# Homebrew
#
# Installs Homebrew if missing, then installs packages from the Brewfile.
# Work-specific packages go in ~/.Brewfile.local (not committed to this repo).

if test ! $(which brew); then
  echo "  Installing Homebrew for you."
  yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "  Installing Homebrew packages..."
brew bundle --file="$DOTFILES/homebrew/Brewfile"

if [ -f "$HOME/.Brewfile.local" ]; then
  echo "  Installing local Homebrew packages..."
  brew bundle --file="$HOME/.Brewfile.local"
fi

exit 0
