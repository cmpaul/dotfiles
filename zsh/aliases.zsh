alias reload!='. ~/.zshrc'

alias cls='clear' # Good 'ol Clear Screen command

# Edit .zshrc.local
alias zconf="vi ~/.zshrc.local"

# Random aliases I want to keep
alias jello="cd ~/dev/jellosign; mvn clean jetty:run -Dorg.slf4j.simpleLogger.defaultLogLevel=debug"
alias jellostaging="cd ~/dev/jellosign; mvn clean jetty:run -Dorg.slf4j.simpleLogger.defaultLogLevel=debug -Dhellosign.base.url=https://api.staging-hellosign.com -Dhellosign.oauth.base.url=https://www.staging-hellosign.com/oauth/token -Dhellosign.oauth.authorize.url=https://www.staging-hellosign.com/oauth/authorize -Dhellosign.disable.ssl=true"
alias jellodev="cd ~/dev/jellosign; mvn clean jetty:run -Dorg.slf4j.simpleLogger.defaultLogLevel=debug -Dhellosign.base.url=https://api.dev-hellosign.com -Dhellosign.oauth.base.url=https://www.dev-hellosign.com/oauth/token -Dhellosign.oauth.authorize.url=https://www.dev-hellosign.com/oauth/authorize -Dhellosign.disable.ssl=true"
alias postgres.status="pg_ctl status -D /usr/local/var/postgres"
alias postgres.stop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
alias postgres.start="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
