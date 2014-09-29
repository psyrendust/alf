#!/usr/bin/env zsh
#
# Executes file/folder creation, login message, and should not change the shell.
#
# Author:
#   Larry Gordon
#
# Execution Order
#   https://github.com/psyrendust/alf/templates/home
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------
# Make these aliases, plugins, and functions available in all login shells
# ------------------------------------------------------------------------------
source "$ALF_SRC_PLUGINS/utilities/init.zsh" 2>/dev/null
source "$ALF_SRC_PLUGINS/system/init.zsh" 2>/dev/null
source "$ALF_SRC_PLUGINS/sugar/init.zsh" 2>/dev/null
source "$ALF_SRC_PLUGINS/sublime/init.zsh" 2>/dev/null



# Load Custom aliases and key bindings (useful if you want to override Alf's defaults)
source "$ALF_CUSTOM_ALIASES" 2>/dev/null
source "$ALF_CUSTOM_KEY_BINDINGS" 2>/dev/null



# ------------------------------------------------------------------------------
# RUN A FEW THINGS AFTER OH MY ZSH HAS FINISHED INITIALIZING
# ------------------------------------------------------------------------------
if [[ -n $PLATFORM_IS_CYGWIN ]]; then
  # Install gem helper aliases in the background
  if [[ -n "$(which ruby 2>/dev/null)" ]]; then
    source "$ALF_SRC_PLUGINS/cygwin-gem/init.zsh" 2>/dev/null
  fi

  # If we are using Cygwin and ZSH_THEME is Pure, then replace the prompt
  # character to something that works in Windows
  if [[ $ZSH_THEME == "pure" ]] || [[ $ALF_THEME = "sindresorhus/pure" ]]; then
    PROMPT=$(echo $PROMPT | tr "❯" "›")
  fi
fi



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
# ------------------------------------------------------------------------------
# Settings for zsh-syntax-highlighting plugin
# ------------------------------------------------------------------------------
if [[ -n "${ZSH_HIGHLIGHT_STYLES+x}" ]]; then
  # Define syntax highlighters
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(
    main
    brackets
    pattern
    cursor
    root
  )

  # Set highlighting styles
  ZSH_HIGHLIGHT_STYLES[default]='none'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
  ZSH_HIGHLIGHT_STYLES[reserved-word]='yellow,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
  ZSH_HIGHLIGHT_STYLES[command]='fg=green'
  ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=green'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
  ZSH_HIGHLIGHT_STYLES[function]='fg=green'
  ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[assign]='fg=magenta,bold'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta,bold'
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=magenta'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=cyan,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[path_approx]='fg=blue,bold'
  ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=blue,bold'
fi



# Don't run auto update if it's been disabled
# ------------------------------------------------------------------------------
if [[ ! -n $ALF_DISABLE_AUTO_UPDATE ]]; then

  # Load up the last run for auto-update
  # ----------------------------------------------------------------------------
  _alf-epoch --set
  alf_au_last_epoch_default=$(_alf-epoch --get)
  alf_au_last_epoch_auto_update=$(_alf-epoch --get "auto-update")
  alf_au_last_epoch_diff=$(( $alf_au_last_epoch_default - $alf_au_last_epoch_auto_update ))

  # See if we ran this today already
  # ----------------------------------------------------------------------------
  if [[ ${alf_au_last_epoch_diff} -gt $ALF_UPDATE_DAYS ]]; then
    # Run antigen self-update then update all bundles
    # --------------------------------------------------------------------------
    printf '\n\033[0;32m%s\033[0m' "Executing antigen selfupdate: "; \
    typeset -a _repos; \
    antigen selfupdate | while read -r line; do printf '\033[0;32m▍\033[0m'; done; \
    printf '\n\033[0;32m%s\033[0m' "Executing antigen update: "; \
    antigen update | while read -r line; do printf '\033[0;32m▍\033[0m'; done;
    printf '\n'

    # Update version number
    # --------------------------------------------------------------------------
    __alf-version --set

    # Update last epoch
    # --------------------------------------------------------------------------
    _alf-epoch --set "auto-update"
  fi
  # Run any post-update scripts if they exist
  # ----------------------------------------------------------------------------
  # run-once
  unset alf_au_last_epoch_default
  unset alf_au_last_epoch_auto_update
  unset alf_au_last_epoch_diff

fi



unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles



# Output Alf's current version number
_alf_startup_time_end=$(__alf-gettime)
_alf_startup_time_diff=" \033[1;35m$(__alf-gettimediff $_alf_startup_time_end $_alf_startup_time_begin)\033[0m"
alf --version



{
  # Compile the completion dump to increase startup speed in the background.
  zcompdump="$HOME/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
  # Figure out the SHORT hostname
  if [ -n "$commands[scutil]" ]; then
    # OS X
    SHORT_HOST=$(scutil --get ComputerName)
  else
    SHORT_HOST=${HOST/.*/}
  fi
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
  # Also compile the completion dump that is generated by oh-my-zsh.
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!
