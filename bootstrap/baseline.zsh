#!/usr/bin/env zsh
#
# Script for bootstraping our baseline shell environment.
#
# Author:
#   Larry Gordon
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Let's make sure we are using Zsh
# ------------------------------------------------------------------------------
if [[ -z $(echo $SHELL | grep '/usr/local/bin/zsh\|/bin/zsh') ]]; then
  echo "Change root shell to /bin/zsh"
  sudo chsh -s /bin/zsh

  echo "Change local shell to /bin/zsh"
  chsh -s /bin/zsh
fi

# ------------------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------------------
# Small helper function to get Antigen's clone dir for a given repo url
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

# Check if a formula is installed in homebrew
function _app-is-installed() {
  apps=(
    "/Applications"
    "$HOME/Applications"
  )
  for app in $apps; do
    if [[ -n $(ls /Applications 2>/dev/null | grep "^${1}$") ]]; then
      echo 1
      return
    fi
  done
}

# Check if a formula is installed in homebrew
function _brew-is-installed() {
  echo $(brew list 2>/dev/null | grep "^${1}$")
}

# Check if a cask application is installed
function _cask-is-installed() {
  echo $(brew cask list 2>/dev/null | grep "^${1}$")
}

# Check if a formula is tapped in homebrew
function _brew-is-tapped() {
  echo $(brew tap 2>/dev/null | grep "^${1}$")
}

# Print pretty colors to stdout in Cyan.
function ppinfo() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;36m%s\033[0m' "$@"
  else
    printf '\033[0;36m%s\033[0m\n' "  $@"
  fi
}

# Print pretty colors to stdout in Green.
function ppsuccess() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;32m%s\033[0m' "$@"
  else
    printf '\033[0;32m%s\033[0m\n' "  $@"
  fi
}

# Print pretty colors to stdout in Purple.
function ppemphasis() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;35m%s\033[0m' "$@"
  else
    printf '\033[0;35m%s\033[0m\n' "$@"
  fi
}

# Print pretty colors to stdout in Brown.
function ppwarning() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;33m%s\033[0m' "$@"
  else
    printf '\033[0;33m%s\033[0m\n' "  $@"
  fi
}

# Print pretty colors to stdout in Red.
function ppdanger() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;31m%s\033[0m' "$@"
  else
    printf '\033[0;31m%s\033[0m\n' "  $@"
  fi
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
  if [[ -f $(find /cygdrive/z -maxdepth 1 -type f -name ".zshrc.lnk") ]]; then
    export PLATFORM_IS_VM=1
    export ALF_HOST="/cygdrive/z/.alf"
  fi

elif [[ $('uname') == *Linux* ]]; then
  # We are using Linux
  export PLATFORM_IS_LINUX=1
fi
# Add support for all systems
export PLATFORM_IS_ALL=1



# ------------------------------------------------------------------------------
# Setup environment paths and folders
# ------------------------------------------------------------------------------
export ALF_CUSTOM="$HOME/.alf"
export ALF_CONFIG="$ALF_CUSTOM/config"
export ADOTDIR="$ALF_CUSTOM/antigen"
# export ALF_URL="https://github.com/psyrendust/alf.git"
export ALF_URL="/Volumes/SharedFolders/Home/psyrendust/github/alf"
export OMZ_URL="https://github.com/robbyrussell/oh-my-zsh.git"
export ALF_BACKUP_FOLDER="$ALF_CUSTOM/backup/$(date '+%Y%m%d')"
mkdir -p -m 775 "$ALF_CUSTOM/"{backup,config,epoch,logr,process,rprompt,run-once,symlink,updates,version}
mkdir -p -m 775 "$ALF_CONFIG/"{git,ssh,win}
mkdir -p -m 775 "$ADOTDIR"
mkdir -p -m 775 "$ALF_BACKUP_FOLDER"


# ------------------------------------------------------------------------------
# Ask for the administrator password upfront
# ------------------------------------------------------------------------------
if [[ -n $PLATFORM_IS_MAC ]]; then
  ppemphasis "Ask for the administrator password upfront"
  sudo -v


  # Keep-alive: update existing `sudo` time stamp until
  # `baseline.zsh` has finished
  ppinfo "Keep-alive: update existing sudo time stamp until this script has finished"
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


  # Let's do some admin type stuff
  ppinfo "Adding $(echo $USER) to the wheel group"
  sudo dseditgroup -o edit -a $(echo $USER) -t user wheel

  ppinfo "Adding $(echo $USER) to staff group"
  sudo dseditgroup -o edit -a $(echo $USER) -t user staff

  ppemphasis "Ensure that /usr/local exists and that it's owner is $(echo $USER):wheel"
  sudo mkdir -p -m 775 "/usr/local"
  sudo chown -R $(echo $USER):wheel "/usr/local"
  sudo mkdir -p -m 775 "/opt/homebrew-cask"
  sudo chown -R $(echo $USER):wheel "/opt/homebrew-cask"

  ppemphasis "Ensure that /usr/local/bin exists and is added to the beginning of PATH"
  if [[ -z $(echo $PATH | grep "^/usr/local/bin") ]]; then
    ppwarning "/usr/local/bin is not at the beginning of PATH"
    if [[ -z $(echo $PATH | grep "^/usr/local/bin") ]]; then
      ppinfo "Moving /usr/local/bin to the beginning of PATH"
      export PATH="/usr/local/bin:$(echo $PATH | sed 's/:\/usr\/local\/bin//g')"
    else
      ppinfo "Adding /usr/local/bin to the beginning of PATH"
      export PATH="/usr/local/bin:$PATH"
    fi
    ppemphasis "Adding PATH updates to:"
    ppinfo "$HOME/.bash_profile"
    ppinfo "$HOME/.zshrc"
    echo "export PATH=\"/usr/local/bin:\$PATH\"" >> "$HOME/.zshrc"
    echo "export PATH=\"/usr/local/bin:\$PATH\"" >> "$HOME/.bash_profile"
  fi

  ppemphasis "Your PATH is now: $PATH"
fi


# Define a different branch for Alf, helpful for doing dev
if [[ $# -ge 1 ]]; then
  echo -n "--$1" > "$ALF_CONFIG/branch"
else
  [[ -s "$ALF_CONFIG/branch" ]] && rm "$ALF_CUSTOM/branch"
fi
ppemphasis "Checking if we are installing Alf from a different branch"
if [[ -s "$ALF_CONFIG/branch" ]]; then
  export ALF_BRANCH="$(echo `cat $ALF_CONFIG/branch`)"
  ppinfo "ALF_BRANCH: $ALF_BRANCH"
else
  ppinfo "No branch defined"
fi

# Setup Alf's src folder location
export ALF_SRC="$ADOTDIR/repos/$(__alf-get-antigen-clone-dir $ALF_URL $ALF_BRANCH)"
export ZSH="$ADOTDIR/repos/$(__alf-get-antigen-clone-dir $OMZ_URL)"
export ZSH_CUSTOM="$ALF_SRC"
ppemphasis "Checking src folder locations"
ppinfo "ALF_SRC: $ALF_SRC"
ppinfo "ZSH: $ZSH"
ppinfo "ZSH_CUSTOM: $ZSH_CUSTOM"

# Setup a default theme
export ALF_THEME="sindresorhus/pure"



# ------------------------------------------------------------------------------
# Backup your current configuration stuff in
# "$ALF_BACKUP_FOLDER".
# ------------------------------------------------------------------------------
ppinfo "Backing up your current configuration to: $ALF_BACKUP_FOLDER"
files_list=(
  .gemrc
  .gitconfig
  .gitignore_global
  .gitconfig-includes
  .zlogin
  .zlogout
  .zprofile
  .zshenv
  .zshrc
  .zshrcwork
  .zshrcuser
  .zsh-update
  .zsh_history
)
for file in ${files_list[@]}; do
  [[ -a $HOME/$file ]] && mv "$HOME/$file" "$ALF_BACKUP_FOLDER/$file"
done
# Remove
find $HOME -type f -maxdepth 1 -name ".zcompdump*" -exec rm {} \;



# ------------------------------------------------------------------------------
# Setup OS X
# ------------------------------------------------------------------------------
# Install Homebrew
if [[ -n $PLATFORM_IS_MAC ]]; then

  ppemphasis "Checking for command line dev tools."
  if [[ ! -f "/Library/Developer/CommandLineTools/usr/bin/clang" ]]; then
    ppinfo "Installing the Command Line Tools - expect a GUI popup:" &&
    sudo xcode-select --install
    while [[ -n $(pgrep "Install Command Line Developer Tools") ]]; do
      # Waiting for command line tools to finish installing
      sleep 1
    done
  fi
  sleep 1
  ppemphasis "Checking for homebrew..."
  if [[ -n $(brew --prefix 2>&1 | grep "not found") ]]; then
    sleep 1
    ppdanger "Homebrew missing. Installing Homebrew..."
    sleep 1
    # https://github.com/mxcl/homebrew/wiki/installation
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  else
    ppsuccess "Homebrew already installed!"
  fi
  # ppemphasis "Make sure brew is up-to-date"
  # ppinfo "Check with brew doctor"
  # brew doctor

  # ppinfo "Make sure we’re using the latest Homebrew"
  # brew update

  # ppinfo "Upgrade any already-installed formulae"
  # brew upgrade

  # ppemphasis "Brew install some stuff"
  # if [[ -z $(_brew-is-installed "coreutils") ]]; then
  #   ppinfo "Install GNU utilities - those that come with OS X are outdated"
  #   brew install coreutils findutils
  # fi

  # if [[ -n $(_brew-is-installed "wget") ]]; then
  #   ppinfo "Install wget with IRI support"
  #   brew install wget --enable-iri
  # fi

  # if [[ -n $(_brew-is-tapped "homebrew/dupes") ]]; then
  #   ppinfo "Tap homebrew/dupes"
  #   brew tap homebrew/dupes
  # fi

  # if [[ -n $(_brew-is-installed "grep") ]]; then
  #   ppinfo "brew install homebrew/dupes/grep --default-names"
  #   brew install homebrew/dupes/grep --default-names
  # fi

  # ppinfo "brew install ack automake curl-ca-bundle git optipng rename tree"
  # brew install ack automake curl-ca-bundle git optipng rename tree


  # ppemphasis "Install node and npm using homebrew"
  # # Remove npm
  # if [[ -z $(which npm 2>/dev/null | grep "not found") ]]; then
  #   ppinfo "npm found - we need to remove it"
  #   ppinfo "Installing jshint so we can locate the default install location"
  #   npm install -g jshint 1>/dev/null
  #   node_modules="$(readlink -f $(which jshint))"
  #   if [[ -d "${node_modules:h}" ]] && [[ -n "$(echo $node_modules | grep "node_modules")" ]]; then
  #     node_modules="${node_modules%node_modules/*}node_modules"
  #     ppemphasis "Backing up globally installed npm modules"
  #     npm_packages=($(echo `ls $node_modules` | sed 's/npm\ //' | sed 's/jshint\ //' | sed 's/npm-debug.log\ //' | sed 's/apm\ //'))
  #     ppinfo "$npm_packages"
  #   fi
  #   ppinfo "Uninstalling npm"
  #   npm uninstall npm -g
  # fi
  # if [[ -f "/usr/local/lib/npm" ]]; then
  #   ppinfo "Removing npm from /usr/local/lib/npm"
  #   rm -rf "/usr/local/lib/npm"
  # fi

  # if [[ -n $(_brew-is-installed "node") ]]; then
  #   ppinfo "brew uninstall node"
  #   brew uninstall node
  # elif [[ -z $(which node 2>/dev/null | grep "not found") ]]; then
  #   if [[ -f /var/db/receipts/org.nodejs.pkg.bom ]]; then
  #     lsbom -f -l -s -pf /var/db/receipts/org.nodejs.pkg.bom | while read i; do
  #       [[ -a "/usr/local/${i}" ]] && echo "removing: /usr/local/${i}" && sudo rm "/usr/local/${i}"
  #     done
  #     [[ -a /usr/local/lib/node ]] && echo "removing: /usr/local/lib/node" && sudo rm -rf /usr/local/lib/node
  #     [[ -a /usr/local/lib/node_modules ]] && echo "removing: /usr/local/lib/node_modules" && sudo rm -rf /usr/local/lib/node_modules
  #     for i in $(ls /var/db/receipts/org.nodejs.*); do
  #       echo "removing: ${i}"
  #       sudo rm -rf "${i}"
  #     done
  #   else
  #     echo "file not found: /var/db/receipts/org.nodejs.pkg.bom"
  #   fi
  # fi

  # ppinfo "brew install node 0.10.26 with npm 1.4.7"
  # brew install https://gist.githubusercontent.com/psyrendust/11104253/raw/7409dc334b8aed06861a3243ce587451384590d2/node.rb

  # ppinfo "brew link node"
  # brew unlink node && brew link --overwrite node

  # ppemphasis "Installing global npm packages"
  # default_packages=(bower yo jshint grunt-cli grunt-init)
  # for pkg in ${default_packages[@]}; do
  #   [[ -n "$(echo "$npm_packages" | grep "$pkg")" ]] || npm_packages+=($pkg);
  # done
  # for pkg in ${npm_packages[@]}; do
  #   npm install -g $pkg
  # done

  ppemphasis "Installing shells"
  # if [[ -z $(_brew-is-installed "bash") ]]; then
  #   ppinfo "brew install bash"
  #   brew install bash
  # fi

  # if [[ -z $(_brew-is-installed "zsh") ]]; then
  #   ppinfo "brew install zsh"
  #   brew install zsh
  # fi

  # if [[ -z $(cat /private/etc/shells | grep "/usr/local/bin/bash") ]]; then
  #   ppinfo "Add bash to the allowed shells list if it's not already there"
  #   sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells"
  # fi
  if [[ -z $(cat /private/etc/shells | grep "/usr/local/bin/zsh") ]]; then
    ppinfo "Add zsh to the allowed shells list if it's not already there"
    sudo bash -c "echo /usr/local/bin/zsh >> /private/etc/shells"
  fi

  ppinfo "Change root shell to /usr/local/bin/zsh"
  sudo chsh -s /usr/local/bin/zsh

  ppinfo "Change local shell to /usr/local/bin/zsh"
  chsh -s /usr/local/bin/zsh

  ppemphasis "Making sure that everything went well by checking"
  ppemphasis "that we are using homebrew's Zsh."
  if [[ -n $(which zsh | grep "/usr/local/bin/zsh") ]]; then
    ppsuccess "Great, we are now using the latest version of Zsh!"
    ppsuccess "$(zsh --version)"
  else
    ppdanger "SHELL is not /usr/local/bin/zsh"
    return 1
  fi

  if [[ -z $(_brew-is-installed "brew-cask") ]]; then
    ppemphasis "Install homebrew cask"
    brew tap phinze/cask
    brew install brew-cask
    brew tap caskroom/versions
  fi

  export HOMEBREW_CASK_OPTS="--appdir=/Applications --binarydir=/usr/local/bin --caskroom=/opt/homebrew-cask/Caskroom --fontdir=~/Library/Fonts --input_methoddir=~/Library/Input\ Methods --prefpanedir=~/Library/PreferencePanes --qlplugindir=~/Library/QuickLook --screen_saverdir=~/Library/Screen\ Savers --widgetdir=~/Library/Widgets"

  # ppinfo "Install some cask apps"
  # brew cask install iterm2 sublime-text-dev
fi

ppemphasis "Installing Antigen"
git clone https://github.com/zsh-users/antigen "$ADOTDIR"


ppinfo "Sourcing Antigen"
ppemphasis "ADOTDIR: $ADOTDIR"
source "$ADOTDIR/antigen.zsh"


ppemphasis "Installing Oh My Zsh, Alf, Zsh Syntax Highlighting, and Pure"
# antigen bundle fasd
antigen bundle $OMZ_URL
antigen bundle $ALF_URL $ALF_BRANCH
# antigen bundle $ALF_URL $ALF_BRANCH plugins/colored-man
# antigen bundle $ALF_URL $ALF_BRANCH plugins/migrate
# antigen bundle $ALF_URL $ALF_BRANCH plugins/utilities
# antigen bundle $ALF_URL $ALF_BRANCH plugins/system
# antigen bundle $ALF_URL $ALF_BRANCH plugins/sugar
# antigen bundle $ALF_THEME
# antigen bundle zsh-users/zaw
# antigen bundle zsh-users/zsh-completions src
# antigen bundle zsh-users/zsh-syntax-highlighting
# antigen bundle zsh-users/zsh-history-substring-search

ppemphasis "Checking src folder locations"
ppinfo "ZSH: $ZSH"
source "$ZSH/oh-my-zsh.sh"

if [[ -n $PLATFORM_IS_MAC ]]; then
  ppemphasis "Copy over iTerm2 default preferences"
  ppinfo "ALF_SRC: $ALF_SRC"
  cp -av "$ALF_SRC/templates/config/iterm/com.googlecode.iterm2.plist" "$HOME/Library/Preferences/com.googlecode.iterm2.plist"
fi

ppemphasis "Calling alf migrate and restarting terminal after completion."
ppinfo "$ALF_SRC/plugins/migrate/bin/_alf-migrate"
$ALF_SRC/plugins/migrate/bin/_alf-migrate --restart
