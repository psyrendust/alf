#!/usr/bin/env zsh
#
# Helper script for migrating essential Alf shell files.
#
# This is helpful if something got borked!
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------


# # Get the location of this script relative to the cwd
# # ------------------------------------------------------------------------------
# _alf_migrate="$0"

# # While the filename in $alf_migrate is a symlink
# while [ -L "$alf_migrate" ]; do
#   # similar to above, but -P forces a change to the physical not symbolic directory
#   alf_migrate_cwd="$( cd -P "$( dirname "$alf_migrate" )" && pwd )"

#   # Get the value of symbolic link
#   # If $alf_migrate is relative (doesn't begin with /), resolve relative
#   # path where symlink lives
#   alf_migrate="$(readlink -f "$alf_migrate")" && alf_migrate="$alf_migrate_cwd/$alf_migrate"
# done
# export _alf_migrate_cwd="$( cd -P "$( dirname "$alf_migrate" )" && pwd )"
# export _alf_migrate_root="${alf_migrate_cwd%/*}"


_alf-migrate() {
  if [[ $# > 1 ]]; then
    printf '\033[0;31m%s\033[0m\n' "Too many arguments"
    return 1
  fi
  local arg_flag=$1

  # # Source .zprofile to get global paths and vars
  # # ------------------------------------------------------------------------------
  # source $alf_migrate_root/templates/home/.zprofile
  # source $alf_migrate_root/tools/init-functions.zsh


  # Copy over templates
  # ------------------------------------------------------------------------------
  cp -aR "$ALF_SRC_TEMPLATES/home/." "$HOME/"
  cp -aR "$ALF_SRC_TEMPLATES/home-$([[ -n $PLATFORM_IS_CYGWIN ]] && echo "win" || echo "mac")/." "$HOME/"
  cp -aR "$ALF_SRC_TEMPLATES_CONFIG/win/." "$ALF_CONFIG_WIN/"
  cp -aR "$ALF_SRC_TEMPLATES_CONFIG/git/." "$ALF_CONFIG_GIT/"
  cp -an "$ALF_SRC_TEMPLATES_CONFIG/blank/custom-"{mac,win}.gitconfig "$ALF_CONFIG_GIT/"

  # [[ -f "$ALF_SRC_TOOLS/post-update.zsh" ]] && cp -a "$ALF_SRC_TOOLS/post-update.zsh" "$ALF_RUN_ONCE/post-update-alf.zsh"
  # [[ -f "$ALF_FRAMEWORKS_USER/tools/post-update.zsh" ]] && cp -a "$ALF_FRAMEWORKS_USER/tools/post-update.zsh" "$ALF_RUN_ONCE/post-update-zshrc-user.zsh"
  # [[ -f "$ALF_FRAMEWORKS_WORK/tools/post-update.zsh" ]] && cp -a "$ALF_FRAMEWORKS_WORK/tools/post-update.zsh" "$ALF_RUN_ONCE/post-update-zshrc-work.zsh"

  if [[ $arg_flag == "-r" || $arg_flag == "--restart" ]]; then
    _alf-restartshell
  fi
}
