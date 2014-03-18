#!/usr/bin/env zsh
#
# Custom key bindings for use in all interactive-login shells.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# Bind UP and DOWN arrow keys to zsh-history-substring-search
bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down
