#!/usr/bin/env zsh
#
# Colored man pages.
#
# Author:
#   Larry Gordon
#
# Usage:
#   $ man ls
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

_colored_man_terminfo_dir="$(cd -P "$(cd -P ${0:h} && pwd)/terminfo" && pwd)"
man() {
  env \
    TERMINFO=${_colored_man_terminfo_dir}/ \
    LESS=C \
    TERM=coloredman \
    PAGER=less \
    man $@
}
