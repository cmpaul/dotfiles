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
