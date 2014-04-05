#!/usr/bin/env zsh
#
# Open path or files in Sublime Text 3 or Sublime Text 2.
#
# Uses a sleep command to fix a bug with ST opening with no
# files/folders showing in the sidebar.
#
# Author:
#   Larry Gordon
#
# Usage:
#   $ sbl .
#   $ sbl filename.txt
#   $ sbl file1.txt file2.txt
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

sublime_paths=(
  "$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
  "$HOME/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl"
  "$HOME/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
  "/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl"
  "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
  "/cygdrive/c/Program Files/Sublime Text 3/sublime_text.exe"
  "/cygdrive/c/Program Files/Sublime Text 2/sublime_text.exe"
)

for sublime_path in $sublime_paths; do
  if [[ -a $sublime_path ]]; then
    # Alias subl to it's executable because it's faster than creating a Symlink
    alias subl="\"$sublime_path\""
    break
  fi
done

unset sublime_path{,s}

sbl() {
  if  [[ -n $PLATFORM_IS_MAC ]]; then
    subl $@
  elif  [[ -n $PLATFORM_IS_CYGWIN ]]; then
    cygstart subl $(cygpath -w $@)
  elif [[ -n $PLATFORM_IS_LINUX ]]; then
    if [ -f '/usr/bin/sublime_text' ]; then
      nohup /usr/bin/sublime_text $@ > /dev/null &
    else
      nohup /usr/bin/sublime-text $@ > /dev/null &
    fi
  fi
}
