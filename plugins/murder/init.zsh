#!/usr/bin/env zsh
#
# Kill a process by name.
#
# Author:
#   Larry Gordon
#
# Usage:
#   $ murder "itunes"
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------
# Add bin to PATH
export PATH="$(cd -P "$(cd -P ${0:h} && pwd)/bin" && pwd):$PATH"
