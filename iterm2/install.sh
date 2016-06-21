#!/usr/bin/env bash

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

# Install iTerm2 Fonts
cp -v -n $DOTFILES/iterm2/*.otf /Library/Fonts/

# Install pretty iTerm colors
# TODO: Iterate over all files in ../iterm/presets?
open $DOTFILES/iterm2/presets/Symfonic.itermcolors

# Import saved iterm2 settings
cd $DOTFILES/iterm2
defaults import com.googlecode.iterm2 com.googlecode.iterm2.plist
cd -
