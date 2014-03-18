#!/usr/bin/env zsh
#
# Functions to help manage themes within the system.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------




# Symlink the themes folder with the latest versions of the originals
# ------------------------------------------------------------------------------
_alf-theme-link() {
  # Clean out the old themes
  for plugin in "$ALF_THEMES/"*; do rm -rf "$plugin"; done
  # Get a list of all themes
  alf_themes=($(find {{$ZSH,$ALF_FRAMEWORKS_ALF,$ALF_FRAMEWORKS_WORK,$ALF_FRAMEWORKS_USER}/themes,$ALF_REPOS_THEMES} -type f -name "*.zsh*" 2>/dev/null))
  # Copy all plugins to plugins folder
  for alf_theme in "${alf_themes[@]}"; do
    ln -sf "$alf_theme" "$ALF_THEMES/${alf_theme:t:r}.zsh-theme"
  done
  unset alf_theme{,s}
}
