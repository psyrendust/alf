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

_alf_startup_time_begin=$(/usr/local/bin/gdate +%s%N)
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
  if [[ -f "/cygdrive/z/.zshrc" ]]; then
    export PLATFORM_IS_VM=1
    export ALF_HOST="/cygdrive/z/.alf"
  fi

elif [[ $('uname') == *MINGW* ]]; then
  # We are using Git Bash in Windows
  export PLATFORM_IS_MINGW32=1
  if [[ -f "/c/cygwin64/z/.zshrc" ]]; then
    export PLATFORM_IS_VM=1
    export ALF_HOST="/c/cygwin64/z/.alf"
  fi
  if [[ -d "/c/cygwin64/c/cygwin64/home" ]]; then
    alf_user=`whoami`
    export HOME="/c/cygwin64/c/cygwin64/home/${alf_user##*\\}"
    unset alf_user
  fi
  return

elif [[ $('uname') == *Linux* ]]; then
  # We are using Linux
  export PLATFORM_IS_LINUX=1
fi
# Add support for all systems
export PLATFORM_IS_ALL=1



# ------------------------------------------------------------------------------
# Alf settings
# ------------------------------------------------------------------------------
# Uncomment to change how often before auto-updates occur for Alf? (in days)
export ALF_UPDATE_DAYS=1

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
# Define plugins to load into oh-my-zsh
# ------------------------------------------------------------------------------
# An array of plugins to load. Each value can contain a colon separated list.
# The first parameter should be the platform type (optional). The 2nd parameter
# should be the plugins name.
#
# Usage:
#   '[plugin name]'
#   '[os type]:[plugin name]'
#
# OS in which to install the plugin.
#   ALL:    All system types
#   MAC:    Mac OS X
#   LINUX:  Linux
#   CYGWIN: Windows running Cygwin
#   VM:     Windows running in a VM
#
zstyle ':alf:load:plugins:default' plugins \
  '#  :alf plugins' \
  'ALL:alias-grep' \
  'ALL:git' \
  'ALL:grunt-autocomplete' \
  'ALL:migrate' \
  'ALL:mkcd' \
  'ALL:refresh' \
  'MAC:apache2' \
  '#  :oh-my-zsh plugins' \
  'ALL:bower' \
  'ALL:colorize' \
  'ALL:copydir' \
  'ALL:copyfile' \
  'ALL:cp' \
  'ALL:encode64' \
  'ALL:extract' \
  'ALL:gem' \
  'ALL:git' \
  'ALL:git-flow-avh' \
  'ALL:gitfast' \
  'ALL:history' \
  'ALL:node' \
  'ALL:npm' \
  'ALL:ruby' \
  'ALL:systemadmin' \
  'ALL:urltools' \
  'MAC:brew' \
  'MAC:osx'



# ------------------------------------------------------------------------------
# Define plugins to load into Antigen
# ------------------------------------------------------------------------------
zstyle ':alf:antigen:all' bundles \
  'fasd' \
  '$ALF_URL $ALF_BRANCH' \
  '$ALF_URL $ALF_BRANCH plugins/colored-man' \
  '$ALF_THEME' \
  'zsh-users/zaw' \
  'zsh-users/zsh-completions src' \
  'zsh-users/zsh-syntax-highlighting' \
  'zsh-users/zsh-history-substring-search' \

# zstyle ':alf:antigen:mac' bundles \
# zstyle ':alf:antigen:linux' bundles \
# zstyle ':alf:antigen:cygwin' bundles \
# zstyle ':alf:antigen:vm' bundles \



# ------------------------------------------------------------------------------
# Define syntax highlighters
# ------------------------------------------------------------------------------
zstyle ':alf:module:syntax-highlighting' highlighters \
  'main' \
  'brackets' \
  'pattern' \
  'cursor' \
  'root'

# Set syntax highlighting styles.
# ------------------------------------------------------------------------------
#                        default: parts of the buffer that do not match anything (default: none)
#                  unknown-token: unknown tokens / errors (default: fg=red,bold)
#                  reserved-word: shell reserved words (default: fg=yellow)
#                          alias: aliases (default: fg=green)
#                        builtin: shell builtin commands (default: fg=green)
#                        command: commands (default: fg=green)
#               commandseparator: command separation tokens (default: none)
#                     precommand: precommands (i.e. exec, builtin, ...) (default: fg=green,underline)
#                       function: functions (default: fg=green)
#                 hashed-command: hashed commands (default: fg=green)
#           single-hyphen-option: single hyphen options (default: none)
#           double-hyphen-option: double hyphen options (default: none)
#                         assign: variable assignments (default: none)
#                       globbing: globbing expressions (default: fg=blue)
#  dollar-double-quoted-argument: dollar double quoted arguments (default: fg=cyan)
#         single-quoted-argument: single quoted arguments (default: fg=yellow)
#         double-quoted-argument: double quoted arguments (default: fg=yellow)
#           back-quoted-argument: backquoted expressions (default: none)
#    back-double-quoted-argument: back double quoted arguments (default: fg=cyan)
#              history-expansion: history expansion expressions (default: fg=blue)
#                           path: paths (default: underline)
#                    path_approx: approximated paths (default: fg=yellow,underline)
#                    path_prefix: path prefixes (default: underline)
zstyle ':alf:module:syntax-highlighting' styles \
  'default' 'none' \
  'unknown-token' 'fg=red,bold' \
  'reserved-word' 'yellow,bold' \
  'alias' 'fg=green' \
  'builtin' 'fg=green' \
  'command' 'fg=green' \
  'commandseparator' 'fg=green' \
  'precommand' 'fg=green' \
  'function' 'fg=green' \
  'hashed-command' 'fg=green' \
  'single-hyphen-option' 'fg=green,bold' \
  'double-hyphen-option' 'fg=green,bold' \
  'assign' 'fg=magenta,bold' \
  'globbing' 'fg=magenta,bold' \
  'dollar-double-quoted-argument' 'fg=magenta' \
  'single-quoted-argument' 'fg=blue,bold' \
  'double-quoted-argument' 'fg=blue,bold' \
  'back-quoted-argument' 'fg=cyan,bold' \
  'back-double-quoted-argument' 'fg=cyan,bold' \
  'history-expansion' 'fg=cyan,bold' \
  'path' 'fg=blue,bold' \
  'path_approx' 'fg=blue,bold' \
  'path_prefix' 'fg=blue,bold'


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
  if [[ ! -d $default_path ]]; then
    mkdir -p "$default_path"
  fi
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
# Set paths for nvm and rvm executables
# ------------------------------------------------------------------------------
# Init nvm
# source "$HOME/.nvm/nvm.sh" 2>/dev/null

# Init rvm
# Zsh & RVM woes (rvm-prompt doesn't resolve)
# http://stackoverflow.com/questions/6636066/zsh-rvm-woes-rvm-prompt-doesnt-resolve
source "$HOME/.rvm/scripts/rvm" 2>/dev/null



# ------------------------------------------------------------------------------
# Set the location of Alf's aliases and keybindings that will be loaded
# in ~/.zlogin. This can later be overridden in a users custom ~/.zshrcwork
# or ~/.zshrcuser file.
# ------------------------------------------------------------------------------
export ALF_CUSTOM_ALIASES="$ALF_SRC_PLUGINS/aliases/init.zsh"
export ALF_CUSTOM_KEY_BINDINGS="$ALF_SRC_PLUGINS/key-bindings/init.zsh"



# ------------------------------------------------------------------------------
# Source Antigen and oh-my-zsh to get things started
# ------------------------------------------------------------------------------
source "$ADOTDIR/antigen.zsh"


# ------------------------------------------------------------------------------
# Make these aliases, plugins, and functions available in all shells
# ------------------------------------------------------------------------------
source "$ALF_SRC_PLUGINS/utilities/init.zsh" 2>/dev/null
source "$ALF_SRC_PLUGINS/system/init.zsh" 2>/dev/null
source "$ALF_SRC_PLUGINS/sublime/init.zsh" 2>/dev/null
source "$ALF_SRC_PLUGINS/sugar/init.zsh" 2>/dev/null
if [[ -n $PLATFORM_IS_CYGWIN ]]; then
  source "$ALF_SRC_PLUGINS/cygwin-gem/init.zsh" 2>/dev/null
fi
