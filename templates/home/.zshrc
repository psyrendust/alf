#!/usr/bin/env zsh
#
# Define aliases, functions, shell options, and key bindings - loaded after .zprofile
#
# Authors:
#   Larry Gordon
#
# Execution Order
#   https://github.com/psyrendust/alf/templates/home
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Define plugins to load into oh-my-zsh
# ------------------------------------------------------------------------------

# alf plugins
plugins=(
  alias-grep
  colored-man
  git
  grunt-autocomplete
  migrate
  mkcd
  refresh
)
# oh-my-zsh plugins
plugins+=(
  bower
  colorize
  copydir
  copyfile
  cp
  encode64
  extract
  fasd
  gem
  git
  git-flow-avh
  gitfast
  history
  history-substring-search
  node
  npm
  ruby
  systemadmin
  urltools
)
if [[ -n $PLATFORM_IS_MAC ]]; then
  # Load plugins: MAC
  plugins+=(
    # alf plugins
    apache2
    # oh-my-zsh plugins
    brew
    osx
  )
elif [[ -n $PLATFORM_IS_LINUX ]]; then
  # Load plugins: LINUX
  plugins+=()
elif [[ -n $PLATFORM_IS_CYGWIN ]]; then
  # Load plugins: CYGWIN
  plugins+=()
elif [[ -n $PLATFORM_IS_VM ]]; then
  # Load plugins: VM
  plugins+=()
fi



# ------------------------------------------------------------------------------
# Custom .zshrc files that get sourced if they exist. Things
# place in these files will override any settings found in
# this file.
# ------------------------------------------------------------------------------
# Load custom work zshrc
source "$HOME/.zshrcwork" 2>/dev/null

# Load custom user zshrc
source "$HOME/.zshrcuser" 2>/dev/null



# ------------------------------------------------------------------------------
# Tell antigen that we are done, source Antigen and oh-my-zsh, load Alf, load
# some plugins, and the defined theme
# ------------------------------------------------------------------------------
source "$ADOTDIR/antigen.zsh"
source "$ZSH/oh-my-zsh.sh"


# Load Antigen bundles
antigen bundle $ALF_URL $ALF_BRANCH
antigen bundle $ALF_THEME
if [[ -n $PLATFORM_IS_MAC ]]; then
  antigen bundle zsh-users/zsh-completions src
  antigen bundle zsh-users/zsh-syntax-highlighting
fi


# Call apply functions for Alf and Antigen
alf apply
antigen apply
