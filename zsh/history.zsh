# history settings
export HISTFILE=~/.zhistory   # History savefile location
export HISTSIZE=1000000       # Number of history items to save in memory
export SAVEHIST=1000000       # Number of history items to save in file
setopt APPEND_HISTORY         # multiple sessions append to same history file (rather than last)
setopt HIST_IGNORE_ALL_DUPS   # when adding a new entry delete older duplicates
setopt HIST_IGNORE_DUPS       # don't add a new entry if it's an immediate duplicate
setopt INC_APPEND_HISTORY     # adds history incrementally to share it across sessions
setopt SHARE_HISTORY          # share history between sessions
