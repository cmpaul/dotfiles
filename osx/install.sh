# Install macOS software updates. This can take a long time and needs sudo,
# so it only runs when explicitly requested:
#   DOTFILES_SOFTWAREUPDATE=1 bin/dot

if [ "$DOTFILES_SOFTWAREUPDATE" = "1" ]; then
  echo "› sudo softwareupdate -i -a"
  sudo softwareupdate -i -a
else
  echo "› skipping macOS software update (set DOTFILES_SOFTWAREUPDATE=1 to run)"
fi
