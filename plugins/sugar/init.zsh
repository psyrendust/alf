#!/usr/bin/env zsh
#
# Syntax sugar for `alf` to use in all shells.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# A syntax sugar to avoid the `-` when calling alf commands. With this
# function, you can write `_alf-update` as `alf update` and so on.
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
alf() {
  local cmd="$1"
  if [[ $cmd == "--version" ]] || [[ $cmd == "-v" ]]; then
    __alf-version --get
    return
  elif [[ -z "$cmd" ]]; then
    echo 'Alf: Please give a command to run.' >&2
    return 1
  fi
  shift

  if functions "_alf-$cmd" > /dev/null; then
    "_alf-$cmd" "$@"
  else
    echo "Alf: Unknown command: $cmd" >&2
  fi
}


# ------------------------------------------------------------------------------
# Setup autocompletion for _alf-* functions
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
# ------------------------------------------------------------------------------
_alf-apply() {
  # Setup alf's own completion.
  compdef __alf-exec-compadd alf
}

# Setup alf's autocompletion
__alf-exec-compadd() {
  eval "compadd \
    $(echo $(print -l ${(k)functions} | grep "^_alf-" | sed "s/_alf-//g"))"
}
