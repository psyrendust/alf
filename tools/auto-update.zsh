#!/usr/bin/env zsh
#
# Process updates updates automatically.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------


# Log helper functions
# ------------------------------------------------------------------------------
function __alf-au-log() {
  plog "auto-update" "$1"
}

function __alf-au-log-error() {
  plog -e "auto-update" "$1"
}

function __alf-au-log-delete() {
  plog -d "auto-update"
}



# Git helper functions
# ------------------------------------------------------------------------------
function __alf-au-get-current-git-branch() {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

function __alf-au-get-current-git-remote-sha() {
  __alf-au-log "  - __alf-au-get-current-git-remote-sha"
  __alf-au-log "  - cd: ${1}"
  cd "${1}"
  result=$(git ls-remote $(git config remote.origin.url) HEAD 2>&1 | awk '{print $1}')
  __alf-au-log "  - result: $result"
  if [[ $result == *fatal* ]]; then
    __alf-au-log "  - result: is fatal"
  else
    __alf-au-log "  - result: success"
    echo $result
  fi
}

function __alf-au-set-current-git-sha() {
  cd "${1}"
  result="alf_au_current_local_sha=$(git rev-parse HEAD)"
  echo "$result" > "$ALF_UPDATE/current-sha-${2}"
}

function __alf-au-is-git-repo() {
  __alf-au-log "  - __alf-au-is-git-repo"
  __alf-au-log "  - cd: ${1}"
  cd "${1}"
  # check if we're in a git repo
  if [[ -d "./.git" ]]; then
    if [[ $(git rev-parse --is-inside-work-tree) == "true" ]]; then
      echo 1;
    fi
  fi
}

function __alf-au-git-cleanup() {
  __alf-au-log "  - __alf-au-git-cleanup"
  # check if it's dirty and reset it back to HEAD
  if [[ -n $(git diff --ignore-submodules HEAD) ]]; then
    __alf-au-log "  - git reset"
    # result=$(git reset HEAD --hard 2>&1)
    git reset HEAD --hard
  fi
}

function __alf-au-git-update() {
  __alf-au-log "  - __alf-au-is-git-update"
  # Check if the folder exists
  if [[ -d $1 ]]; then
    __alf-au-log "  - cd: ${1}"
    cd "${1}"
    __alf-au-git-cleanup
    result=git pull --rebase origin $(__alf-au-get-current-git-branch) 2>&1
    if [[ -n $result ]]; then
      __alf-au-log "  - git pull successful"
      echo 1
    fi
  fi
}



if [[ -n $(which __alf-rprompt | grep "not found") ]]; then
  alias __alf-rprompt="__alf-au-log-error \"__alf-rprompt not found\""
fi



# List repos we want to check and update
# ------------------------------------------------------------------------------
while getopts ":a" opt; do
  [[ $opt == "a" ]] && has_option=1
done
if [[ -n $has_option ]]; then
  repos=(
    "Alf"
    "Oh My Zsh"
    "User"
    "Work"
  )
else
  repos=(
    "Alf"
    "Oh My Zsh"
    "User"
    "Work"
  )
fi



# Reset logs
# ------------------------------------------------------------------------------
__alf-au-log-delete



# ------------------------------------------------------------------------------
# Get the show going!
# ------------------------------------------------------------------------------
# Don't process updates for CYGWIN if we are in Parallels. We are symlinking
# those folders to the this users home directory. Only run the post update
# scripts.
# ------------------------------------------------------------------------------
if [[ -n $PLATFORM_IS_VM ]]; then
  __alf-au-log "System is a VM"
else
  __alf-au-log "System is native"
fi
__alf-rprompt -p $(((${#repos}*6)+1))
# Check and see if we have internet first before continuing on
# ------------------------------------------------------------------------------
if [[ -n $(alf has-internet) ]]; then
  {
    sleep 1
    for repo in $repos; do
      __alf-au-log "[$repo] Processing"
      __alf-rprompt -P
      # Slow things down since we are only doing file copies
      [[ -n $PLATFORM_IS_VM ]] && sleep 1


      # Create local variables to hold the namespace and the repo's root
      # ------------------------------------------------------------------------
      alf_au_name_space="$(echo $repo | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
      for alf_au_git_root in $ALF_REPOS/{dev,frameworks,plugins,themes,tools}/$alf_au_name_space; do
        [[ -d $alf_au_git_root ]] && break
      done
      alf_au_last_repo_update="$ALF_UPDATE/current-sha-${alf_au_name_space}"
      alf_au_post_update="$alf_au_git_root/tools/post-update.zsh"
      alf_au_post_update_run_once="$ALF_RUN_ONCE/post-update-run-once-${alf_au_name_space}.zsh"
      __alf-au-log "[$repo] Creating alf_au_name_space=$alf_au_name_space"
      __alf-au-log "[$repo] Creating alf_au_git_root=$alf_au_git_root"
      __alf-au-log "[$repo] Creating alf_au_last_repo_update=$alf_au_last_repo_update"


      # Check if the repo folder exists
      # ------------------------------------------------------------------------
      if [[ -d $alf_au_git_root ]]; then
        __alf-au-log "[$repo] Folder exists"
        __alf-rprompt -P


        # Check if we are in a repo
        # ----------------------------------------------------------------------
        if [[ -n $PLATFORM_IS_VM ]] || [[ -n $(__alf-au-is-git-repo "$alf_au_git_root") ]]; then
          __alf-au-log "[$repo] Is a git repo"
          __alf-rprompt -P

          # Check if the last-repo-update file exists
          # --------------------------------------------------------------------
          if [[ -f "$alf_au_last_repo_update" ]]; then
            __alf-au-log "[$repo] Has $alf_au_last_repo_update"
          else
            # Set last repo update
            __alf-au-log "[$repo] Creating $alf_au_last_repo_update"
            __alf-au-set-current-git-sha "$alf_au_git_root" "$alf_au_name_space"
          fi
          source "$alf_au_last_repo_update"


          # Set the alf_au_current_local_sha if it doesn't exist
          # --------------------------------------------------------------------
          if [[ -z $PLATFORM_IS_VM ]] && [[ -z "$alf_au_current_local_sha" ]]; then
            __alf-au-log "[$repo] \$alf_au_current_local_sha does not exist"
            __alf-au-set-current-git-sha "$alf_au_git_root" "$alf_au_name_space";
            source "$alf_au_last_repo_update"
          fi

          if [[ -z $PLATFORM_IS_VM ]]; then
            __alf-au-log "[$repo] local SHA: $alf_au_current_local_sha"
          fi


          # Get the current remote SHA
          # --------------------------------------------------------------------
          if [[ -z $PLATFORM_IS_VM ]]; then
            alf_au_current_remote_sha=$(__alf-au-get-current-git-remote-sha $alf_au_git_root)
            __alf-au-log "[$repo] remote SHA: $alf_au_current_remote_sha"
          fi


          # Compare the local sha against the remote
          # --------------------------------------------------------------------
          if [[ -n $PLATFORM_IS_VM ]] || [[ $alf_au_current_local_sha != $alf_au_current_remote_sha ]]; then
            __alf-au-log "[$repo] Fetching updates..."
            __alf-rprompt -P
            if [[ -n $PLATFORM_IS_VM ]]; then
              alf_au_git_update_successful=1
            else
              alf_au_git_update_successful=$(__alf-au-git-update "$alf_au_git_root")
            fi

            if [[ -n $alf_au_git_update_successful ]]; then
              # Updates are complete
              # ----------------------------------------------------------------
              if [[ -f "$alf_au_post_update" ]]; then
                __alf-au-log "[$repo] Creating $alf_au_post_update_run_once"
                cp "$alf_au_post_update" "$alf_au_post_update_run_once"
                __alf-rprompt -P
              else
                __alf-au-log "[$repo] No post-update-run found"
                __alf-rprompt -w
              fi
              __alf-au-log "[$repo] Update successful"
              __alf-rprompt -P
              __alf-au-set-current-git-sha "$alf_au_git_root" "$alf_au_name_space"
              # Slow things down since we are only doing file copies
              [[ -n $PLATFORM_IS_VM ]] && sleep 1
            else
              __alf-au-log-error "[$repo] Update error"
              __alf-rprompt -E
              __alf-rprompt -E
            fi
            unset alf_au_git_update_successful
          else
            __alf-au-log "[$repo] Already up-to-date"
            __alf-rprompt -P
            __alf-rprompt -P
            __alf-rprompt -P
          fi
        else
          __alf-au-log "[$repo] Is not a git repo"
          __alf-rprompt -w
          __alf-rprompt -w
          __alf-rprompt -w
          __alf-rprompt -w
        fi
      else
        __alf-au-log "[$repo] Folder does not exist"
        __alf-rprompt -w
        __alf-rprompt -w
        __alf-rprompt -w
        __alf-rprompt -w
        __alf-rprompt -w
      fi
      unset alf_au_current_local_sha
      unset alf_au_current_remote_sha
      unset alf_au_git_root
      unset alf_au_last_repo_update
      unset alf_au_name_space
    done

    # echo out "string, " for each repo
    # results: "string1, string2, string3, "
    # Then use Substring Removal ${string%substring} to delete the shortest match from the end
    # Let's get rid of the trailing comma space ", " - ${string%", "}
    # results: "Checked repos: (string1, string2, string3)"
    __alf-au-log "Checked repos: (${$(for repo in $repos; do echo -n "$repo, "; done)%", "})"


    if [[ -s $alf_au_log_error ]]; then
      # Display an error message
      __alf-au-log "Display an error message"
      __alf-au-log "Errors were found!"
      __alf-au-log "See log for details...[Alf]"
      __alf-au-log "Error log: $alf_au_log_error"
      __alf-rprompt -E
      ppdanger "Errors were found!"
      ppdanger "Opening log for details...[Alf]"
      ppdanger "Error log: $alf_au_log_error"
      sbl $alf_au_log_error
    else
      # Display a success message
      __alf-au-log "Display a success message"
      __alf-au-log "All updates complete!"
      __alf-rprompt -P
    fi
    __alf-au-log "Closing __alf-rprompt"
    __alf-rprompt -x
    __alf-au-log "Sleep 1"
    sleep 1
    __alf-au-log "alf restartshell"
    alf restartshell
  } &!
else
  {
    # Just complete the progress because there is no internet
    # --------------------------------------------------------------------------
    __alf-rprompt -x
  } &!
fi

unfunction __alf-au-get-current-git-remote-sha
unfunction __alf-au-git-cleanup
unfunction __alf-au-git-update
unfunction __alf-au-is-git-repo
unfunction __alf-au-log
unfunction __alf-au-log-delete
unfunction __alf-au-log-error
unfunction __alf-au-set-current-git-sha
unset -m alf_au_current_local_sha
unset -m alf_au_current_remote_sha
unset -m alf_au_git_root
unset -m alf_au_git_update_successful
unset -m alf_au_last_epoch
unset -m alf_au_last_run
unset -m alf_au_log
unset -m alf_au_log_error
unset -m alf_au_name_space
