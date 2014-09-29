#!/usr/bin/env zsh
#
# Gem helper function for use with Cygwin.
#
# When using Cygwin with Ruby (mingw64) the "gem" command will not work as
# as stated in SO <http://stackoverflow.com/a/4260598/1013618>.
# Included is a "gem" wrapper function that creates aliases for each gem when
# opening a new shell. The gem function will also add and remove aliases when
# executing "gem install" and "gem uninstall". All "gem" commands are passed
# along to the native gem function.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------
[[ -n $PLATFORM_IS_CYGWIN ]] || return

# Set the location of our Ruby executable
# --------------------------------------------------------------------------
if [[ -n "$(which ruby 2>/dev/null)" ]]; then
  export ALF_RUBY_BIN="$(cygpath -u $(ruby -e 'puts RbConfig::CONFIG["bindir"]') | sed 's/\\r$//g' )"
fi


# Lists all gems and associated executables installed with gem returned as
# a string one:two:three
# --------------------------------------------------------------------------
_gem-list() {
  echo "${$(ls "$ALF_RUBY_BIN" | grep ".bat$" | tr "\n" ":")%:}"
}

# Lists all gems and associated executables installed with gem returned as
# an array (one two three)
# --------------------------------------------------------------------------
_gem-list-array() {
  echo "${$(ls "$ALF_RUBY_BIN" | grep ".bat$" | tr "\n" " ")%:}"
}

# Manage aliases for installed gems
# Adds an alias to the associated .bat when executing "gem install".
# Removes an alias when executing "gem uninstall".
# --------------------------------------------------------------------------
_gem-alias() {
  if [[ $1 == "uninstall" ]]; then
    uninstall_alias=1
  fi
  shift
  args_list=()
  if [[ ${#@} > 0 ]]; then
    args_list=( $(echo $@ | tr ":" " ") )
  fi
  curr_gems=( $(_gem-list-array) )
  # Add gem.bat if the array is empty so that it can be filtered out later.
  # We do this because we have a function called "gem" and we don't need
  # an alias to replace this function.
  [[ ${#args_list[@]} == 0 ]] && args_list=( gem.bat )
  gems_list_sm=()
  gems_list_lg=()
  if [[ ${#args_list[@]} -gt ${#curr_gems[@]} ]]; then
    gems_list_sm=("${curr_gems[@]}")
    gems_list_lg=("${args_list[@]}")
  else
    gems_list_sm=("${args_list[@]}")
    gems_list_lg=("${curr_gems[@]}")
  fi
  # Filter out the unique elements
  diff_gems=()
  for gem_file_bat in "${gems_list_lg[@]}"; do
    if [[ ! -n $(grep "$gem_file_bat" <<< "${gems_list_sm[@]}") ]]; then
      diff_gems+=( "$gem_file_bat" )
    fi
  done

  if [[ -n $uninstall_alias ]]; then
    # Remove alias
    for gem_file_bat in $diff_gems; do
      if [[ -n $(alias | grep "${gem_file_bat%.bat}") ]]; then
        unalias "${gem_file_bat%.bat}"
      fi
    done
  else
    # Add alias
    for gem_file_bat in $diff_gems; do
      alias "${gem_file_bat%.bat}"="$ALF_RUBY_BIN/$gem_file_bat"
    done
  fi
  unset uninstall_alias
  unset gem_file_bat
  unset gems_list_sm
  unset gems_list_lg
  unset args_list
  unset curr_gems
  unset diff_gems
}



# Wrapper for gem command
# When executing "gem install" or "gem uninstall" the command will manage
# the gems associated aliases.
# --------------------------------------------------------------------------
gem() {
  local gem_file_bats=`_gem-list`
  "$ALF_RUBY_BIN/gem.bat" $@
  if [[ -n $(echo $1 | grep "install") ]]; then
    _gem-alias $1 "$gem_file_bats"
  fi
}

_gem-alias "install"
