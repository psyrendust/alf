#!/usr/bin/env zsh
#
# Zsh tab completion for GruntJS.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

if [[ -n ${ZSH_VERSION-} ]]; then
  autoload -U +X bashcompinit && bashcompinit
fi

# Enable bash autocompletion.
function _grunt-completions() {
  # The currently-being-completed word.
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The current grunt version, available tasks, options, etc.
  local gruntinfo="$(grunt --version --verbose 2>/dev/null)"
  # Options and tasks.
  local opts="$(echo "$gruntinfo" | awk '/Available options: / {$1=$2=""; print $0}')"
  local compls="$(echo "$gruntinfo" | awk '/Available tasks: / {$1=$2=""; print $0}')"
  # Only add -- or - options if the user has started typing -
  [[ "$cur" == -* ]] && compls="$compls $opts"
  # Tell complete what stuff to show.
  COMPREPLY=($(compgen -W "$compls" -- "$cur"))
}
complete -o default -F _grunt-completions grunt
