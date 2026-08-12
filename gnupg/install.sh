#!/bin/sh
# Configure GPG agent for commit signing.
# On macOS, uses pinentry-mac for GUI passphrase prompts.

GNUPG_DIR="$HOME/.gnupg"
AGENT_CONF="$GNUPG_DIR/gpg-agent.conf"

find_pinentry() {
  if [ "$(uname -s)" = "Darwin" ]
  then
    which pinentry-mac 2>/dev/null || echo "/opt/homebrew/bin/pinentry-mac"
  else
    which pinentry 2>/dev/null || echo "/usr/bin/pinentry"
  fi
}

mkdir -p "$GNUPG_DIR"
chmod 700 "$GNUPG_DIR"

if [ ! -f "$AGENT_CONF" ]
then
  PINENTRY=$(find_pinentry)

  cat > "$AGENT_CONF" <<EOF
default-cache-ttl 600
max-cache-ttl 7200
pinentry-program $PINENTRY
no-emit-version
EOF

  chmod 600 "$AGENT_CONF"
  echo "  gpg-agent.conf created (pinentry: $PINENTRY)"
else
  # Repair a stale pinentry path (e.g. after an Intel → Apple Silicon move)
  CURRENT=$(sed -n 's/^pinentry-program[[:space:]]*//p' "$AGENT_CONF")
  if [ -n "$CURRENT" ] && [ ! -x "$CURRENT" ]
  then
    PINENTRY=$(find_pinentry)
    if [ -x "$PINENTRY" ]
    then
      sed "s|^pinentry-program .*|pinentry-program $PINENTRY|" "$AGENT_CONF" > "$AGENT_CONF.tmp"
      chmod 600 "$AGENT_CONF.tmp"
      mv "$AGENT_CONF.tmp" "$AGENT_CONF"
      gpgconf --kill gpg-agent 2>/dev/null || true
      echo "  gpg-agent.conf: replaced stale pinentry $CURRENT with $PINENTRY"
    fi
  fi
fi
