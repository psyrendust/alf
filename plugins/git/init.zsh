#!/usr/bin/env zsh
#
# Custom git aliases
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

alias gffstart='git flow feature start'
compdef _git gffstart=git-flow-feature-start

alias gfffinish='git flow feature finish'
compdef _git gfffinish=git-flow-feature-finish

alias gfrstart='git flow release start'
compdef _git gfrstart=git-flow-release-start

alias gfrfinish='git flow release finish'
compdef _git flowrf=git-flow-release-finish

alias gfhstart='git flow hotfix start'
compdef _git gfhstart=git-flow-hotfix-start

alias gfhfinish='git flow hotfix finish'
compdef _git gfhfinish=git-flow-hotfix-finish

alias gs='git status'
compdef _git gs=git-status

alias gass='git update-index --assume-unchanged'
compdef _git gass=git-update-index

alias gaa='git add -A'
compdef _git gaa=git-add

alias gun='git reset && git checkout . && git clean -fdx'
compdef _git gun=git-reset

alias gtag='git tag'
compdef _git gtag=git-tag

alias gtaga='git tag -a'
compdef _git gtaga=git-tag

alias gbdel='_git-branch-delete'
compdef _git gbdel=git-branch-D

alias gbfromhere='_git-branch-from-here'
compdef _git gbromhere=git-checkout-b

alias gcob='_git-checkout-branch'
compdef _git gcob=git-checkout-b

alias gcobu='_git-checkout-branch upstream'
compdef _git gcob=git-checkout-b

alias gm='git merge'
compdef _git gm=git-merge

alias gmfrom='_git-merge-from'
compdef _git gmfrom=git-merge

alias gmfromorigin='_git-merge-from-origin'
compdef _git gmfromorigin=git-merge-origin

alias gmfromupstream='_git-merge-from-upstream'
compdef _git gmfromupstream=git-merge-upstream

alias gmfromroot='_git-merge-from-root'
compdef _git gmfromroot=git-merge-root

alias gmclean='_git-merge-clean'
compdef _git gmclean=git-rm

alias gsdel='_git-stash-delete'
compdef _git gsdel=git-stash

alias gfo='git fetch origin'
compdef _git gfo=git-fetch-origin

alias gfu='git fetch upstream'
compdef _git gfu=git-fetch-upstream

alias gfr='git fetch root'
compdef _git gfr=git-fetch-root

alias ggpullr='git pull root $(current_branch)'
compdef _git ggpullr=git-pull-root

alias ggpullu='git pull upstream $(current_branch)'
compdef _git ggpullu=git-pull-upstream

alias ggpullo='git pull origin $(current_branch)'
compdef _git ggpullo=git-pull-origin

alias ggpushr='git push root $(current_branch)'
compdef _git ggpushr=git-push-root

alias ggpushu='git push upstream $(current_branch)'
compdef _git ggpushu=git-push-upstream

alias ggpusho='git push origin $(current_branch)'
compdef _git ggpusho=git-push-origin

alias gcleanindex='_git-clean-index'
compdef _git gcleanindex=git-rm-cached-r

alias gl='_git-log-pretty-grep'
compdef _git glg=git-log-pretty

alias glb='_git-log-pretty-grep-begin'
compdef _git glg=git-log-pretty

alias gls='_git-log-pretty-grep-begin-sublime'
compdef _git glg=git-log-pretty

alias gcundo='git reset --soft HEAD~1'
compdef _git gcundo=git-reset-soft-head

# alias gfupdate='git-flow-update'

function _current_branch() {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

function _git-branch-from-here() {
  git checkout -b $1 $(current_branch)
}

function _git-branch-delete() {
  while getopts ":s" opt; do
    [[ $opt == "s" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift
    for branch in $(git branch | egrep "^[ ]+$@" | sed -e 's/ //g' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"); do
      git branch -D $branch
    done
  else
    git branch -D $@
  fi
}

# git checkout remote branch and track it
function _git-checkout-branch() {
  if [[ "$#" -ne 2 ]]; then
    git checkout -b $1 origin/$1
  else
    git checkout -b $2 $1/$2
  fi
}

# update target branch and merge it into current branch
function _git-merge-from() {
  current_branch=$(current_branch)
  target_branch=$1
  echo "switching to branch $target_branch"
  gco -f $target_branch
  echo "updating branch $target_branch"
  ggpull
  echo "switching to branch $current_branch"
  gco -f $current_branch
  echo "stashing any changes"
  gsdel
  echo "merging $target_branch into $current_branch"
  git merge $target_branch
}

# update branch from origin and merge it into current branch
function _git-merge-from-origin() {
  current_branch=$(current_branch)
  echo "fetching from origin $1"
  gfo $1:$1
  echo "merging origin $1 into $current_branch"
  git merge $1
}

# update branch from upstream and merge it into current branch
function _git-merge-from-upstream() {
  current_branch=$(current_branch)
  echo "fetching from upstream $1"
  gfu $1:$1
  echo "merging upstream $1 into $current_branch"
  git merge $1
}

# update branch from root and merge it into current branch
function _git-merge-from-root() {
  current_branch=$(current_branch)
  echo "fetching from upstream $1"
  gfr $1:$1
  echo "merging root $1 into $current_branch"
  git merge $1
}

# clean up and remove any *.orig files created from a merge conflict
function _git-merge-clean() {
  find $(git rev-parse --show-toplevel) -type f -name \*.orig -exec rm -f {} \;
}

# create a stash and delete it
function _git-stash-delete() {
  # Let's make sure there is something to stash
  command git diff --quiet --ignore-submodules HEAD &>/dev/null;
  (($? == 1)) && git stash save && git stash drop stash@{0};
}

# remove everything from the index and then write both the index and the
# working directory from git's database.
function _git-clean-index() {
  echo "Working, please be patient..."
  local current_location=$PWD
  if [ $# -eq 0 ]; then
    cd $(git rev-parse --show-toplevel)
  else
    cd $1
  fi
  git rm --cached -r .
  git clean -fdx
  git reset HEAD --hard
  git add .
  cd "$current_location"
}

function _git-log-pretty-grep() {
  git log --pretty=format:'%s' -i --grep='$(1)'
}

function _git-log-pretty-grep-begin() {
  git log --pretty=format:'%s' -i --grep='^$1'
}

function _git-log-pretty-grep-begin-sublime() {
  git log --pretty=format:'%s' -i --grep='^$1'
}

# Workaround for fmt-merge-msg issue on Mavericks w/SMB repo
# gfm [<remote>] [<remote branch>]
function _git-fetch-merge() {
  local remote="$1"
  local branch="$2"
  local tmp_branch="${2}_merge_tmp"
  git fetch $remote $branch:$tmp_branch
  git merge $tmp_branch
  git branch -D $tmp_branch
}
alias gfm="_git-fetch-merge"
