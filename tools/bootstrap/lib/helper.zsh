#!/usr/bin/env zsh
#
# Helper functions for bootstrapping your shell environment
#
# name:
#   helper.zsh
#
# Authors:
#   Larry Gordon
#
# ------------------------------------------------------------------------------

# Check if a formula is installed in homebrew
# alf formulae-is-installed
_alf-formulae-is-installed() {
  if $(brew list $1 >/dev/null); then
    ppsuccess "$1 is installed"
    return 0
  fi
  ppdanger "Missing formula: $1"
  return 1
}

# Check if a cask application is installed
_alf-cask-is-installed() {
  if $(brew cask list $1 >/dev/null); then
    ppsuccess "$1 is installed"
    return 0
  fi
  ppdanger "Missing cask: $1"
  return 1
}

# Check if a formula is tapped in homebrew or install it
_alf-brew-is-tapped() {
  if [[ -n $(brew tap 2>/dev/null | grep "^${1}$") ]]; then
    ppsuccess "$1 is tapped"
    return 0
  fi
  ppdanger "$1 not tapped"
  return 1
}


#
_alf-apps-print() {
  typeset -A alf_print_apps
  eval "zstyle -a '$1' install 'alf_print_apps'"
  alf_apps_list=""
  for alf_print_app in "${(k)alf_print_apps[@]}"; do
    alf_apps_list="$alf_apps_list $alf_print_app "
  done
  echo "$alf_apps_list"
  unset alf_apps_list
  unset alf_print_app{s,}
}
