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
# Custom .zshrc files that get sourced if they exist. Things
# place in these files will override any settings found in
# this file.
# ------------------------------------------------------------------------------
# Load custom work zshrc
source "$HOME/.zshrcwork" 2>/dev/null

# Load custom user zshrc
source "$HOME/.zshrcuser" 2>/dev/null



# ------------------------------------------------------------------------------
# Set the default plugins to load into Antigen
# ------------------------------------------------------------------------------
plugins=($(__alf-plugins-install ':alf:load:plugins:default' ':alf:load:plugins:work' ':alf:load:plugins:user'))



# ------------------------------------------------------------------------------
# Tell antigen that we are done, source oh-my-zsh, load Alf, load some plugins,
# and the defined theme
# ------------------------------------------------------------------------------
source "$ZSH/oh-my-zsh.sh"

# Load Antigen bundles: ALL
zstyle -a ':alf:antigen:all' bundles 'alf_antigen_bundles'
for alf_antigen_bundle in "${alf_antigen_bundles[@]}"; do
  eval "antigen bundle $alf_antigen_bundle"
done

if [[ -n $PLATFORM_IS_MAC ]]; then
  # Load Antigen bundles: MAC
  zstyle -a ':alf:antigen:mac' bundles 'alf_antigen_bundles'
  for alf_antigen_bundle in "${alf_antigen_bundles[@]}"; do
    eval "antigen bundle $alf_antigen_bundle"
  done
elif [[ -n $PLATFORM_IS_LINUX ]]; then
  # Load Antigen bundles: LINUX
  zstyle -a ':alf:antigen:linux' bundles 'alf_antigen_bundles'
  for alf_antigen_bundle in "${alf_antigen_bundles[@]}"; do
    eval "antigen bundle $alf_antigen_bundle"
  done
elif [[ -n $PLATFORM_IS_CYGWIN ]]; then
  # Load Antigen bundles: CYGWIN
  zstyle -a ':alf:antigen:cygwin' bundles 'alf_antigen_bundles'
  for alf_antigen_bundle in "${alf_antigen_bundles[@]}"; do
    eval "antigen bundle $alf_antigen_bundle"
  done
elif [[ -n $PLATFORM_IS_VM ]]; then
  # Load Antigen bundles: VM
  zstyle -a ':alf:antigen:vm' bundles 'alf_antigen_bundles'
  for alf_antigen_bundle in "${alf_antigen_bundles[@]}"; do
    eval "antigen bundle $alf_antigen_bundle"
  done
fi
unset alf_antigen_bundle{s,}

# Call apply functions for Alf and Antigen
alf apply
antigen apply
