#!/usr/bin/env zsh
#
# Print to stdout with pretty colors!
#
# Author:
#   Larry Gordon
#
# Usage:
#   $ ppbrown "brown"
#   $ ppdanger "danger"
#   $ ppemphasis "emphasis"
#   $ ppinfo "info"
#   $ pplightcyan "lightcyan"
#   $ pplightgreen "lightgreen"
#   $ pplightred "lightred"
#   $ ppred "red"
#   $ ppsuccess "success"
#   $ ppverbose "verbose"
#   $ ppwhite "white"
#   $ ppblue "blue"
#   $ ppcyan "cyan"
#   $ ppdarkgray "darkgray"
#   $ ppgreen "green"
#   $ pplightblue "lightblue"
#   $ pplightgray "lightgray"
#   $ pplightpurple "lightpurple"
#   $ pppurple "purple"
#   $ pptest "test"
#   $ ppwarning "warning"
#   $ ppyellow "yellow"
#
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# Color references: numeric-sort
# ----------------------------------------------------------
# Black       0;30     Dark Gray     1;30
# Red         0;31     Light Red     1;31
# Green       0;32     Light Green   1;32
# Brown       0;33     Yellow        1;33
# Blue        0;34     Light Blue    1;34
# Purple      0;35     Light Purple  1;35
# Cyan        0;36     Light Cyan    1;36
# Light Gray  0;37     White         1;37

# Color references: alpha-sort
# ----------------------------------------------------------
# Black         0;30
# Blue          0;34
# Brown         0;33
# Cyan          0;36
# Dark Gray     1;30
# Green         0;32
# Light Blue    1;34
# Light Cyan    1;36
# Light Gray    0;37
# Light Green   1;32
# Light Purple  1;35
# Light Red     1;31
# Purple        0;35
# Red           0;31
# White         1;37
# Yellow        1;33

# Add bin to PATH
export PATH="$(cd -P "$(cd -P ${0:h} && pwd)/bin" && pwd):$PATH"

