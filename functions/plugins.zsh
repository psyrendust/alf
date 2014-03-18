#!/usr/bin/env zsh
#
# Functions to help manage plugins within the system.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------



# # Symlink the plugins folder with the latest versions of the originals
# # ------------------------------------------------------------------------------
# _alf-plugin-link() {
#   # Clean out the old plugins
#   for plugin in "$ALF_PLUGINS/"*; do rm -rf "$plugin"; done
#   # Get a list of all plugins
#   alf_plugins=($(find {{$ZSH,$ALF_FRAMEWORKS_ALF,$ALF_FRAMEWORKS_WORK,$ALF_FRAMEWORKS_USER}/plugins,$ALF_REPOS_PLUGINS} -type d -maxdepth 1 \( ! -iname "plugins" \) 2>/dev/null))
#   # Symlink all plugins
#   for alf_plugin in ${alf_plugins}; do
#     ln -sf "${alf_plugin}" "$ALF_PLUGINS/${alf_plugin:t}"
#   done
#   unset alf_plugin{,s}
# }
