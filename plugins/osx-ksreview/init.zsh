#!/usr/bin/env zsh
#
# Open diff in Kaleidoscope.app
#
# Author:
#   Larry Gordon
#
# Usage:
#   git ksreview
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------
# Add bin to PATH
[[ -n $PLATFORM_IS_MAC ]] && export PATH="$(cd -P "$(cd -P ${0:h} && pwd)/bin" && pwd):$PATH"
