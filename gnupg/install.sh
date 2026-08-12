#!/bin/sh
# Configure GPG agent for commit signing.
# On macOS, uses pinentry-mac for GUI passphrase prompts.

GNUPG_DIR="$HOME/.gnupg"
AGENT_CONF="$GNUPG_DIR/gpg-agent.conf"

mkdir -p "$GNUPG_DIR"
chmod 700 "$GNUPG_DIR"

if [ ! -f "$AGENT_CONF" ]
then
  if [ "$(uname -s)" = "Darwin" ]
  then
    PINENTRY=$(which pinentry-mac 2>/dev/null || echo "/opt/homebrew/bin/pinentry-mac")
  else
    PINENTRY=$(which pinentry 2>/dev/null || echo "/usr/bin/pinentry")
  fi

  cat > "$AGENT_CONF" <<EOF
default-cache-ttl 600
max-cache-ttl 7200
pinentry-program $PINENTRY
no-emit-version
EOF

  chmod 600 "$AGENT_CONF"
  echo "  gpg-agent.conf created (pinentry: $PINENTRY)"
fi
