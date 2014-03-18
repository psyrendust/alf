#!/usr/bin/env zsh
#
# System functions for use in all shells.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# Create a backup of any config files
# ------------------------------------------------------------------------------
_alf-backup() {
  local alf_config_base_development="$(find $HOME -maxdepth 3 -name "alf" -type d 2> /dev/null | grep "github")"
  if [[ -z "$alf_config_base_development" ]]; then
    alf_config_base_development="$(find /cygdrive/z -maxdepth 3 -name "alf" -type d 2> /dev/null | grep "github")"
  fi
  # Only run if one of the base dev locations was found
  if [[ -n $alf_config_base_development ]]; then
    rsync -avr "$ALF_CONFIG_WIN/ConEmu.xml" "$alf_config_base_development/templates/config/win/ConEmu.xml"
    rsync -avr "$ALF_CONFIG_WIN/AutoHotkey.ahk" "$alf_config_base_development/templates/config/win/AutoHotkey.ahk"
    _alf-mkcygwin "$alf_config_base_development/tools/cygwin-setup.bat"
  fi
}


# Fixes permissions for locally installed binaries
# ------------------------------------------------------------------------------
_alf-chownbin() {
  if [[ -n $PLATFORM_IS_MAC ]]; then
    # Ensure the current user is in the correct groups (wheel and staff)
    sudo dseditgroup -o edit -a $(echo $USER) -t user wheel
    sudo dseditgroup -o edit -a $(echo $USER) -t user staff
  fi
  # Change ownership to root:wheel
  chown -R root:wheel /usr/local
  chown -R root:wheel /Library/Caches/Homebrew
  # Give group write access
  chmod -R g+w /usr/local
  chmod -R g+w /Library/Caches/Homebrew
}


# Check if an active internet connection is present
# ------------------------------------------------------------------------------
_alf-has-internet() {
  wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null && echo 1
}


# Create a batch file that will install all of the currently installed
# dependencies in Cygwin. Usefull for bootstrapping a new system
# ------------------------------------------------------------------------------
_alf-mkcygwin() {
  if [[ -n $PLATFORM_IS_CYGWIN ]]; then
    echo "echo off" > $1
    echo -n "%1 -q -P " >> $1
    echo $(echo $(cygcheck -c -d | sed -e "1,2d" -e 's/ .*$//') | tr " " ",") >> $1
  fi
}


# Update all global npm packages except for npm, because updating npm using npm
# always breaks. Running npm -g update will result in having to reinstall node.
# This little script will update all global npm packages except for npm.
# ------------------------------------------------------------------------------
_alf-npmupdate() {
  # Create a clean list of globally installed npm packages
  # npm -g ls --depth=0 2>/dev/null   List all npm packages at root level
  # grep "──"                         Only list lines that contain a tree prefix "├──" or "└──"
  # awk -F'@' '{print $1}'            Remove trailing version number "@0.0.0"
  # awk '{print $2}'                  Only print the 2nd column which contains the names of the package
  # awk  '!/npm/'                     Exclude npm in the final list
  npm -g ls --depth=0 2>/dev/null | grep "──" | awk -F'@' '{print $1}' | awk '{print $2}' | awk  '!/npm/' > "$ALF_DOT/npm-g-ls"
  for pkg in $(cat $ALF_DOT/npm-g-ls); do
    npm -g update $pkg
  done
  rm "$ALF_DOT/npm-g-ls"
}


# Return an array of plugins to install on the given platform
# ------------------------------------------------------------------------------
__alf-plugins-install() {
  setopt shwordsplit
  platform_types="#|ALL|MAC|LINUX|CYGWIN|VM"
  typeset -a plugins
  for arg in $@; do
    typeset -a alf_plugins
    eval "zstyle -a '$arg' plugins 'alf_plugins'"
    for alf_plugin in "${alf_plugins[@]}"; do
      # Configure IFS so that we can word split on ':'
      __IFS="$IFS"
      IFS=':' alf_plugin_config=($alf_plugin)
      IFS="$__IFS"
      unset __IFS
      if [[ -z $(echo ${alf_plugin_config[1]} | egrep "$platform_types") ]]; then
        # Add the plugin if the first index in the array is not a platform identifier
        plugins+=(${alf_plugin_config[1]})
      elif [[ -n $(echo ${alf_plugin_config[1]} | egrep "$platform_types") ]]; then
        # Use parameter expansion (P) to figure out the platform type: ${(P)platform_is}
        platform_is="PLATFORM_IS_${alf_plugin_config[1]}"
        if [[ -n ${(P)platform_is} ]]; then
          # Add the plugin if the platform type matches
          plugins+=(${alf_plugin_config[2]})
        fi
      fi
      unset alf_plugin_config
    done
    unset alf_plugin{s,}
  done
  echo "${plugins}"
  unset plugins
  unset platform_types
  unsetopt shwordsplit
}


# Close and reopen the current shell window
# ------------------------------------------------------------------------------
_alf-restartshell() {
  ppemphasis ""
  ppemphasis ""
  if [[ -n $PLATFORM_IS_MAC ]]; then
    # If we are running OS X we can use applescript to create a new tab and
    # close the current tab we are on
    ppemphasis "Restarting iTerm Shell..."
    sleep 1
    osascript "$ALF_SRC_TOOLS/restart-iterm.scpt"
  elif [[ -n $PLATFORM_IS_CYGWIN ]]; then
    # If we are running cygwin we can restart the current console
    ppemphasis "Restarting Cygwin Shell..."
    sleep 1
    cygstart "$ALF_SRC_TOOLS/restart-cygwin.vbs"
  fi
}


# Force run the auto-update script
# ------------------------------------------------------------------------------
_alf-update() {
  for file ($(ls $ALF_UPDATES/)) rm "$ALF_UPDATES/$file"
  unset file
  source "$ALF_SRC_PLUGINS/alf-rprompt/init.zsh";
  source "$ALF_SRC_TOOLS/auto-update.zsh"
}
