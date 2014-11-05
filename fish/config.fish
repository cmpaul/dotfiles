# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Theme
set fish_theme robbyrussell
# set fish_theme bira

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler

# Path to your custom folder (default path is $FISH/custom)
# set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

# **********************************************
# Personal configuration
# **********************************************

set -x JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home
set -x GOROOT /usr/local/Cellar/go/1.2.1/libexec
set -x GOPATH $HOME/go

set PATH $GOROOT $JAVA_HOME/bin /usr/local/bin $PATH

alias lsm="ls -lhFGHot"
alias confish="vi ~/.config/fish/config.fish"
alias git=hub
