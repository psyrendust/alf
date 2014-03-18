#!/usr/bin/env zsh
#
# Script for bootstraping your shell environment.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# GET THE LOCATION OF THIS SCRIPT RELATIVE TO THE CWD
# ------------------------------------------------------------------------------
alf_migrate="$0"

# While the filename in $alf_migrate is a symlink
while [ -L "$alf_migrate" ]; do
  # similar to above, but -P forces a change to the physical not symbolic directory
  alf_migrate_cwd="$( cd -P "$( dirname "$alf_migrate" )" && pwd )"

  # Get the value of symbolic link
  # If $alf_migrate is relative (doesn't begin with /), resolve relative
  # path where symlink lives
  alf_migrate="$(readlink -f "$alf_migrate")" && alf_migrate="$alf_migrate_cwd/$alf_migrate"
done
alf_migrate_cwd="$( cd -P "$( dirname "$alf_migrate" )" && pwd )"
alf_migrate_root="${alf_migrate_cwd%/*}"


# ------------------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------------------
# Check if a formula is installed in homebrew
_brew-is-installed() {
  echo $(brew list 2>/dev/null | grep "^${1}$")
}

# Check if a cask application is installed
_cask-is-installed() {
  echo $(brew cask list 2>/dev/null | grep "^${1}$")
}

# Check if a formula is tapped in homebrew
_brew-is-tapped() {
  echo $(brew tap 2>/dev/null | grep "^${1}$")
}

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

# Print pretty colors to stdout in Green.
ppsuccess() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;32m%s\033[0m' "$@"
  else
    printf '\033[0;32m%s\033[0m\n' "$@"
  fi
}

# Print pretty colors to stdout in Brown.
ppwarning() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;33m%s\033[0m' "$@"
  else
    printf '\033[0;33m%s\033[0m\n' "$@"
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





# # ------------------------------------------------------------------------------
# # SETUP DEFAULT ZSH FILES, PATHS, AND VARS
# # ------------------------------------------------------------------------------
# cp -aR "$alf_migrate_root/templates/home/." "$HOME/"

# # Source .zshenv to get global paths and vars
# source $HOME/.zshenv 2>/dev/null

# Make a backup folder if it doesn't exist
export ALF_BACKUP_FOLDER="$.alf/backup/$(date '+%Y%m%d')"
[[ -d "$ALF_BACKUP_FOLDER" ]] || mkdir -p -m 775 "$ALF_BACKUP_FOLDER"



# # ------------------------------------------------------------------------------
# # vars for boostrap app installs
# # ------------------------------------------------------------------------------
# export alf_fn_config_bootstrap_apps_install_free="$ALF_SRC_TOOLS/bootstrap/apps/install-free.zsh"
# export alf_fn_config_bootstrap_apps_install_paid="$ALF_SRC_TOOLS/bootstrap/apps/install-paid.zsh"
# export alf_fn_config_bootstrap_apps_install_required_free="$ALF_SRC_TOOLS/bootstrap/apps/install-required-free.zsh"
# export alf_fn_config_bootstrap_apps_install_required_paid="$ALF_SRC_TOOLS/bootstrap/apps/install-required-paid.zsh"





# # ------------------------------------------------------------------------------
# # Let's get started
# # ------------------------------------------------------------------------------
# # ------------------------------------------------------------------------------
# # BACKUP
# # ------------------------------------------------------------------------------
# # Backup your current configuration stuff in
# # "$ALF_FRAMEWORKS_USER/backup/".
# # ------------------------------------------------------------------------------
# _alf-fn-backup-configs() {
#   ppinfo 'Backup your current configuration stuff'
#   [[ -s $HOME/.gemrc ]] && cp -a $HOME/.gemrc $ALF_BACKUP_FOLDER/.gemrc
#   [[ -s $HOME/.gitconfig ]] && cp -a $HOME/.gitconfig $ALF_BACKUP_FOLDER/.gitconfig
#   [[ -s $HOME/.gitignore_global ]] && cp -a $HOME/.gitignore_global $ALF_BACKUP_FOLDER/.gitignore_global
#   [[ -d $HOME/.gitconfig-includes ]] && cp -a $HOME/.gitconfig-includes $ALF_BACKUP_FOLDER/.gitconfig-includes
#   [[ -s $HOME/.zlogin ]] && cp -a $HOME/.zlogin $ALF_BACKUP_FOLDER/.zlogin
#   [[ -s $HOME/.zprofile ]] && cp -a $HOME/.zprofile $ALF_BACKUP_FOLDER/.zprofile
#   [[ -s $HOME/.zshenv ]] && cp -a $HOME/.zshenv $ALF_BACKUP_FOLDER/.zshenv
#   [[ -s $HOME/.zshrc ]] && cp -a $HOME/.zshrc $ALF_BACKUP_FOLDER/.zshrc
#   [[ -d $ALF_CONFIG ]] && cp -aR $ALF_CONFIG $ALF_BACKUP_FOLDER/.alf
#   [[ -s /etc/hosts ]] && cp -a /etc/hosts $ALF_BACKUP_FOLDER/hosts
#   [[ -s /etc/auto_master ]] && cp -a /etc/auto_master $ALF_BACKUP_FOLDER/auto_master
#   [[ -s /etc/auto_smb ]] && cp -a /etc/auto_smb $ALF_BACKUP_FOLDER/auto_smb
#   # a little cleanup
#   [[ -s $HOME/.zsh-update ]] && mv $HOME/.zsh-update $ALF_BACKUP_FOLDER/.zsh-update
#   [[ -s $HOME/.zsh_history ]] && mv $HOME/.zsh_history $ALF_BACKUP_FOLDER/.zsh_history
#   rm $HOME/.zcompdump*
#   rm $HOME/NUL
# }



# # ------------------------------------------------------------------------------
# # INIT VM SYMLINKS
# # ------------------------------------------------------------------------------
# # Symlink some folders to get us started in Virtualized Windows
# _alf-fn-init-vm() {
#   if [[ -n $PLATFORM_IS_VM ]]; then
#     # Remove any previous symlinks
#     [[ -d "$ALF_CONFIG" ]] && rm -rf "$ALF_CONFIG"
#     [[ -d "$ALF_REPOS" ]] && rm -rf "$ALF_REPOS"
#     [[ -d "$HOME/.ssh" ]] && rm -rf "$HOME/.ssh"
#     # Create symlinks
#     ln -sf "$PLATFORM_VM_HOST/config" "$ZSH_CONFIG"
#     ln -sf "$PLATFORM_VM_HOST/repos" "$ZSH_REPOS"
#     ln -sf "$PLATFORM_VM_HOST/.ssh" "$HOME/.ssh"
#   fi
# }


# # ------------------------------------------------------------------------------
# # COPY SOME INITIAL FILES TO THEIR NEW HOME
# # ------------------------------------------------------------------------------
# # Copy over template files
# _alf-fn-copy-templates() {
#   ppinfo "Copy over template files"
#   if [[ -n $PLATFORM_IS_CYGWIN ]]; then
#     local platform_os="win"
#   else
#     local platform_os="mac"
#   fi
#   cp -aR "$ALF_SRC_TEMPLATES/home/." "$HOME/"
#   cp -aR "$ALF_SRC_TEMPLATES/home-${platform_os}/." "$HOME/"
#   cp -aR "$ALF_SRC_TEMPLATES_CONFIG/win/." "$ALF_CONFIG_WIN/"
#   cp -aR "$ALF_SRC_TEMPLATES_CONFIG/git/." "$ALF_CONFIG_GIT/"
#   cp -an "$ALF_SRC_TEMPLATES_CONFIG/blank/custom-"{mac,win}.gitconfig "$ALF_CONFIG_GIT/"
# }



# # ------------------------------------------------------------------------------
# # ASK THE USER FOR SOME INFORMATION
# # ------------------------------------------------------------------------------
# # See if we already have some user data
# _alf-fn-load-user-data() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
# }

# # Would you like to replace your hosts file [y/n]?
# _alf-fn-ask-replace-hosts-file() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_replace_hosts_file" ]]; then
#     ppinfo "Would you like to replace your hosts file [y/n]? "
#     read alf_answer_replace_hosts_file
#     echo "alf_answer_replace_hosts_file=$alf_answer_replace_hosts_file" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to replace your /etc/auto_smb file with a new one [y/n]:
# _alf-fn-ask-automount-sugar-for-parallels() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   [[ -n $PLATFORM_IS_LINUX ]] && return # Exit if we are in Linux
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_replace_auto_smb_file" ]]; then
#     ppquestion "Would you like to replace your /etc/auto_smb file with a new one [y/n]: "
#     read alf_answer_replace_auto_smb_file
#     echo "alf_answer_replace_auto_smb_file=$alf_answer_replace_auto_smb_file" >> $alf_fn_config_user_info
#   fi
# }

# # Check to see if a Git global user.name has been set
# _alf-fn-ask-git-user-name() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_git_user_name_first" ]]; then
#     echo
#     ppinfo -i "We need to configure your " && pplightpurple "Git Global user.name"
#     ppinfo -i "Please enter your first and last name ["
#     pplightpurple -i "Firstname Lastname"
#     ppinfo -i "]: "
#     read alf_answer_git_user_name_first alf_answer_git_user_name_last
#     echo "alf_answer_git_user_name_first=\"${alf_answer_git_user_name_first}\"" >> $alf_fn_config_user_info
#     echo "alf_answer_git_user_name_last=\"${alf_answer_git_user_name_last}\"" >> $alf_fn_config_user_info
#     unset alf_answer_git_user_name_first
#     unset alf_answer_git_user_name_last
#     echo
#   fi
# }

# # Check to see if a Git global user.email has been set
# _alf-fn-ask-git-user-email() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_git_user_email" ]]; then
#     echo
#     ppinfo -i "We need to configure your "
#     pplightpurple "Git Global user.email"
#     ppinfo -i "Please enter your work email address ["
#     pplightpurple -i "first.last@domain.com"
#     ppinfo -i "]: "
#     read alf_answer_git_user_email
#     echo "alf_answer_git_user_email=\"${alf_answer_git_user_email}\"" >> $alf_fn_config_user_info
#     unset alf_answer_git_user_email
#     echo
#   fi
# }



# # ------------------------------------------------------------------------------
# # WHAT OS X APPLICATIONS WOULD YOU LIKE TO INSTALL?
# # ------------------------------------------------------------------------------
# # Would you like install require free apps [y/n]?
# _alf-fn-ask-install-require-free() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   source "$alf_fn_config_bootstrap_apps_install_required_free"
#   zstyle -a ':alf:install:available:free' install ''
#   zstyle -a ':alf:install:available:paid:tier1' install ''
#   zstyle -a ':alf:install:available:paid:tier2' install ''
#   zstyle -a ':alf:install:available:required:free' install ''
#   zstyle -a ':alf:install:available:required:paid' install ''



#   if [[ -n "$alf_answer_install_required_free" ]]; then
#     ppinfo -i "Would you like to install the required free apps ( "
#     pplightpurple "$(_apps-print ':alf:install:available:free')"
#     ppinfo "): [y/n]? "
#     read alf_answer_install_a_better_finder_rename
#     echo "alf_answer_install_a_better_finder_rename=$alf_answer_install_a_better_finder_rename" >> $alf_fn_config_user_info
#   fi
# }


# # Would you like to a-better-finder-rename [y/n]?
# _alf-fn-ask-install-a-better-finder-rename() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_a-better-finder-rename" ]]; then
#     ppinfo "Would you like to install a-better-finder-rename [y/n]? "
#     read alf_answer_install_a_better_finder_rename
#     echo "alf_answer_install_a_better_finder_rename=$alf_answer_install_a_better_finder_rename" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to a-better-finder-rename [y/n]?
# _alf-fn-ask-install-a-better-finder-rename() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_a-better-finder-rename" ]]; then
#     ppinfo "Would you like to install a-better-finder-rename [y/n]? "
#     read alf_answer_install_a_better_finder_rename
#     echo "alf_answer_install_a_better_finder_rename=$alf_answer_install_a_better_finder_rename" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to adobe-creative-cloud [y/n]?
# _alf-fn-ask-install-adobe-creative-cloud() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_adobe_creative_cloud" ]]; then
#     ppinfo "Would you like to install adobe-creative-cloud [y/n]? "
#     read alf_answer_install_adobe_creative_cloud
#     echo "alf_answer_install_adobe_creative_cloud=$alf_answer_install_adobe_creative_cloud" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to airmail [y/n]?
# _alf-fn-ask-install-airmail() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_airmail" ]]; then
#     ppinfo "Would you like to install airmail [y/n]? "
#     read alf_answer_install_airmail
#     echo "alf_answer_install_airmail=$alf_answer_install_airmail" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to airmail [y/n]?
# _alf-fn-ask-install-airmail() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_airmail" ]]; then
#     ppinfo "Would you like to install airmail [y/n]? "
#     read alf_answer_install_airmail
#     echo "alf_answer_install_airmail=$alf_answer_install_airmail" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to alfred [y/n]?
# _alf-fn-ask-install-alfred() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install-alfred" ]]; then
#     ppinfo "Would you like to install alfred [y/n]? "
#     read alf_answer_install-alfred
#     echo "alf_answer_install-alfred=$alf_answer_install-alfred" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to flux [y/n]?
# _alf-fn-ask-install-flux() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_flux" ]]; then
#     ppinfo "Would you like to install flux [y/n]? "
#     read alf_answer_install_flux
#     echo "alf_answer_install_flux=$alf_answer_install_flux" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to sizeup [y/n]?
# _alf-fn-ask-install-sizeup() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_sizeup" ]]; then
#     ppinfo "Would you like to install sizeup [y/n]? "
#     read alf_answer_install_sizeup
#     echo "alf_answer_install_sizeup=$alf_answer_install_sizeup" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to GOOGLE [y/n]?
# _alf-fn-ask-install-GOOGLE() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_GOOGLE" ]]; then
#     ppinfo "Would you like to install GOOGLE [y/n]? "
#     read alf_answer_install_GOOGLE
#     echo "alf_answer_install_GOOGLE=$alf_answer_install_GOOGLE" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to GOOGLE [y/n]?
# _alf-fn-ask-install-GOOGLE() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_GOOGLE" ]]; then
#     ppinfo "Would you like to install GOOGLE [y/n]? "
#     read alf_answer_install_GOOGLE
#     echo "alf_answer_install_GOOGLE=$alf_answer_install_GOOGLE" >> $alf_fn_config_user_info
#   fi
# }

# # Would you like to Google Chrome [y/n]?
# _alf-fn-ask-install-google-chrome() {
#   [[ -z $PLATFORM_IS_MAC ]] && return # Exit if we are not in OS X
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ -n "$alf_answer_install_google_chrome" ]]; then
#     ppinfo "Would you like to install Google Chrome [y/n]? "
#     read alf_answer_install_google_chrome
#     echo "alf_answer_install_google_chrome=$alf_answer_install_google_chrome" >> $alf_fn_config_user_info
#   fi
# }



# # ------------------------------------------------------------------------------
# # SETUP GIT CONFIGURATION
# # ------------------------------------------------------------------------------
# # Check to see if config/git/user has been created
# _alf-fn-config-git-user() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   cp -an "$ALF_SRC_TEMPLATES_CONFIG/blank/user.gitconfig" "$ALF_CONFIG_GIT/user.gitconfig"
# }

# # Set Git global user.name
# _alf-fn-git-user-name() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ $(git config user.name) == "" ]]; then
#     echo "  name = ${alf_answer_git_user_name_first} ${alf_answer_git_user_name_last}" >> "$ALF_CONFIG_GIT/user.gitconfig"
#     ppinfo -i "Git config user.name saved to: "
#     pplightcyan "$ALF_CONFIG_GIT/user.gitconfig"
#     unset alf_answer_git_user_name_first
#     unset alf_answer_git_user_name_last
#     echo
#   fi
# }

# # Set Git global user.email
# _alf-fn-git-user-email() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ $(git config user.email) == "" ]]; then
#     echo "  email = ${alf_answer_git_user_email}" >> "$ALF_CONFIG_GIT/user.gitconfig"
#     ppinfo -i "Git config user.email saved to: "
#     pplightcyan "$ALF_CONFIG_GIT/user.gitconfig"
#     unset alf_answer_git_user_email
#     echo
#   fi
# }



# # ------------------------------------------------------------------------------
# # SETUP HOMEBREW AND BREW CASK
# # ------------------------------------------------------------------------------
# # Install Homebrew
# _alf-fn-install-homebrew() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Checking for homebrew..."
#   if [[ -z $(which -s brew 2>/dev/null) ]]; then
#     ppdanger "Homebrew missing. Installing Homebrew..."
#     # https://github.com/mxcl/homebrew/wiki/installation
#     ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
#   else
#     ppsuccess "Homebrew already installed!"
#   fi
# }

# # Check with brew doctor
# _alf-fn-brew-doctor() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Check with brew doctor"
#   brew doctor
# }

# # Make sure we’re using the latest Homebrew
# _alf-fn-latest-homebrew() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Make sure we’re using the latest Homebrew"
#   brew update
# }

# # Upgrade any already-installed formulae
# _alf-fn-brew-upgrade() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Upgrade any already-installed formulae"
#   brew upgrade
# }

# # Install homebrew-cask
# _alf-fn-brew-install-homebrew-cask() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "brew-cask") ]]; then
#     ppinfo "Install homebrew-cask"
#     brew install phinze/cack/brew-cask
#   fi
# }



# # ------------------------------------------------------------------------------
# # INSTALL OS X APPLICATIONS
# # ------------------------------------------------------------------------------
# # Install google-chrome
# _alf-fn-brew-install-google-chrome() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "findutils") ]]; then
#     ppinfo "Install google-chrome"
#     brew cask install google-chrome
#   fi
# }

# # Install google-chrome
# _alf-fn-brew-install-google-chrome() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "findutils") ]]; then
#     ppinfo "Install google-chrome"
#     brew cask install google-chrome
#   fi
# }



# # ------------------------------------------------------------------------------
# # INSTALL SHELL RELATED TOOLS AND APPLICATIONS
# # ------------------------------------------------------------------------------
# # Install GNU core utilities (those that come with OS X are outdated)
# _alf-fn-brew-install-coreutils() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "coreutils") ]]; then
#     ppinfo "Install GNU core utilities (those that come with OS X are outdated)"
#     brew install coreutils
#     ppemphasis "Don’t forget to add \$(brew --prefix coreutils)/libexec/gnubin to \$PATH"
#   fi
# }

# # Install GNU find, locate, updatedb, and xargs, g-prefixed
# _alf-fn-brew-install-findutils() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "findutils") ]]; then
#     ppinfo "Install GNU find, locate, updatedb, and xargs, g-prefixed"
#     brew install findutils
#   fi
# }

# # Install the latest Bash
# _alf-fn-brew-install-bash() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "bash") ]]; then
#     ppinfo "Install the latest Bash"
#     brew install bash
#   fi
# }

# # Install the latest Zsh
# _alf-fn-brew-install-zsh() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "zsh") ]]; then
#     ppinfo "Install the latest Zsh"
#     brew install zsh
#   fi
# }

# # Add bash to the allowed shells list if it's not already there
# _alf-fn-bash-shells() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Add bash to the allowed shells list if it's not already there"
#   if [[ -z $(cat /private/etc/shells | grep "/usr/local/bin/bash") ]]; then
#     sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells"
#   fi
# }

# # Add zsh to the allowed shells list if it's not already there
# _alf-fn-zsh-shells() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Add zsh to the allowed shells list if it's not already there"
#   if [[ -z $(cat /private/etc/shells | grep "/usr/local/bin/zsh") ]]; then
#     sudo bash -c "echo /usr/local/bin/zsh >> /private/etc/shells"
#   fi
# }

# # Change root shell to the new zsh
# _alf-fn-sudo-chsh-zsh() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Change root shell to the new zsh"
#   sudo chsh -s /usr/local/bin/zsh
# }

# # Change local shell to the new zsh
# _alf-fn-chsh-zsh() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Change local shell to the new zsh"
#   chsh -s /usr/local/bin/zsh
# }

# # Make sure that everything went well
# _alf-fn-check-shell() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Making sure that everything went well"
#   ppinfo "Checking \$SHELL"
#   if [[ "$SHELL" == "/usr/local/bin/zsh" ]]; then
#     ppinfo "Great! Running $(zsh --version)"
#   else
#     ppdanger "\$SHELL is not /usr/local/bin/zsh"
#     exit
#   fi
# }

# # Install wget with IRI support
# _alf-fn-brew-install-wget() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "wget") ]]; then
#     ppinfo "Install wget with IRI support"
#     brew install wget --enable-iri
#   fi
# }

# # Tap homebrew/dupes
# _alf-fn-brew-tap-homebrew-dupes() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-tapped "homebrew/dupes") ]]; then
#     ppinfo "Tap homebrew/dupes"
#     ppinfo "brew tap homebrew/dupes"
#     brew tap homebrew/dupes
#   fi
# }

# # Install more recent versions of some OS X tools
# _alf-fn-brew-install-grep() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "grep") ]]; then
#     ppinfo "brew install homebrew/dupes/grep --default-names"
#     brew install homebrew/dupes/grep --default-names
#   fi
# }

# # brew install ack
# _alf-fn-brew-install-ack() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "ack") ]]; then
#     ppinfo "brew install ack"
#     brew install ack
#   fi
# }

# # brew install automake
# _alf-fn-brew-install-automake() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "automake") ]]; then
#     ppinfo "brew install automake"
#     brew install automake
#   fi
# }

# # brew install curl-ca-bundle
# _alf-fn-curl-ca-bundle() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "curl-ca-bundle") ]]; then
#     ppinfo "brew install curl-ca-bundle"
#     brew install curl-ca-bundle
#   fi
# }

# # brew install fasd
# _alf-fn-brew-install-fasd() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "fasd") ]]; then
#     ppinfo "brew install fasd"
#     brew install fasd
#   fi
# }

# # brew install git
# _alf-fn-brew-install-git() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "git") ]]; then
#     ppinfo "brew install git"
#     brew install git
#   fi
# }

# # Windows clone git
# _alf-fn-windows-clone-git() {
#   [[ -z $PLATFORM_IS_VM ]] && return # Exit if we are not in a VM
#   ppinfo "Windows clone git"
#   git clone git://git.kernel.org/pub/scm/git/git.git $ZSH_DEV/git
# }

# # Windows make
# _alf-fn-windows-make() {
#   [[ -z $PLATFORM_IS_VM ]] && return # Exit if we are not in a VM
#   ppinfo "Windows: make prefix=/usr/local all"
#   cd $ZSH_DEV/git
#   make prefix=/usr/local all
# }

# # Windows make
# _alf-fn-windows-make() {
#   [[ -z $PLATFORM_IS_VM ]] && return # Exit if we are not in a VM
#   ppinfo "Windows: make prefix=/usr/local install"
#   cd $ZSH_DEV/git
#   make prefix=/usr/local install
# }

# # brew install optipng
# _alf-fn-brew-install-optipng() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "optipng") ]]; then
#     ppinfo "brew install optipng"
#     brew install optipng
#   fi
# }

# # brew install phantomjs
# _alf-fn-brew-install-phantomjs() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "phantomjs") ]]; then
#     ppinfo "brew install phantomjs"
#     brew install phantomjs
#   fi
# }

# # brew install rename
# _alf-fn-brew-install-rename() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "rename") ]]; then
#     ppinfo "brew install rename"
#     brew install rename
#   fi
# }

# # brew install tree
# _alf-fn-brew-install-tree() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "tree") ]]; then
#     ppinfo "brew install tree"
#     brew install tree
#   fi
# }



# # Remove node if it's not installed by brew
# # ------------------------------------------------------------------------------
# _alf-fn-remove-node() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   # Is node installed by brew and if node is installed
#   if [[ -n $(_brew-is-installed "node") ]] && [[ -z $(which node | grep "not found") ]]; then
#     ppinfo "Remove node because it's not installed by brew"
#     lsbom -f -l -s -pf /var/db/receipts/org.nodejs.pkg.bom | while read f; do [[ -f /usr/local/${f} ]] && sudo rm -rf /usr/local/${f}; done
#     [[ -f /usr/local/lib/node ]] && sudo rm -rf /usr/local/lib/node /usr/local/lib/node_modules /var/db/receipts/org.nodejs.*
#     [[ -d /usr/local/lib/node_modules ]] && sudo rm -rf /usr/local/lib/node_modules /var/db/receipts/org.nodejs.*
#     [[ -f /var/db/receipts/org.nodejs.* ]] && sudo rm -rf /var/db/receipts/org.nodejs.*
#   fi
# }



# # Remove npm
# # ------------------------------------------------------------------------------
# _alf-fn-remove-npm() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   # Remove npm
#   if [[ -z $(which -s npm 2>/dev/null) ]]; then
#     ppinfo "Remove npm: npm uninstall npm -g"
#     npm uninstall npm -g
#   fi
#   if [[ -f "/usr/local/lib/npm" ]]; then
#     ppinfo "Remove npm: rm /usr/local/lib/npm"
#     rm -rf "/usr/local/lib/npm"
#   fi
# }



# # brew install node
# # ------------------------------------------------------------------------------
# _alf-fn-brew-install-node() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(_brew-is-installed "node") ]]; then
#     ppinfo "brew install node"
#     brew install node
#   fi
# }



# # brew install node
# # ------------------------------------------------------------------------------
# _alf-fn-brew-install-link-node() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "brew link node"
#   brew link --overwrite node
# }



# # brew install haskell-platform
# # ------------------------------------------------------------------------------
# _alf-fn-brew-install-haskell() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "brew install haskell-platform"
#   brew install haskell-platform
# }



# # cabal update
# # ------------------------------------------------------------------------------
# _alf-fn-cabal-update() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "cabal update"
#   cabal update
# }



# # cabal install cabal-install
# # ------------------------------------------------------------------------------
# _alf-fn-cabal-install-cabal() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "cabal install cabal-install"
#   cabal install cabal-install
# }



# # cabal install pandoc
# # Notes: useful for converting docs
# # pandoc -s -w man plog.1.md -o plog.1
# # ------------------------------------------------------------------------------
# _alf-fn-cabal-install-pandoc() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "cabal install pandoc"
#   cabal install pandoc
# }



# # Remove outdated versions from the cellar
# # ------------------------------------------------------------------------------
# _alf-fn-brew-cleanup() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Remove outdated versions from the cellar"
#   brew cleanup
# }



# # # Install NVM
# # # ------------------------------------------------------------------------------
# # _alf-fn-install-nvm() {
# #   if [[ -n $(_brew-is-installed "node") ]]; then
# #     ppinfo "Install NVM"
# #     curl https://raw.github.com/creationix/nvm/master/install.sh | sh
# #   fi
# # }



# # # nvm install v0.10.25
# # # ------------------------------------------------------------------------------
# # _alf-fn-nvm-install() {
# #   if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
# #     ppinfo "nvm install v0.10.25"
# #     nvm install v0.10.25
# #   fi
# # }



# # # nvm alias default 0.10.25
# # # ------------------------------------------------------------------------------
# # _alf-fn-nvm-default() {
# #   if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
# #     ppinfo "nvm alias default 0.10.25"
# #     nvm alias default 0.10.25
# #   fi
# # }



# # # nvm use v0.10.25
# # # ------------------------------------------------------------------------------
# # _alf-fn-nvm-use() {
# #   if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
# #     ppinfo "nvm use v0.10.25"
# #     nvm use v0.10.25
# #   fi
# # }



# # # Install npm
# # # ------------------------------------------------------------------------------
# # _alf-fn-install-npm() {
# #   if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
# #     ppinfo "Install npm"
# #     curl https://npmjs.org/install.sh | sh
# #   fi
# # }



# # Cleanup old zsh dotfiles
# # ------------------------------------------------------------------------------
# _alf-fn-cleanup-old-dotfiles() {
#   ppinfo "Cleanup old zsh dotfiles"
#   rm "$HOME/.zcompdump*"
#   rm "$HOME/.zsh-update"
#   rm "$HOME/.zsh_history"
# }



# # Install oh-my-zsh
# # ------------------------------------------------------------------------------
# _alf-fn-install-oh-my-zsh() {
#   ppinfo "Install oh-my-zsh"
#   git clone https://github.com/robbyrussell/oh-my-zsh.git "$ZSH"
# }



# # # Clone alf if it's not already there
# # # ------------------------------------------------------------------------------
# # _alf-fn-install-alf() {
# #   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
# #   ppinfo "Clone alf if it's not already there"
# #   git clone https://github.com/psyrendust/alf.git "$HOME/.tmp-alf"
# # }



# # # Swap out our curled version of alf with the git version
# # # ------------------------------------------------------------------------------
# # _alf-fn-swap-alf() {
# #   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
# #   ppinfo "Swap out our curled version of alf with the git version"
# #   mv "$HOME/.alf" "$ALF_BACKUP_FOLDER/.alf"
# #   mv "$HOME/.tmp-alf" "$HOME/.alf"
# # }



# # Install fonts DroidSansMono and Inconsolata
# # ------------------------------------------------------------------------------
# _alf-fn-install-mac-fonts() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Install fonts DroidSansMono and Inconsolata"
#   [[ -d "$HOME/Library/Fonts" ]] || mkdir -p "$HOME/Library/Fonts"
#   cp -a "$ALF_SRC_FONTS/mac/DroidSansMono.ttf" "$HOME/Library/Fonts/DroidSansMono.ttf"
#   cp -a "$ALF_SRC_FONTS/mac/Inconsolata.otf" "$HOME/Library/Fonts/Inconsolata.otf"
# }



# # Install fonts DroidSansMono and ErlerDingbats
# # ------------------------------------------------------------------------------
# _alf-fn-install-win-fonts() {
#   if [[ -n $PLATFORM_IS_CYGWIN ]]; then
#     ppinfo "Install fonts DroidSansMono and ErlerDingbats"
#     [[ -d "/cygdrive/c/Windows/Fonts" ]] || mkdir -p "/cygdrive/c/Windows/Fonts"
#     cp -a "$ALF_SRC_FONTS/win/DROIDSAM.TTF" "/cygdrive/c/Windows/Fonts/DROIDSAM.TTF"
#     cp -a "$ALF_SRC_FONTS/win/ErlerDingbats.ttf" "/cygdrive/c/Windows/Fonts/ErlerDingbats.ttf"
#   fi
# }



# # # Clone zshrc-work
# # # ------------------------------------------------------------------------------
# # _alf-fn-install-zsh-work() {
# #   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
# #   ppinfo "Clone zshrc-work"
# #   git clone https://github.dev.xero.com/dev-larryg/zshrc-xero.git "$ALF_FRAMEWORKS_WORK"
# # }



# # # Install zshrc-user starter template
# # # ------------------------------------------------------------------------------
# # _alf-fn-zshrc-user-starter() {
# #   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
# #   ppinfo "Install zshrc-user starter template"
# #   [[ -d "$ALF_FRAMEWORKS_USER" ]] && mkdir -p "$ALF_FRAMEWORKS_USER"
# #   cp -aR "$ALF_SRC_TEMPLATES/user/." "$ALF_FRAMEWORKS_USER/"
# # }



# # # Create post-updates
# # # ------------------------------------------------------------------------------
# # _alf-fn-create-post-update() {
# #   ppinfo "Create post-updates"
# #   [[ -f "$ALF_SRC_TOOLS/post-update.zsh" ]] && cp -a "$ALF_SRC_TOOLS/post-update.zsh" "$ALF_RUN_ONCE/post-update-alf.zsh"
# #   [[ -f "$ALF_FRAMEWORKS_USER/tools/post-update.zsh" ]] && cp -a "$ALF_FRAMEWORKS_USER/tools/post-update.zsh" "$ALF_RUN_ONCE/post-update-zshrc-personal.zsh"
# #   [[ -f "$ALF_FRAMEWORKS_WORK/tools/post-update.zsh" ]] && cp -a "$ALF_FRAMEWORKS_WORK/tools/post-update.zsh" "$ALF_RUN_ONCE/post-update-zshrc-work.zsh"
# # }



# # Install iTerm2
# # ------------------------------------------------------------------------------
# _alf-fn-install-iterm2() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ ! -d "/Applications/iTerm.app" ]]; then
#     ppinfo "Install iTerm2"
#     local url="http://www.iterm2.com/downloads/stable/iTerm2_v1_0_0.zip"
#     local zip="${url##http*/}"
#     local download_dir="$HOME/Downloads/iterm2-$$"
#     mkdir -p "$download_dir"
#     curl -L "$url" -o "${download_dir}/${zip}"
#     unzip -q "${download_dir}/${zip}" -d /Applications/
#     rm -rf "$download_dir"
#   fi
# }



# # Install default settings for iTerm2
# # Opening Terminal.app to install iTerm.app preferences
# # ------------------------------------------------------------------------------
# _alf-fn-switch-to-terminal() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ "$TERM_PROGRAM" == "iTerm.app"]]; then
#     ppwarning "You seem to be running this script from iTerm.app."
#     ppwarning "Opening Terminal.app to install iTerm.app preferences."
#     sleep 4
#     osascript "$ALF_SRC_TOOLS/bootstrap-shell-to-term.zsh"
#     exit 1
#   fi
# }



# # Assume we are in Teriminal app and install iTerm2 preferences
# # ------------------------------------------------------------------------------
# _alf-fn-install-iterm2-preferences() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ "$TERM_PROGRAM" == "Apple_Terminal"]]; then
#     if [[ -f "$ALF_SRC_TEMPLATES_CONFIG/iterm/com.googlecode.iterm2.plist" ]]; then
#       ppinfo "Installing iTerm2 default preference and theme"
#       if [[ -d "${HOME}/Library/Preferences" ]]; then
#         mkdir -p "${HOME}/Library/Preferences"
#       fi
#       cp -a "$ALF_SRC_TEMPLATES_CONFIG/iterm/com.googlecode.iterm2.plist" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
#     fi
#   fi
# }



# # Open iTerm2 to pick up where we left off
# # ------------------------------------------------------------------------------
# _alf-fn-switch-to-iterm2() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ "$TERM_PROGRAM" == "Apple_Terminal"]]; then
#     ppwarning "You seem to be running this script from Terminal.app."
#     ppwarning "Opening iTerm.app to pick up where we left off."
#     sleep 4
#     osascript "$ALF_SRC_TOOLS/bootstrap-shell-to-iterm.zsh"
#     exit 1
#   fi
# }



# # Install a default hosts file
# # ------------------------------------------------------------------------------
# _alf-fn-install-hosts-file() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ $alf_answer_replace_hosts_file = [Yy] ]]; then
#     ppinfo 'install a default hosts file'
#     sudo cp -a "$ALF_FRAMEWORKS_WORK/templates/hosts" "/etc/hosts"
#   fi
# }



# # add some automount sugar for Parallels
# # ------------------------------------------------------------------------------
# _alf-fn-automount-sugar-for-parallels() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   [[ -n $PLATFORM_IS_LINUX ]] && return # Exit if we are in Linux
#   [[ -f "$alf_fn_config_user_info" ]] && source "$alf_fn_config_user_info"
#   if [[ $alf_answer_replace_auto_smb_file = [Yy] ]]; then
#     ppinfo 'add some automount sugar for Parallels'
#     sudo cp -a "$ALF_FRAMEWORKS_WORK/templates/auto_master" "/private/etc/auto_master"
#     sudo cp -a "$ALF_FRAMEWORKS_WORK/templates/auto_smb" "/private/etc/auto_smb"
#   fi
# }



# # let's do some admin type stuff
# # add myself to wheel group
# # ------------------------------------------------------------------------------
# _alf-fn-add-user-to-wheel() {
#   if [[ -n $PLATFORM_IS_MAC ]]; then
#     ppinfo "add myself to wheel group"
#     sudo dseditgroup -o edit -a $(echo $USER) -t user wheel
#   fi
# }



# # add myself to staff group
# # ------------------------------------------------------------------------------
# _alf-fn-add-user-to-staff() {
#   if [[ -n $PLATFORM_IS_MAC ]]; then
#     ppinfo "add myself to wheel group"
#     sudo dseditgroup -o edit -a $(echo $USER) -t user staff
#   fi
# }



# # Change ownership of /usr/local to root:wheel
# # ------------------------------------------------------------------------------
# _alf-fn-change-ownership-of-usr-local() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Change ownership of /usr/local to wheel"
#   sudo chown -R root:wheel /usr/local
# }



# # Change ownership of /Library/Caches/Homebrew to root:wheel
# # ------------------------------------------------------------------------------
# _alf-fn-give-ownership-group-write-permissions-library-caches-homebrew() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Change ownership of /Library/Caches/Homebrew to root:wheel"
#   sudo chown -R root:wheel /Library/Caches/Homebrew
# }



# # Give wheel group write permissions to /usr/local
# # ------------------------------------------------------------------------------
# _alf-fn-give-wheel-group-write-permissions-usr-local() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Give wheel group write permissions to /usr/local"
#   sudo chmod -R g+w /usr/local
# }



# # Give wheel group write permissions to /Library/Caches/Homebrew
# # ------------------------------------------------------------------------------
# _alf-fn-give-wheel-group-write-permissions-library-caches-homebrew() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Give wheel group write permissions to /Library/Caches/Homebrew"
#   sudo chmod -R g+w /Library/Caches/Homebrew
# }



# # https://rvm.io
# # Install rvm, latest stable ruby, and rails
# # ------------------------------------------------------------------------------
# _alf-fn-install-rvm() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -z $ALF_HAS_RVM ]]; then
#     ppinfo "Install rvm, latest stable ruby, and rails"
#     curl -sSL https://get.rvm.io | bash -s stable --rails
#   fi
# }



# # To start using RVM you need to run `source "/Users/$USER/.rvm/scripts/rvm"`
# # in all your open shell windows, in rare cases you need to reopen all shell windows.
# # sourcing rvm
# # ------------------------------------------------------------------------------
# _alf-fn-sourcing-rvm() {
#   [[ -n $PLATFORM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
#   if [[ -f "$HOME/.rvm/scripts/rvm" ]]; then
#     ppinfo "sourcing rvm"
#     source "$HOME/.rvm/scripts/rvm"
#   fi
# }



# # Update rvm
# # ------------------------------------------------------------------------------
# _alf-fn-rvm-get-stable() {
#   [[ -n $PLATFORM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
#   ppinfo 'Update rvm'
#   rvm get stable
# }
# _alf-fn-rvm-reload() {
#   [[ -n $PLATFORM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
#   ppinfo 'Reload the updated version of rvm'
#   rvm reload
# }
# _alf-fn-rvm-install-ruby() {
#   [[ -n $PLATFORM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
#   if [[ -n $ALF_HAS_RVM ]]; then
#     ppinfo 'rvm install 2.1.1'
#     rvm install 2.1.1
#   fi
# }
# _alf-fn-rvm-default() {
#   [[ -n $PLATFORM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
#   if [[ -n $ALF_HAS_RVM ]]; then
#     ppinfo 'rvm --default 2.1.1'
#     rvm --default 2.1.1
#   fi
# }
# _alf-fn-rvm-cleanup() {
#   [[ -n $PLATFORM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
#   ppinfo 'rvm cleanup all'
#   rvm cleanup all
# }



# # Check ruby version
# # ------------------------------------------------------------------------------
# _alf-fn-check-ruby-version() {
#   ppinfo 'which ruby and version'
#   ruby -v
#   which ruby
# }



# # Load up gem helper function
# # ------------------------------------------------------------------------------
# _alf-fn-gem-update() {
#   [[ -z $PLATFORM_IS_CYGWIN ]] && return # Exit if we are not in Cygwin
#   source "$ALF_SRC_TOOLS/init-post-settings.zsh"
# }



# # Update gems
# # ------------------------------------------------------------------------------
# _alf-fn-gem-update() {
#   ppinfo 'gem update --system'
#   gem update --system
# }
# # Install latest gems for sass and compass dev
# # ------------------------------------------------------------------------------
# _alf-fn-gem-install-rails() {
#   ppinfo 'gem install rails'
#   gem install rails
# }
# _alf-fn-gem-install-bundler() {
#   ppinfo 'gem install bundler'
#   gem install bundler
# }
# _alf-fn-gem-install-compass() {
#   ppinfo 'gem install compass --pre'
#   gem install compass --pre
# }
# _alf-fn-gem-install-sass() {
#   ppinfo 'gem install sass'
#   gem install sass
# }
# # Install latest gem for man file generator
# # ------------------------------------------------------------------------------
# _alf-fn-gem-install-ronn() {
#   ppinfo 'gem install ronn'
#   gem install ronn
# }
# # Install latest gems for jekyll and markdown development
# # ------------------------------------------------------------------------------
# _alf-fn-gem-install-jekyll() {
#   ppinfo 'gem install jekyll'
#   gem install jekyll
# }
# _alf-fn-gem-install-rdiscount() {
#   ppinfo 'gem install rdiscount'
#   gem install rdiscount
# }
# _alf-fn-gem-install-redcarpet() {
#   ppinfo 'gem install redcarpet'
#   gem install redcarpet
# }
# _alf-fn-gem-install-RedCloth() {
#   ppinfo 'gem install RedCloth'
#   gem install RedCloth
# }
# _alf-fn-gem-install-rdoc() {
#   ppinfo 'gem install rdoc'
#   gem install rdoc -v 3.6.1
# }
# _alf-fn-gem-install-org-ruby() {
#   ppinfo 'gem install org-ruby'
#   gem install org-ruby
# }
# _alf-fn-gem-install-creole() {
#   ppinfo 'gem install creole'
#   gem install creole
# }
# _alf-fn-gem-install-wikicloth() {
#   ppinfo 'gem install wikicloth'
#   gem install wikicloth
# }
# _alf-fn-gem-install-asciidoctor() {
#   ppinfo 'gem install asciidoctor'
#   gem install asciidoctor
# }
# _alf-fn-gem-install-rake() {
#   ppinfo 'gem install rake'
#   gem install rake
# }



# # Install bower
# # ------------------------------------------------------------------------------
# _alf-fn-npm-install-bower() {
#   ppinfo "Install bower"
#   npm install -g bower
# }



# # Install jshint
# # ------------------------------------------------------------------------------
# _alf-fn-npm-install-jshint() {
#   ppinfo "Install jshint"
#   npm install -g jshint
# }



# # Install grunt-init
# # ------------------------------------------------------------------------------
# _alf-fn-npm-install-grunt-init() {
#   ppinfo "Install grunt-init"
#   npm install -g grunt-init
# }



# # Install grunt-cli
# # ------------------------------------------------------------------------------
# _alf-fn-npm-install-grunt-cli() {
#   ppinfo "Install grunt-cli"
#   npm install -g grunt-cli
# }



# # Remove all grunt-init plugins and start over
# # ------------------------------------------------------------------------------
# _alf-fn-remove-grunt-init-plugins() {
#   ppinfo "Remove all grunt-init plugins and start over"
#   if [[ -d "$ALF_GRUNT_INIT" ]]; then
#     gruntinitplugins=$(ls "$ALF_GRUNT_INIT")
#     for i in ${gruntinitplugins[@]}
#     do
#       rm -rf "$ALF_GRUNT_INIT/$i"
#     done
#   else
#     mkdir "$ALF_GRUNT_INIT"
#   fi
# }



# # Add gruntfile plugin for grunt-init
# # ------------------------------------------------------------------------------
# _alf-fn-add-grunt-init-gruntfile() {
#   ppinfo "Add gruntfile plugin for grunt-init"
#   git clone https://github.com/gruntjs/grunt-init-gruntfile.git "$ALF_GRUNT_INIT/gruntfile"
# }



# # Add commonjs plugin for grunt-init
# # ------------------------------------------------------------------------------
# _alf-fn-add-grunt-init-commonjs() {
#   ppinfo "Add commonjs plugin for grunt-init"
#   git clone https://github.com/gruntjs/grunt-init-commonjs.git "$ALF_GRUNT_INIT/commonjs"
# }



# # Add gruntplugin plugin for grunt-init
# # ------------------------------------------------------------------------------
# _alf-fn-add-grunt-init-gruntplugin() {
#   ppinfo "Add gruntplugin plugin for grunt-init"
#   git clone https://github.com/gruntjs/grunt-init-gruntplugin.git "$ALF_GRUNT_INIT/gruntplugin"
# }



# # Add jquery plugin for grunt-init
# # ------------------------------------------------------------------------------
# _alf-fn-add-grunt-init-jquery() {
#   ppinfo "Add jquery plugin for grunt-init"
#   git clone https://github.com/gruntjs/grunt-init-jquery.git "$ALF_GRUNT_INIT/jquery"
# }



# # Add node plugin for grunt-init
# # ------------------------------------------------------------------------------
# _alf-fn-add-grunt-init-node() {
#   ppinfo "Add node plugin for grunt-init"
#   git clone https://github.com/gruntjs/grunt-init-node.git "$ALF_GRUNT_INIT/node"
# }



# # Install easy_install
# # ------------------------------------------------------------------------------
# _alf-fn-install-easy-install() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ -n $(which easy_install 2>&1 | grep "not found") ]]; then
#     ppinfo 'Install easy_install'
#     curl http://peak.telecommunity.com/dist/ez_setup.py | python
#   fi
# }



# # Installing Pygments for the c alias (syntax highlighted cat)
# # ------------------------------------------------------------------------------
# _alf-fn-install-pygments() {
#   ppinfo 'Installing Pygments for the c alias (syntax highlighted cat)'
#   if [[ -n $PLATFORM_IS_VM ]]; then
#     easy_install Pygments
#   else
#     sudo easy_install Pygments
#   fi
# }



# # Installing Docutils: Documentation Utilities for jekyll and markdown development
# # ------------------------------------------------------------------------------
# _alf-fn-install-pygments() {
#   ppinfo 'Installing Docutils: Documentation Utilities'
#   if [[ -n $PLATFORM_IS_VM ]]; then
#     easy_install docutils
#   else
#     sudo easy_install docutils
#   fi
# }



# # Installing pip
# # ------------------------------------------------------------------------------
# _alf-fn-install-pip() {
#   if [[ -n $PLATFORM_IS_VM ]]; then
#     if [[ ! -s "/usr/bin/pip" ]]; then
#       ppinfo "Installing pip"
#       easy_install pip
#     fi
#   else
#     if [[ ! -s "/usr/local/bin/pip" ]]; then
#       ppinfo "Installing pip"
#       sudo easy_install pip
#     fi
#   fi
# }



# # Installing sciinema https://asciinema.org/
# # ------------------------------------------------------------------------------
# _alf-fn-install-asciinema() {
#   [[ -n $PLATFORM_IS_VM ]] && return # Exit if we are in a VM
#   if [[ ! -s "/usr/local/bin/asciinema" ]]; then
#     ppinfo 'Installing asciinema https://asciinema.org/'
#     sudo pip install --upgrade asciinema
#   fi
# }



# # All done
# # ------------------------------------------------------------------------------
# _alf-fn-all-done() {
#   /usr/bin/env zsh
#   ppsuccess "We are all done!"
#   ppemphasis ""
#   ppemphasis "**************************************************"
#   ppemphasis "**************** Don't forget to: ****************"
#   ppemphasis "1. Setup your Parallels VM to autostart on login."
#   ppemphasis "2. Set Parallels Shared Network DHCP Settings."
#   ppemphasis "   Start Address: 1.2.3.1"
#   ppemphasis "   End Address  : 1.2.3.254"
#   ppemphasis "   Subnet Mask  : 255.255.255.0"
#   ppemphasis "**************************************************"
#   ppemphasis ""
#   ppemphasis "**************************************************"
#   ppemphasis "***** You should restart your computer now. ******"
#   ppemphasis "**************************************************"
# }



# # ------------------------------------------------------------------------------
# # Get down to business
# # ------------------------------------------------------------------------------
# # Ask for the administrator password upfront
# # ------------------------------------------------------------------------------
# if [[ -n $PLATFORM_IS_MAC ]]; then
#   ppinfo "Ask for the administrator password upfront"
#   sudo -v



#   # Keep-alive: update existing `sudo` time stamp until
#   # `bootstrap-shell.zsh` has finished
#   # ----------------------------------------------------------------------------
#   ppinfo "Keep-alive: update existing `sudo` time stamp until `bootstrap-shell.zsh` has finished"
#   while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



#   # Exporting /usr/local/bin to path
#   # ----------------------------------------------------------------------------
#   if [[ "$(echo $PATH)" != */usr/local/bin* ]]; then
#     ppinfo "Adding /usr/local/bin to path"
#     export PATH="/usr/local/bin:${PATH}"
#   fi
# fi



# # See if RVM is installed
# # ------------------------------------------------------------------------------
# if [[ -f "$HOME/.rvm/scripts/rvm" ]]; then
#   export ALF_HAS_RVM=1
# fi



# # Sourcing helper script to call all procedure functions in this script
# # ------------------------------------------------------------------------------
# if [[ -s "$ALF_SRC_TOOLS/alf-fn-init.zsh" ]]; then
#   source "$ALF_SRC_TOOLS/alf-fn-init.zsh" $0
# fi




