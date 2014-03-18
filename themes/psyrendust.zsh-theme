#!/usr/bin/env zsh
#
# Psyrendust prompt theme for Zsh.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}|"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%}|"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✓"

function __alf-prompt-ruby-version {
  # Grab the current version of ruby in use (via RVM): [ruby-1.8.7]
  if [ -e ~/.rvm/bin/rvm-prompt ]; then
    local ALF_CURRENT_RUBY="%{$fg[yellow]%}|\$(~/.rvm/bin/rvm-prompt)|%{$reset_color%}"
  else
    if which rbenv &> /dev/null; then
      local ALF_CURRENT_RUBY="%{$fg[yellow]%}|\$(rbenv version | sed -e 's/ (set.*$//')|%{$reset_color%}"
    fi
  fi
  echo $ALF_CURRENT_RUBY
}
function __alf-prompt-scm-char {
  # Setup some SCM characters
  local ALF_SCM=''
  local ALF_SCM_GIT='git'
  local ALF_SCM_GIT_CHAR='±'
  local ALF_SCM_HG='hg'
  local ALF_SCM_HG_CHAR='☿'
  local ALF_SCM_SVN='svn'
  local ALF_SCM_SVN_CHAR='⑆'
  local ALF_SCM_NONE='NONE'
  local ALF_SCM_NONE_CHAR='○'
  # Get the current SCM
  if [[ -f .git/HEAD ]]; then ALF_SCM=$ALF_SCM_GIT
  elif [[ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]]; then ALF_SCM=$ALF_SCM_GIT
  elif [[ -d .hg ]]; then ALF_SCM=$ALF_SCM_HG
  elif [[ -n "$(hg root 2> /dev/null)" ]]; then ALF_SCM=$ALF_SCM_HG
  elif [[ -d .svn ]]; then ALF_SCM=$ALF_SCM_SVN
  else ALF_SCM=$ALF_SCM_NONE
  fi

  # Get the SCM character
  if [[ $ALF_SCM == $ALF_SCM_GIT ]]; then ALF_SCM_CHAR=$ALF_SCM_GIT_CHAR
  elif [[ $ALF_SCM == $ALF_SCM_HG ]]; then ALF_SCM_CHAR=$ALF_SCM_HG_CHAR
  elif [[ $ALF_SCM == $ALF_SCM_SVN ]]; then ALF_SCM_CHAR=$ALF_SCM_SVN_CHAR
  else ALF_SCM_CHAR=$ALF_SCM_NONE_CHAR
  fi
  echo $ALF_SCM_CHAR
}
function ALF_PROMPT_LINE_1 {
  local ALF_CURRENT_USER="%{$fg[magenta]%}%m%{$reset_color%}"   # Grab the current machine name
  local IN="%{$fg[white]%}in%{$reset_color%}"               # Just some text
  local ALF_CURRENT_PATH="%{$fg[green]%}%~"                     # Grab the current file path
  echo "$(__alf-prompt-ruby-version) $ALF_CURRENT_USER $IN $ALF_CURRENT_PATH"
}

function ALF_PROMPT_LINE_2 {
  echo "%{$fg_bold[cyan]%}\$(__alf-prompt-scm-char)%{$reset_color%}\$(git_prompt_info)%{$fg[green]%} →%{$reset_color%} "
  # echo "%{$fg_bold[cyan]%}\$(__alf-prompt-scm-char)%{$reset_color%}\$(_alf_git_prompt_info)%{$fg[green]%} →%{$reset_color%} "
}

PROMPT="
$(ALF_PROMPT_LINE_1)
$(ALF_PROMPT_LINE_2)"

