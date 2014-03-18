#!/usr/bin/env zsh
#
# Start an HTTP server from a directory, optionally specifying the port.
#
# Author:
#   Larry Gordon
#
# Usage:
#   $ server
#   $ server PORT_NUMBER
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

server() {
  local port="${1:-8000}"

  open "http://localhost:${port}/"

  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}
