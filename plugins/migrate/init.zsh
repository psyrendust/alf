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


  # ------------------------------------------------------------------------------
  # Small helper function to get Antigen's clone dir for a given repo url
  # ------------------------------------------------------------------------------
  __alf-get-antigen-clone-dir() {
    local url="$1"
    if [[ $# > 1 ]]; then
      local branch="$(echo $2 | cut -d= -f2)"
      if [[ ! -z $branch ]]; then
          url="$url|$branch"
      fi
    fi
    echo "$url" | sed \
                -e 's./.-SLASH-.g' \
                -e 's.:.-COLON-.g' \
                -e 's.|.-PIPE-.g'
  }



  # ------------------------------------------------------------------------------
  # Do some platform checks so we don't have to keep doing it later
  # ------------------------------------------------------------------------------
  if [[ $('uname') == *Darwin* ]]; then
    # We are using OS X
    export PLATFORM_IS_MAC=1

  elif [[ $('uname') == *CYGWIN* ]]; then
    # We are using Cygwin in Windows
    export PLATFORM_IS_CYGWIN=1
    # We are also in a virtualized Windows environment
    if [[ -f $(find /cygdrive/z -maxdepth 1 -type f -name ".zshrc.lnk") ]]; then
      export PLATFORM_IS_VM=1
      export ALF_HOST="/cygdrive/z/.alf"
    fi

  elif [[ $('uname') == *Linux* ]]; then
    # We are using Linux
    export PLATFORM_IS_LINUX=1
  fi
  # Add support for all systems
  export PLATFORM_IS_ALL=1


  local arg_flag=$1
  local platform_type="mac"


  export ALF_CUSTOM="$HOME/.alf"
  export ADOTDIR="$ALF_CUSTOM/antigen"
  export ALF_URL="https://github.com/psyrendust/alf.git"
  export OMZ_URL="https://github.com/robbyrussell/oh-my-zsh.git"
  export Alf_BACKUP="$ALF_CUSTOM/backup"
  export Alf_CONFIG="$ALF_CUSTOM/config"
  export Alf_CONFIG_GIT="$ALF_CUSTOM/config/git"
  export Alf_CONFIG_SSH="$ALF_CUSTOM/config/ssh"
  export Alf_CONFIG_WIN="$ALF_CUSTOM/config/win"
  export Alf_EPOCH="$ALF_CUSTOM/epoch"
  export Alf_LOGR="$ALF_CUSTOM/logr"
  export Alf_PROCESS="$ALF_CUSTOM/process"
  export Alf_RPROMPT="$ALF_CUSTOM/rprompt"
  export Alf_RUN_ONCE="$ALF_CUSTOM/run-once"
  export Alf_SYMLINK="$ALF_CUSTOM/symlink"
  export Alf_UPDATES="$ALF_CUSTOM/updates"
  export Alf_VERSION="$ALF_CUSTOM/version"
  export Alf_GRUNT_INIT="$HOME/.grunt-init"
  export Alf_SRC_FONTS="$ALF_SRC/fonts"
  export Alf_SRC_GIT_HOOKS="$ALF_SRC/git-hooks"
  export Alf_SRC_PLUGINS="$ALF_SRC/plugins"
  export Alf_SRC_TEMPLATES="$ALF_SRC/templates"
  export Alf_SRC_TEMPLATES_CONFIG="$ALF_SRC/templates/config"
  export Alf_SRC_THEMES="$ALF_SRC/themes"
  export Alf_SRC_TOOLS="$ALF_SRC/tools"

  # Define a different branch for Alf, helpful for doing dev
  [[ -s "$ALF_CONFIG/branch" ]] && export ALF_BRANCH="--branch=$(echo `cat $ALF_CONFIG/branch`)"
  export ALF_SRC="$ADOTDIR/repos/$(__alf-get-antigen-clone-dir $ALF_URL $ALF_BRANCH)"
  export ZSH="$ADOTDIR/repos/$(__alf-get-antigen-clone-dir $OMZ_URL)"
  export ZSH_CUSTOM="$ALF_SRC"

  if [[ -n $PLATFORM_IS_CYGWIN ]]; then
    if [[ -z "$(echo $PATH | grep "cygwin-ln")" ]]; then
      # Ensure that we are using mklink in Cygwin
      export PATH=$ALF_SRC/plugins/cygwin-ln/bin:$PATH
    fi
    platform_type="win"
  fi

  # Symlink alf to normalize the path
  ln -sf "$ALF_SRC" "$ALF_CUSTOM/alf"

  # Symlink home templates
  for file in $(find "$ALF_SRC/templates/home" -name ".*"); do
    ln -sf "$ALF_CUSTOM/alf/templates/home/${file:t}" "$HOME/${file:t}"
  done

  # Copy over templates
  # ------------------------------------------------------------------------------
  ln -sf "$ALF_SRC_TEMPLATES/home-${platform_type}/.gitconfig" "$HOME/.gitconfig"
  cp -aR "$ALF_SRC_TEMPLATES_CONFIG/win/." "$ALF_CONFIG_WIN/"
  cp -aR "$ALF_SRC_TEMPLATES_CONFIG/git/." "$ALF_CONFIG_GIT/"
  cp -an "$ALF_SRC_TEMPLATES_CONFIG/blank/custom-"{mac,win}.gitconfig "$ALF_CONFIG_GIT/"

  # Remove any previous run-once files
  for file in $(find "$ALF_RUN_ONCE" -type f); do
    rm "$file"
  done

  [[ -f "$ALF_SRC_TOOLS/post-update.zsh" ]] && cp -a "$ALF_SRC_TOOLS/post-update.zsh" "$ALF_RUN_ONCE/post-update-run-once-alf.zsh"
  [[ -f "$ALF_USER/tools/post-update.zsh" ]] && cp -a "$ALF_USER/tools/post-update.zsh" "$ALF_RUN_ONCE/post-update-run-once-zshrcuser.zsh"
  [[ -f "$ALF_WORK/tools/post-update.zsh" ]] && cp -a "$ALF_WORK/tools/post-update.zsh" "$ALF_RUN_ONCE/post-update-run-once-zshrcwork.zsh"

  if [[ $arg_flag == "-r" || $arg_flag == "--restart" ]]; then
    alf restartshell
  fi
}
