#!/usr/bin/env bash

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

# Install iTerm2 Fonts
cp *.otf /Library/Fonts/

# Install pretty iTerm colors
# TODO: Iterate over all files in ../iterm/presets?
open presets/Symfonic.itermcolors

# Import saved iterm2 settings
defaults import com.googlecode.iterm2 com.googlecode.iterm2.plist
