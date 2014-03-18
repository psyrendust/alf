#!/usr/bin/env zsh
#
# Filter your zsh aliases using regex.
#
# Author:
#   Larry Gordon
#
# Usage:
#   ag
#   ag git
#   agb git
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# List all installed aliases or filter using regex
ag() {
  local pattern="${1:-}"
  if [[ $pattern == '' ]]; then
    alias
  else
    alias | grep -e $pattern
  fi
}

# List all installed aliases or filter using regex at the
# start of the string
agb() {
  local pattern="${1:-}"
  if [[ $pattern == '' ]]; then
    alias
  else
    alias | grep -e "^$pattern"
  fi
}
