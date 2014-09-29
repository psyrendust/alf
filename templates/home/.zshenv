#!/usr/bin/env zsh
#
# Define environment variables for login, non-login, interactive and
# non-interactive shells.
#
# Authors:
#   Larry Gordon
#
# Execution Order
#   https://github.com/psyrendust/alf/templates/home
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Small helper function to process startup time
# ------------------------------------------------------------------------------
__alf-gettime() {
  perl <<EOF
use Time::HiRes qw(time);
print time;
EOF
}
__alf-gettimediff() {
  perl <<EOF
print sprintf('%.0f', ($1 - $2)*1000), "ms";
EOF
}
_alf_startup_time_begin="$(__alf-gettime)"

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
export ZSH_UNAME=`uname`

if [[ $ZSH_UNAME == *Darwin* ]]; then
  # We are using OS X
  export PLATFORM_IS_MAC=1

elif [[ $ZSH_UNAME == *CYGWIN* ]]; then
  # We are using Cygwin in Windows
  export PLATFORM_IS_CYGWIN=1
  # We are also in a virtualized Windows environment
  if [[ -f "/cygdrive/z/.zshrc.lnk" ]]; then
    export PLATFORM_IS_VM=1
    export ALF_HOST="/cygdrive/z/.alf"
  fi

elif [[ $ZSH_UNAME == *Linux* ]]; then
  # We are using Linux
  export PLATFORM_IS_LINUX=1
fi
# Add support for all systems
export PLATFORM_IS_ALL=1



# ------------------------------------------------------------------------------
# Alf settings
# ------------------------------------------------------------------------------
# Uncomment to change how often before auto-updates occur for Alf? (in days)
export ALF_UPDATE_DAYS=60

# Set name of the theme to load using `Antigen theme`
export ALF_THEME="sindresorhus/pure"

# Uncomment this to enable verbose output for Alf related scripts
# export ALF_PRETTY_PRINT_VERBOSE=1

# Uncomment this to disable auto-update checks for Alf
# export ALF_DISABLE_AUTO_UPDATE="true"

# Uncomment this to set your own custom right prompt id
export ALF_CONFIG_PRPROMPT_ID="%F{magenta}[ Alf ]%f"



# ------------------------------------------------------------------------------
# Oh My Zsh settings
# ------------------------------------------------------------------------------
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="pure"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"



# ------------------------------------------------------------------------------
# Define Alf PATH globals
# ------------------------------------------------------------------------------
export ALF_CUSTOM="$HOME/.alf"
export ADOTDIR="$ALF_CUSTOM/antigen"
export ALF_URL="https://github.com/psyrendust/alf.git"
export OMZ_URL="https://github.com/robbyrussell/oh-my-zsh.git"
zstyle ':alf:paths:default' paths \
  'BACKUP' '$ALF_CUSTOM/backup' \
  'CONFIG' '$ALF_CUSTOM/config' \
  'CONFIG_GIT' '$ALF_CUSTOM/config/git' \
  'CONFIG_SSH' '$ALF_CUSTOM/config/ssh' \
  'CONFIG_WIN' '$ALF_CUSTOM/config/win' \
  'EPOCH' '$ALF_CUSTOM/epoch' \
  'LOGR' '$ALF_CUSTOM/logr' \
  'PROCESS' '$ALF_CUSTOM/process' \
  'RPROMPT' '$ALF_CUSTOM/rprompt' \
  'RUN_ONCE' '$ALF_CUSTOM/run-once' \
  'SYMLINK' '$ALF_CUSTOM/symlink' \
  'UPDATES' '$ALF_CUSTOM/updates' \
  'VERSION' '$ALF_CUSTOM/version' \
  'GRUNT_INIT' '$HOME/.grunt-init'


zstyle ':alf:paths:src' paths \
  'SRC_FONTS' '$ALF_SRC/fonts' \
  'SRC_GIT_HOOKS' '$ALF_SRC/git-hooks' \
  'SRC_PLUGINS' '$ALF_SRC/plugins' \
  'SRC_TEMPLATES' '$ALF_SRC/templates' \
  'SRC_TEMPLATES_CONFIG' '$ALF_SRC/templates/config' \
  'SRC_THEMES' '$ALF_SRC/themes' \
  'SRC_TOOLS' '$ALF_SRC/tools'



# ------------------------------------------------------------------------------
# Configure PATHS for executables
# ------------------------------------------------------------------------------
typeset -a _alf_path_pre _alf_path_post _alf_manpath_pre _alf_manpath_post
# Add locally installed binaries for cabal
if [[ -d "$HOME/.cabal/bin" ]]; then
  _alf_path_pre+=("$HOME/.cabal/bin")
fi

# Add locally installed binaries (mostly from homebrew)
if [[ -d "/usr/local/bin" ]]; then
  _alf_path_pre+=("/usr/local/bin")
fi

if [[ -d "/usr/local/sbin" ]]; then
  _alf_path_pre+=("/usr/local/sbin")
fi

# Add homebrew installed binaries to PATH
if [[ -s "/usr/local/bin/brew" ]]; then
  # $(/usr/local/bin/brew --prefix coreutils)
  brew_coreutils="/usr/local/opt/coreutils"
  # $(/usr/local/bin/brew --prefix curl-ca-bundle)
  brew_curl_ca_bundle="/usr/local/opt/curl-ca-bundle"
  # $(/usr/local/bin/brew --prefix brew-cask)
  brew_curl_cask="/usr/local/opt/brew-cask"

  # Add homebrew Core Utilities
  if [[ -s "$brew_coreutils/libexec/gnubin" ]]; then
    _alf_path_pre+=("$brew_coreutils/libexec/gnubin")
  fi

  # Add manpath
  if [[ -s "/usr/local/share/man" ]]; then
    _alf_manpath_pre+=("/usr/local/share/man")
  fi

  # Add homebrew Core Utilities man
  if [[ -s "$brew_coreutils/libexec/gnuman" ]]; then
    _alf_manpath_pre+=("$brew_coreutils/libexec/gnuman")
  fi

  # Add SSL Cert
  if [[ -s "$brew_curl_ca_bundle/share/ca-bundle.crt" ]]; then
    export SSL_CERT_FILE="$brew_curl_ca_bundle/share/ca-bundle.crt"
  fi

  # Add brew-cask default options
  # OPTION              LOCATION                      DESCRIPTION
  # --appdir            /Applications                 Changes the path where the symlinks to the installed applications will be generated.
  # --binarydir         /usr/local/bin                Changes the path for binary symlinks.
  # --caskroom          /opt/homebrew-cask/Caskroom   Determines where the actual applications will be located.
  # --fontdir           ~/Library/Fonts               Changes the path for Fonts symlinks.
  # --input_methoddir   ~/Library/Input\ Methods      Changes the path for Input Methods symlinks.
  # --prefpanedir       ~/Library/PreferencePanes     Changes the path for PreferencePane symlinks.
  # --qlplugindir       ~/Library/QuickLook           Changes the path for Quicklook Plugin symlinks.
  # --screen_saverdir   ~/Library/Screen\ Savers      Changes the path for Screen Saver symlinks.
  # --widgetdir         ~/Library/Widgets             Changes the path for Dashboard Widget symlinks.
  if [[ -d "$brew_curl_cask" ]]; then
    export HOMEBREW_CASK_OPTS="--appdir=/Applications --binarydir=/usr/local/bin --caskroom=/opt/homebrew-cask/Caskroom --fontdir=~/Library/Fonts --input_methoddir=~/Library/Input\ Methods --prefpanedir=~/Library/PreferencePanes --qlplugindir=~/Library/QuickLook --screen_saverdir=~/Library/Screen\ Savers --widgetdir=~/Library/Widgets"
  fi
  unset brew_coreutils
  unset brew_curl_ca_bundle
  unset brew_curl_cask
fi



# ------------------------------------------------------------------------------
# Set PATHS for Alf
# ------------------------------------------------------------------------------
# Define Alf default paths
typeset -A alf_default_paths
zstyle -a ':alf:paths:default' paths 'alf_default_paths'
for alf_default_path in "${(k)alf_default_paths[@]}"; do
  eval "export ALF_${alf_default_path}=\"$alf_default_paths[$alf_default_path]\""
  default_path="$(eval "echo \"\$ALF_$alf_default_path\"")"
  {
    if [[ ! -d $default_path ]]; then
      mkdir -p "$default_path"
    fi
  } &!
  unset default_path
done
unset alf_default_paths{s,}


# Define a different branch for Alf, helpful for doing dev
[[ -s "$ALF_CONFIG/branch" ]] && export ALF_BRANCH="--branch=$(echo `cat $ALF_CONFIG/branch`)"
export ALF_SRC="$ADOTDIR/repos/$(__alf-get-antigen-clone-dir $ALF_URL $ALF_BRANCH)"
export ZSH="$ADOTDIR/repos/$(__alf-get-antigen-clone-dir $OMZ_URL)"
export ZSH_CUSTOM="$ALF_SRC"


# Define Alf src paths
typeset -A alf_src_paths
zstyle -a ':alf:paths:src' paths 'alf_src_paths'
for alf_src_path in "${(k)alf_src_paths[@]}"; do
  eval "export ALF_${alf_src_path}=\"$alf_src_paths[$alf_src_path]\""
done
unset alf_src_paths{s,}



# ------------------------------------------------------------------------------
# Set paths for Alf bin and manpath for plugins
# ------------------------------------------------------------------------------
_alf_path_pre+=("$ALF_SRC_PLUGINS/ksreview/bin")
_alf_path_pre+=("$ALF_SRC_PLUGINS/murder/bin")
_alf_path_pre+=("$ALF_SRC_PLUGINS/pretty-print/bin")
_alf_path_pre+=("$ALF_SRC_PLUGINS/process/bin")
_alf_path_pre+=("$ALF_SRC_PLUGINS/run-once/bin")

_alf_path_pre+=("$ALF_SRC_PLUGINS/logr/bin")
_alf_manpath_pre+=("$ALF_SRC_PLUGINS/logr/man")

_alf_path_pre+=("$ALF_SRC_PLUGINS/server/bin")
_alf_manpath_pre+=("$ALF_SRC_PLUGINS/server/man")

# Add PATH overrides for OS X
if [[ -n $PLATFORM_IS_MAC ]]; then
  _alf_path_pre+=("$ALF_SRC_PLUGINS/osx-ksreview/bin")
fi

# Add PATH overrides for Cygwin
if [[ -n $PLATFORM_IS_CYGWIN ]]; then
  _alf_path_pre+=("$ALF_SRC_PLUGINS/cygwin-kdiff3/bin")
  _alf_path_pre+=("$ALF_SRC_PLUGINS/cygwin-ln/bin")
fi



# ------------------------------------------------------------------------------
# Apply PATHS
# ------------------------------------------------------------------------------
export MANPATH="$([[ ${#_alf_manpath_pre} > 0 ]] && printf "%s:" "${_alf_manpath_pre[@]}")$MANPATH$([[ ${#_alf_manpath_post} > 0 ]] && printf ":%s" "${_alf_manpath_post[@]}")"
export PATH="$([[ ${#_alf_path_pre} > 0 ]] && printf "%s:" "${_alf_path_pre[@]}")$PATH$([[ ${#_alf_path_post} > 0 ]] && printf ":%s" "${_alf_path_post[@]}")"
unset _alf_path_pre
unset _alf_path_post
unset _alf_manpath_pre
unset _alf_manpath_post



# ------------------------------------------------------------------------------
# Set the location of Alf's aliases and keybindings that will be loaded
# in ~/.zlogin. This can later be overridden in a users custom ~/.zshrcwork
# or ~/.zshrcuser file.
# ------------------------------------------------------------------------------
export ALF_CUSTOM_ALIASES="$ALF_SRC_PLUGINS/aliases/init.zsh"
export ALF_CUSTOM_KEY_BINDINGS="$ALF_SRC_PLUGINS/key-bindings/init.zsh"



# A syntax sugar to avoid the `-` when calling alf commands. With this
# function, you can write `_alf-update` as `alf update` and so on.
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
alf() {
  local cmd="$1"
  if [[ $cmd == "--version" ]] || [[ $cmd == "-v" ]]; then
    __alf-version --get
    return
  elif [[ -z "$cmd" ]]; then
    echo 'Alf: Please give a command to run.' >&2
    return 1
  fi
  shift

  if functions "_alf-$cmd" > /dev/null; then
    "_alf-$cmd" "$@"
  else
    echo "Alf: Unknown command: $cmd" >&2
  fi
}



# ------------------------------------------------------------------------------
# Setup autocompletion for _alf-* functions
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
# ------------------------------------------------------------------------------
_alf-apply() {
  # Setup alf's own completion.
  compdef __alf-exec-compadd alf
}

# Setup alf's autocompletion
__alf-exec-compadd() {
  eval "compadd \
    $(echo $(print -l ${(k)functions} | grep "^_alf-" | sed "s/_alf-//g"))"
}
