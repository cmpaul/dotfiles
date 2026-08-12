#!/bin/sh
# Register the Clear Dark profile with Terminal.app and make it the default.
# It's the stock macOS "Clear Dark" profile with the font swapped to
# MesloLGS NF (installed by fonts/install.sh), which powerlevel10k needs to
# render its prompt glyphs.
#
# The profile is only imported when missing, so tweaks made in Terminal's
# preferences survive re-runs. Terminal must be relaunched to pick it up.

[ "$(uname -s)" = "Darwin" ] || exit 0

DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILE="Clear Dark"

if ! defaults export com.apple.Terminal - 2>/dev/null \
    | plutil -extract "Window Settings.$PROFILE" raw -o - - >/dev/null 2>&1; then
  defaults write com.apple.Terminal "Window Settings" \
    -dict-add "$PROFILE" "$(cat "$DIR/$PROFILE.terminal")"
  echo "  Terminal profile '$PROFILE' imported"
fi

for key in "Default Window Settings" "Startup Window Settings"; do
  if [ "$(defaults read com.apple.Terminal "$key" 2>/dev/null)" != "$PROFILE" ]; then
    defaults write com.apple.Terminal "$key" -string "$PROFILE"
    echo "  Terminal '$key' set to $PROFILE"
  fi
done
