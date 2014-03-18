#!/usr/bin/env zsh
#
# Commands to control local apache2 server installation on OS X
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

alias apstart='sudo apachectl start'
alias apstop='sudo apachectl stop'
alias aprestart='sudo apachectl restart'
alias apload='sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist'
alias apunload='sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist'
