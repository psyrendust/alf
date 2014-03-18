#!/usr/bin/env zsh
#
# Make a directory and cd into it after it's creation.
#
# Author:
#   Larry Gordon
#
# Usage:
#   $ npp foo
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

[[ -n $PLATFORM_IS_CYGWIN ]] || return

npp_paths=(
  "/cygdrive/c/Program Files/Notepad++/notepad++.exe"
  "/cygdrive/c/Program Files (x86)/Notepad++/notepad++.exe"
)
for npp_path in $npp_paths; do
  if [[ -a $npp_path ]]; then
    # Alias the path to nodepad++.exe
    alias npp="${npp_path}"
    break
  fi
done

unset npp_path{,s}
