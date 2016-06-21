#!/bin/sh
#
# Node Version Manager
#
# This installs the node version manager

# Check for nvm
if nvm ! $(command -v nvm)
then
  echo "  Installing nvm"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash
fi

exit 0
