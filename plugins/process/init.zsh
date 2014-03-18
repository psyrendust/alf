#!/usr/bin/env zsh
#
# Processing state helper functions.
#
# Author:
#   Larry Gordon
#
# Usage:
#   $ process -[r|s|x] [namespace]
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# Add bin to PATH
export PATH="$(cd -P "$(cd -P ${0:h} && pwd)/bin" && pwd):$PATH"
