#!/usr/bin/env zsh
#
# git post-merge hook
#
# Always run the latest post-update.zsh script after a successful merge has
# completed.
#
# The run-once script contained within the Alf repo will look for a file
# within $ALF_RUN_ONCE/ that has "run-once" in it's file name. This post-merge
# script will copy the latest version of the post-update.zsh script to that
# location so that it will run the next time an interactive login shell is
# instantiated.
#
# Authors:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# Print pretty colors to stdout in Cyan.
ppinfo() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;36m%s\033[0m' "$@"
  else
    printf '\033[0;36m%s\033[0m\n' "$@"
  fi
}

# Print pretty colors to stdout in Red.
ppdanger() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;31m%s\033[0m' "$@"
  else
    printf '\033[0;31m%s\033[0m\n' "$@"
  fi
}

local git_dir repo_root repo_name files_list

if [[ "$1" == "true" ]]; then
  git_dir="$(cd -P ${0:h} && pwd)"
elif [ -z "$GIT_DIR" ]; then
  # --- Safety check
  ppdanger -i "post-merge hook: Don't run this script from the command line." >&2
  ppdanger -i " (if you want, you could supply GIT_DIR then run" >&2
  ppdanger -i "  $0)" >&2
  exit 1
else
  git_dir="$(pwd)"
fi
repo_root="$(git rev-parse --show-toplevel)"
repo_name="${repo_root:t}"

files_list=($(git diff --name-status HEAD HEAD~1 | cut -f2))

for file in ${files_list[@]}; do
  if [[ -n $(echo $file | grep "post-merge.zsh") ]]; then
    ppinfo "post-merge hook: Update found for post-merge hook"
    if [[ -f "$repo_root/.git/hooks/post-merge-run-once.zsh" ]]; then
      ppinfo "post-merge hook: post-merge hook already up-to-date"
      rm "$repo_root/.git/hooks/post-merge-run-once.zsh"
    else
      ppinfo "post-merge hook: Updating post-merge hook"
      cp "$repo_root/git-hooks/post-merge.zsh" "$repo_root/.git/hooks/post-merge"
      touch "$repo_root/.git/hooks/post-merge-run-once.zsh"
      source "$repo_root/.git/hooks/post-merge" true
      return
    fi
  fi
done

if [[ -n "${ALF_RUN_ONCE+x}" ]] && [[ -d "$ALF_RUN_ONCE" ]]; then
  cp "$repo_root/tools/post-update.zsh" "$ALF_RUN_ONCE/post-update-run-once-${repo_name}.zsh" 2>/dev/null &&
  ppinfo "post-merge hook: Created run once script - $ALF_RUN_ONCE/post-update-run-once-${repo_name}.zsh" ||
  ppdanger "post-merge hook: There was an issue copying \"$repo_root/tools/post-update.zsh\" to \"$ALF_RUN_ONCE/post-update-run-once-${repo_name}.zsh\""
else
  ppdanger "post-merge hook: There was an issue with the environment var ALF_RUN_ONCE - $ALF_RUN_ONCE"
fi
