#!/usr/bin/env zsh
#
# Functions to help manage frameworks within Alf.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# A syntax sugar to avoid the `-` when calling alf commands. With this
# function, you can write `_alf-framework-[cmd]` as `alf framework [cmd]` and so on.
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
_alf-framework() {
  local cmd="$1"
  if [[ -z "$cmd" ]]; then
    echo 'Alf: Please give a command to run.' >&2
    return 1
  fi
  shift

  if functions "_alf-framework-$cmd" > /dev/null; then
    "_alf-framework-$cmd" "$@"
  else
    echo "Alf: Unknown command: alf framework $cmd" >&2
  fi
}

__alf-framework-usage() {
  cat <<EOF

SYNOPSYS
USAGE
  install [github url] [file to init]
  uninstall [github url] [file to init]
  update [github url] [file to init]
EOF
}


# Install a framework into Alf
# ------------------------------------------------------------------------------
_alf-framework-install() {
  git clone
}


# Uninstall a framework from Alf
# ------------------------------------------------------------------------------
_alf-framework-uninstall() {

}


# Update an existing framework
# ------------------------------------------------------------------------------
_alf-framework-upgrade() {

}


# List all currently install frameworks
# ------------------------------------------------------------------------------
_alf-framework-upgrade() {

}


