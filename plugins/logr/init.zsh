#!/usr/bin/env zsh
#
# Log helper function.
#
# Author:
#   Larry Gordon
#
# Usage:
#   man logr
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------
# Add bin to PATH
export PATH="$(cd -P "$(cd -P ${0:h} && pwd)/bin" && pwd):$PATH"
export MANPATH="$(cd -P "$(cd -P ${0:h} && pwd)/man" && pwd):$MANPATH"
