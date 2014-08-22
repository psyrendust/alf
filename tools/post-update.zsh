#!/usr/bin/env zsh
#
# Post update script.
#
# This script will run once and then be discarded after execution.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------


# Create ZSH backup folder
# ------------------------------------------------------------------------------
export ALF_BACKUP_FOLDER="$ALF_BACKUP/$(date '+%Y%m%d')"
[[ -d "$ALF_BACKUP_FOLDER" ]] || mkdir -p "$ALF_BACKUP_FOLDER"



# Symlink our config and antigen folder if we are in a VM
# ------------------------------------------------------------------------------
_alf-fn-symlink-config() {
  if [[ -n $PLATFORM_IS_VM ]] && [[ -n $PLATFORM_IS_WIN ]]; then
    # Symlink our config folder to our host
    if [[ ! -d "$ALF_CONFIG" ]] || [[ -z $(readlink -f "$ALF_CONFIG" | grep "/cygdrive/z") ]]; then
      ln -sf "$ALF_HOST/config" "$ALF_CONFIG"
    fi
    # Symlink our repos folder to our host
    # if [[ ! -d "$ADOTDIR" ]] || [[ -z $(readlink -f "$ADOTDIR" | grep "/cygdrive/z") ]]; then
    #   ln -sf "$ALF_HOST/antigen" "$ADOTDIR"
    # fi
  fi
}



# Replace config/git
# ------------------------------------------------------------------------------
_alf-fn-replace-config-git() {
  cp -aR "$ALF_SRC_TEMPLATES_CONFIG/git/." "$ALF_CONFIG_GIT/"
}



# Replace config/win
# ------------------------------------------------------------------------------
_alf-fn-replace-config-win() {
  cp -aR "$ALF_SRC_TEMPLATES_CONFIG/win/." "$ALF_CONFIG_WIN/"
}



# Restart shell, and kill the current alf process status
# ------------------------------------------------------------------------------
_alf-fn-source-shell() {
  if [[ -f "$ALF_VERSION/alf.info" ]]; then
    # Remove the previous version file so that it can get recreated after
    # the shell restarts
    rm "$ALF_VERSION/alf.info"
  fi
  {
    sleep 1
    process -x "$alf_fn_script_namespace"
    alf restartshell
  } &!
}



# Waiting for shell restart completion
# ------------------------------------------------------------------------------
_alf-fn-waiting() {
  sleep 5
}



# Migrate any legacy gitconfig-includes
# ------------------------------------------------------------------------------
_alf-fn-migrate-existing-gitconfig-includes() {
  if [[ -d "$HOME/.gitconfig-includes" ]]; then
    mv "$HOME/.gitconfig-includes" "$ALF_BACKUP_FOLDER/.gitconfig-includes"
  fi
}



# Install .gitconfig
# ------------------------------------------------------------------------------
_alf-fn-update-gitconfig() {
  [[ -f "$HOME/.gitconfig" ]] && mv "$HOME/.gitconfig" "$ALF_BACKUP_FOLDER/.gitconfig"
  if [[ -n $PLATFORM_IS_CYGWIN ]]; then
    local platform_os="win"
  else
    local platform_os="mac"
  fi
  cp -aR "$ALF_SRC_TEMPLATES/home-${platform_os}/." "$HOME/"
}



# Install git config templates
# ------------------------------------------------------------------------------
_alf-fn-install-git-config-templates() {
  if [[ -z $PLATFORM_IS_VM ]]; then
    # Replace git configs
    cp -aR "$ALF_SRC_TEMPLATES_CONFIG/git/." "$ALF_CONFIG_GIT/"
    cp -an "$ALF_SRC_TEMPLATES_CONFIG/blank/custom-"{mac,win}.gitconfig "$ALF_CONFIG_GIT/"
  fi
}



# Check to see if config/git/user has been created
# ------------------------------------------------------------------------------
_alf-fn_alf-updates() {
  cp -an "$ALF_SRC_TEMPLATES_CONFIG/blank/user.gitconfig" "$ALF_CONFIG_GIT/user.gitconfig"
}



# Check to see if a Git global user.name has been set
# ------------------------------------------------------------------------------
_alf-fn-git-user-name() {
  alf_config_git_user="$ALF_CONFIG_GIT/user.gitconfig"
  if [[ -d $ALF_DOT ]] && [[ $(git config user.name) == "" ]]; then
    echo
    ppinfo -i "We need to configure your "
    pplightpurple "Git Global user.name"
    ppinfo -i "Please enter your first and last name ["
    pplightpurple -i "Firstname Lastname"
    ppinfo -i "]: "
    read git_user_name_first git_user_name_last
    echo "  name = ${git_user_name_first} ${git_user_name_last}" >> "$alf_config_git_user"
    ppinfo -i "Git config user.name saved to: "
    pplightcyan "$alf_config_git_user"
    unset git_user_name_first
    unset git_user_name_last
    echo
  fi
}



# Check to see if a Git global user.email has been set
# ------------------------------------------------------------------------------
_alf-fn-git-user-email() {
  alf_config_git_user="$ALF_CONFIG_GIT/user.gitconfig"
  # Check to see if a Git global user.email has been set
  if [[ -d $ALF_DOT ]] && [[ $(git config user.email) == "" ]]; then
    echo
    ppinfo -i "We need to configure your "
    pplightpurple "Git Global user.email"
    ppinfo -i "Please enter your work email address ["
    pplightpurple -i "first.last@domain.com"
    ppinfo -i "]: "
    read git_user_email
    echo "  email = ${git_user_email}" >> "$alf_config_git_user"
    ppinfo -i "Git config user.email saved to: "
    pplightcyan "$alf_config_git_user"
    unset git_user_email
    echo
  fi
}
