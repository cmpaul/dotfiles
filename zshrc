# Export variables
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export DISABLE_AUTO_TITLE=true
export TERM=xterm-256color
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home
export GOROOT=/usr/local/Cellar/go/1.2.1/libexec
export GOPATH=$HOME/go
export MAVEN_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"
export HS_VAGRANT_SHARE_TYPE="basic"
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/Users/cpaul/Library/Python/2.7/bin:$PATH
export LESS="-F -X -R"
export EXTERNAL_IP=`wget http://ipinfo.io/ip -qO -`

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

# Initialize zim & promp theme
autoload -Uz promptinit
  promptinit
  prompt eriner

# Auto-CD into a directory, e.g., "foo" instead of "cd foo"
setopt AUTO_CD

# Aliases
alias zconf="vi ~/.zshrc"
alias git="hub"
alias lsm="ls -lhFGHot"
alias rmorig="find . -name \"*.orig\" -type f -delete"
alias hipchat-bot="ssh -i \"/Users/cpaul/.ssh/hipchat-bot.pem\" ubuntu@ec2-52-8-180-122.us-west-1.compute.amazonaws.com"
alias prezto-update="cd ~/.zprezto; git pull && git submodule update --init --recursive; cd -"
alias jello="cd ~/dev/jellosign; mvn clean jetty:run -Dorg.slf4j.simpleLogger.defaultLogLevel=debug"
alias jellostaging="cd ~/dev/jellosign; mvn clean jetty:run -Dorg.slf4j.simpleLogger.defaultLogLevel=debug -Dhellosign.base.url=https://api.staging-hellosign.com -Dhellosign.oauth.base.url=https://www.staging-hellosign.com/oauth/token -Dhellosign.oauth.authorize.url=https://www.staging-hellosign.com/oauth/authorize -Dhellosign.disable.ssl=true"
alias jellodev="cd ~/dev/jellosign; mvn clean jetty:run -Dorg.slf4j.simpleLogger.defaultLogLevel=debug -Dhellosign.base.url=https://api.dev-hellosign.com -Dhellosign.oauth.base.url=https://www.dev-hellosign.com/oauth/token -Dhellosign.oauth.authorize.url=https://www.dev-hellosign.com/oauth/authorize -Dhellosign.disable.ssl=true"
alias postgres.status="pg_ctl status -D /usr/local/var/postgres"
alias postgres.stop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
alias postgres.start="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"

# Split the TMux window and edit a file in lower:
function e {
  tmux split-window -n "Edit: $@" "$EDITOR $@"
}

# Cmpilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/id_rsa"

# NodeJS Version Manager Config
export NVM_DIR="/Users/cpaul/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Initialize jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Neat apple thingy
archey
