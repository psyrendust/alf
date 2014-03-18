#!/usr/bin/env zsh
#
# Maps Unix "ln" to Windows "mklink" command in cygwin.
#
# Author:
#   Larry Gordon
#
# Synopsys
#     Creates a symbolic link if TARGET is a directory
#     ln -s TARGET LINK_NAME      >> cmd /c mklink /D "LINK_NAME" "TARGET"
#     ln -sf TARGET LINK_NAME     >> rm LINK_NAME && cmd /c mklink /D "LINK_NAME" "TARGET"
#
#     Creates a symbolic link if TARGET is a file
#     ln -s TARGET LINK_NAME      >> cmd /c mklink "LINK_NAME" "TARGET"
#     ln -sf TARGET LINK_NAME     >> rm LINK_NAME && cmd /c mklink "LINK_NAME" "TARGET"
#
#     Creates a hard link instead of a symbolic link
#     ln -P TARGET LINK_NAME      >> cmd /c mklink /H "LINK_NAME" "TARGET"
#     ln -P TARGET LINK_NAME      >> rm LINK_NAME && cmd /c mklink /H "LINK_NAME" "TARGET"
#
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------
# Add bin to PATH
[[ -n $PLATFORM_IS_CYGWIN ]] && export PATH="$(cd -P "$(cd -P ${0:h} && pwd)/bin" && pwd):$PATH"
