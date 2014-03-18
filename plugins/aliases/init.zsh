#!/usr/bin/env zsh
#
# Custom aliases for use in all interactive-login shells.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# Helper aliases
alias zshconfig="sbl ~/.zshrc"
alias ohmyzsh="sbl ~/.oh-my-zsh"
alias sourceohmyzsh="source ~/.zshrc"
alias npmlist="npm -g ls --depth=0 2>/dev/null"



# System specific configuration
if [[ -n $PLATFORM_IS_MAC ]]; then
  # Add some OS X related configuration
  alias chownapps="find /Applications -maxdepth 1 -user root -exec sudo chown -R $(echo $USER):staff {} + -print"
  alias manp="man-preview"
  alias ql="quick-look"
elif [[ -n $PLATFORM_IS_CYGWIN ]]; then
  # Add some cygwin related configuration
  alias cygpackages="cygcheck -c -d | sed -e \"1,2d\" -e 's/ .*$//'"
  alias open="cygstart"
  # Add pbcopy and pbpaste to Cygwin
  if [ -e /dev/clipboard ]; then
    alias pbcopy='cat >/dev/clipboard'
    alias pbpaste='cat /dev/clipboard'
  fi
fi



# Replacing oh-my-zsh aliases to remove verbose flags
alias cp='cp'
alias rm='rm'
alias mv='mv'
