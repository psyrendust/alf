#!/usr/bin/env zsh
#
# Fixes cygwin paths when passing files as arguments to kdiff3.exe
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------
# Add bin to PATH
[[ -n $PLATFORM_IS_CYGWIN ]] && export PATH="$(cd -P "$(cd -P ${0:h} && pwd)/bin" && pwd):$PATH"
