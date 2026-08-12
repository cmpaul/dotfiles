#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

set -e

echo ''

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_hostname() {
  current_name=$(scutil --get ComputerName 2>/dev/null)

  if [ -n "$current_name" ]
  then
    user " - Hostname is currently '$current_name'. Enter a new one to change it, or leave empty to keep:"
  else
    user ' - What should the hostname be?'

    # A machine with no name is a fresh machine: apply macOS defaults too.
    # On re-runs bin/dot skips defaults unless DOTFILES_SETDEFAULTS=1 is set.
    export DOTFILES_SETDEFAULTS=1
  fi

  read -e new_hostname

  if [ -z "$new_hostname" ] || [ "$new_hostname" == "$current_name" ]
  then
    [ -n "$current_name" ] && success "hostname unchanged ($current_name)"
    return 0
  fi

  # LocalHostName rejects anything beyond letters, digits, and hyphens
  case "$new_hostname" in
    *[!a-zA-Z0-9-]*)
      fail "hostname may only contain letters, digits, and hyphens: '$new_hostname'" ;;
  esac

  info "setting hostname to $new_hostname (may prompt for your password)"
  sudo scutil --set ComputerName "$new_hostname"
  sudo scutil --set HostName "$new_hostname"
  sudo scutil --set LocalHostName "$new_hostname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$new_hostname"
  success "hostname set to $new_hostname"
}

setup_gitconfig () {
  if ! [ -f git/gitconfig.local.symlink ]
  then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]
    then
      git_credential='osxkeychain'
    fi

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    # Reuse an existing GPG key for this email if one exists
    KEYID=$(gpg --list-secret-keys --keyid-format=LONG "$git_authoremail" 2>/dev/null \
      | grep ^sec | awk '{print $2}' | cut -d '/' -f 2 | head -1)

    if [ -n "$KEYID" ]
    then
      success "found existing GPG key $KEYID for $git_authoremail"
    else
      user ' - Enter a passphrase for your GPG signing key (leave empty for no passphrase):'
      read -s git_gpgpassphrase
      echo

      # An empty "Passphrase:" makes batch-mode gpg fail (or fall back to a
      # pinentry prompt that can't work mid-bootstrap); %no-protection is the
      # supported way to generate an unprotected key.
      if [ -n "$git_gpgpassphrase" ]
      then
        gpg_protection="Passphrase: $git_gpgpassphrase"
      else
        gpg_protection="%no-protection"
      fi

      info 'generating GPG key (this can take a moment)'
      if ! gpg --batch --generate-key <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $git_authorname
Name-Email: $git_authoremail
Expire-Date: 0
$gpg_protection
%commit
EOF
      then
        fail "GPG key generation failed for $git_authoremail (see gpg output above)"
      fi

      KEYID=$(gpg --list-secret-keys --keyid-format=LONG "$git_authoremail" \
        | grep ^sec | awk '{print $2}' | cut -d '/' -f 2 | head -1)
      [ -n "$KEYID" ] || fail "no GPG secret key found for $git_authoremail after generation"
    fi

    # Export the public key — add this to GitHub Settings > SSH and GPG keys
    gpg --armor --export "$KEYID" > "$HOME/gpg-public-key.asc"
    success "GPG public key exported to ~/gpg-public-key.asc"
    info '  → Add it at https://github.com/settings/gpg/new'

    sed -e "s/AUTHORNAME/$git_authorname/g" \
        -e "s/AUTHOREMAIL/$git_authoremail/g" \
        -e "s/AUTHORSIGNINGKEY/$KEYID/g" \
        -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" \
        git/gitconfig.local.symlink.example > git/gitconfig.local.symlink

    # install_dotfiles already ran, before this file existed — link it now so
    # the include in gitconfig works on the first bootstrap run.
    if ! [ -e "$HOME/.gitconfig.local" ]
    then
      ln -s "$DOTFILES_ROOT/git/gitconfig.local.symlink" "$HOME/.gitconfig.local"
      success "linked $DOTFILES_ROOT/git/gitconfig.local.symlink to $HOME/.gitconfig.local"
    fi

    success 'gitconfig'
  fi
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

setup_hostname
install_dotfiles

# If we're on a Mac, let's install and setup homebrew.
if [ "$(uname -s)" == "Darwin" ]
then
  info "installing dependencies"
  if source bin/dot > /tmp/dotfiles-dot 2>&1
  then
    success "dependencies installed"
  else
    fail "error installing dependencies"
  fi
fi

install_gnupg() {
  if ! [ -x "$(command -v gpg)" ]; then
    info 'installing gnupg'
    if [ "$(uname -s)" == "Darwin" ]
    then
      brew install gnupg
    else
      sudo apt-get install gnupg
    fi
    success 'gnupg installed'
  fi
}

install_gnupg
setup_gitconfig

echo ''
echo '  All installed!'
