#!/usr/bin/env zsh
#
# Initialize Alf if loaded from Antigen.
#
# Authors:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------


# Copy over git post-merge hook, which will always run the latest post-update
# script after a successful merge. If the post-merge hook is not present, then
# we should run the post-upate script because we can assume that this is the
# first time that this repo has been checked out.
{
  # Run this in a background subshell so that we don't slow down our current
  # shell's environment.
  # ----------------------------------------------------------------------------
  if [[ ! -f "$ALF_SRC/.git/hooks/post-merge" ]]; then
    cp "$ALF_SRC/git-hooks/post-merge.zsh" "$ALF_SRC/.git/hooks/post-merge" &&
    export GIT_DIR=$(cd $ALF_SRC && git rev-parse --show-toplevel)
    source "$ALF_SRC/.git/hooks/post-merge" true
  fi
} &!
