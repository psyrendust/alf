#!/usr/bin/env zsh
#
# Run any post-update scripts if they exist.
#
# Author:
#   Larry Gordon
#
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# Add bin to PATH
export PATH="$(cd -P "$(cd -P ${0:h} && pwd)/bin" && pwd):$PATH"
