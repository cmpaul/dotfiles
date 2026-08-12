#!/bin/sh
# Install patched fonts into ~/Library/Fonts.
#
# MesloLGS NF is the font powerlevel10k is designed for (its config assumes
# the extra glyphs it patches in). Vendored from
# https://github.com/romkatv/powerlevel10k-media (Meslo LG, Apache 2.0).

[ "$(uname -s)" = "Darwin" ] || exit 0

DIR="$(cd "$(dirname "$0")" && pwd)"
FONT_DIR="$HOME/Library/Fonts"

mkdir -p "$FONT_DIR"

for font in "$DIR"/*.ttf; do
  name="$(basename "$font")"
  if ! cmp -s "$font" "$FONT_DIR/$name"; then
    cp "$font" "$FONT_DIR/$name"
    echo "  installed font: $name"
  fi
done
