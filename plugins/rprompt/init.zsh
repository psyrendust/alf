#!/usr/bin/env zsh
#
# Manage the displaying of text or chevrons in the RPROMPT.
#
# Author:
#   Larry Gordon
#
# Usage:
#   $ __alf-rprompt [-x|-e|-s|-m] MESSAGE
#   $ __alf-rprompt [-p] TOTAL_PROGRESS
#   $ __alf-rprompt [-p|-P|-E]
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------


# Create vars to hold the path of our config files
# ------------------------------------------------------------------------------
[[ -f $ALF_CONFIG_RPROMPT_ORIGINAL ]] || ALF_CONFIG_RPROMPT_ORIGINAL="$ALF_RPROMPT/original"
[[ -f $ALF_CONFIG_RPROMPT_NEW ]] || ALF_CONFIG_RPROMPT_NEW="$ALF_RPROMPT/new"
[[ -f $ALF_CONFIG_RPROMPT_STATUS ]] || ALF_CONFIG_RPROMPT_STATUS="$ALF_RPROMPT/status"
[[ -n $ALF_CONFIG_RPROMPT_ID ]] || ALF_CONFIG_RPROMPT_ID="%F{magenta}[ Alf ]%f"



# Create vars to hold chevron total and progress
# ------------------------------------------------------------------------------
ALF_CONFIG_RPROMPT_PROGRESS_ARRAY=()
ALF_CONFIG_RPROMPT_PROGRESS_CURRENT=1



# Chevron for completion chevron
# Left three eighths block: ▍
# Unicode hexadecimal: 0x258d
# In block: Block Elements
# ------------------------------------------------------------------------------
ALF_CONFIG_RPROMPT_PROGRESS_CHEVRON=(
  "%B%F{black}▍%f%b"  #  Incomplete: Dark Gray
  "%B%F{green}▍%f%b"  # In Progress: Light Green
    "%F{green}▍%f"    #    Complete: Green
    "%B%F{red}▍%f%b"  #       Error: Light Red
)



# Prepends a series of progress chevron to the original RPROMPT defined by the theme
# Output chevron in brown for incomplete status
# Output chevron in green for complete status
# Accepts a number that represents the current state
# ------------------------------------------------------------------------------
__alf-rprompt-chevron() {
  # Set the previous chevron to complete
  ALF_CONFIG_RPROMPT_PROGRESS_ARRAY[$ALF_CONFIG_RPROMPT_PROGRESS_CURRENT]=3
  # Increment the current indicator
  ALF_CONFIG_RPROMPT_PROGRESS_CURRENT=$((ALF_CONFIG_RPROMPT_PROGRESS_CURRENT+1))
  # Check to see if our progress is complete
  if [[ $ALF_CONFIG_RPROMPT_PROGRESS_CURRENT -le ${#ALF_CONFIG_RPROMPT_PROGRESS_ARRAY} ]]; then
    # Set the current chevron to in progress
    ALF_CONFIG_RPROMPT_PROGRESS_ARRAY[$ALF_CONFIG_RPROMPT_PROGRESS_CURRENT]=2
  else
    # Progress is complete
    plog "rprompt-update" "progress complete"
    ALF_CONFIG_RPROMPT_PROGRESS_COMPLETE=1
  fi
  # Reset the progress string
  alf_rprompt_progress_string=""
  for chevron in ${ALF_CONFIG_RPROMPT_PROGRESS_ARRAY}; do
    alf_rprompt_progress_string="${alf_rprompt_progress_string}${ALF_CONFIG_RPROMPT_PROGRESS_CHEVRON[$chevron]}"
  done
  echo -n "$alf_rprompt_progress_string $ALF_CONFIG_RPROMPT_ID $(cat $ALF_CONFIG_RPROMPT_ORIGINAL)" > $ALF_CONFIG_RPROMPT_NEW
  plog "rprompt-update" "chevron $(cat $ALF_CONFIG_RPROMPT_NEW)"
  RPROMPT='$(cat $ALF_CONFIG_RPROMPT_NEW)'
  if [[ -n $ALF_CONFIG_RPROMPT_PROGRESS_COMPLETE ]]; then
    {
      sleep 1
      plog "rprompt-update" "set progress status to 1"
      __alf-config-rprompt-status-update 1
    } &!
  fi
}

# Prepends a custom message to the original RPROMPT defined by the theme
# Output is in magenta
# ------------------------------------------------------------------------------
__alf-rprompt-update() {
  echo -n "%F{magenta}${1} ${ALF_CONFIG_RPROMPT_ID}%f $(cat $ALF_CONFIG_RPROMPT_ORIGINAL)" > $ALF_CONFIG_RPROMPT_NEW
  plog "rprompt-update" "update $(cat $ALF_CONFIG_RPROMPT_NEW)"
  RPROMPT='$(cat $ALF_CONFIG_RPROMPT_NEW)'
}

# Prepends a custom message to the original RPROMPT defined by the theme
# Output is in red
# ------------------------------------------------------------------------------
__alf-rprompt-update-error() {
  echo -n "%F{red}${1} ${ALF_CONFIG_RPROMPT_ID}%f $(cat $ALF_CONFIG_RPROMPT_ORIGINAL)" > $ALF_CONFIG_RPROMPT_NEW
  plog "rprompt-update" "update-error $(cat $ALF_CONFIG_RPROMPT_NEW)"
  RPROMPT='$(cat $ALF_CONFIG_RPROMPT_NEW)'
}

# Prepends a custom message to the original RPROMPT defined by the theme
# Output is in red
# ------------------------------------------------------------------------------
__alf-rprompt-update-success() {
  echo -n "%F{green}${1} ${ALF_CONFIG_RPROMPT_ID}%f $(cat $ALF_CONFIG_RPROMPT_ORIGINAL)" > $ALF_CONFIG_RPROMPT_NEW
  plog "rprompt-update" "update-success $(cat $ALF_CONFIG_RPROMPT_NEW)"
  RPROMPT='$(cat $ALF_CONFIG_RPROMPT_NEW)'
}

# Resets the original RPROMPT back to the original state defined by the theme
# ------------------------------------------------------------------------------
__alf-rprompt-reset() {
  plog "rprompt-update" "reset"
  RPROMPT=$(echo "$(cat $ALF_CONFIG_RPROMPT_ORIGINAL)")
}

# Update the rprompt status
# ------------------------------------------------------------------------------
__alf-config-rprompt-status-update() {
  plog "rprompt-update" "ALF_RPROMPT_STATUS=${1}"
  echo "ALF_RPROMPT_STATUS=${1}" > $ALF_CONFIG_RPROMPT_STATUS
}



# ------------------------------------------------------------------------------
# __alf-rprompt: Right prompt status message
# ------------------------------------------------------------------------------
__alf-rprompt() {
  # Accepts an optional flag
  # ----------------------------------------------------------------------------
  while getopts "xpPwEesm" opt; do
    [[ $opt == "x" ]] && option=1 # Stop processing updates and reset message back to original RPROMPT
    [[ $opt == "p" ]] && option=2 # Output progress with chevrons and show current chevron as in progress [light green].
    [[ $opt == "P" ]] && option=3 # Output progress with chevrons and show current chevron as completed [green]
    [[ $opt == "w" ]] && option=4 # Output progress with chevrons and show current chevron as a warning [yellow]
    [[ $opt == "E" ]] && option=5 # Output progress with chevrons and show current chevron as a error [red]
    [[ $opt == "e" ]] && option=6 # Output error message
    [[ $opt == "s" ]] && option=7 # Output success message
    [[ $opt == "m" ]] && option=8 # Output message
  done

  # Shift the params if an option exists
  if [[ -n $option ]]; then
    shift
  else
  option=8
  fi

  case $option in
    2)
      # -p = 2: Output progress with chevrons and show current chevron as in progress [light green]
      # If an argument is passed then set total number of chevron to display and start
      # the progress at the beginning.
      if [[ -n $1 ]]; then
        ALF_CONFIG_RPROMPT_PROGRESS_ARRAY=($(for i in `seq $1`; do echo "1"; done | xargs echo))
        ALF_CONFIG_RPROMPT_PROGRESS_CURRENT=1
      fi
      __alf-rprompt-chevron
      __alf-config-rprompt-status-update $option
      TMOUT=1
      ;;
    [3-5])
      # -P = [3-5]: Output progress with chevrons
      __alf-rprompt-chevron
      __alf-config-rprompt-status-update $option
      TMOUT=1
      ;;
    [6-8])
      # -s = [6-8]: Output error, success, or default message
      __alf-rprompt-update-success $1
      __alf-config-rprompt-status-update $option
      TMOUT=1
      ;;
    *)
      # -x = [1|*]: Stop processing updates and reset message back to original RPROMPT
      __alf-config-rprompt-status-update 1
      ;;
  esac
}


plog -d "rprompt-update"
setopt prompt_subst


# Store a reference to any RPROMPTS that have been set by a theme
# ------------------------------------------------------------------------------
echo -n "$RPROMPT" > $ALF_CONFIG_RPROMPT_ORIGINAL


# Update the RPROMPT to display the original RPROMPT along with any message we
# want to send to it
# ------------------------------------------------------------------------------
TMOUT=1
TRAPALRM() {
  plog "rprompt-update" "[ TRAPALRM ]"
  if [[ -f "$ALF_CONFIG_RPROMPT_STATUS" ]]; then
    source "$ALF_CONFIG_RPROMPT_STATUS"
    case $ALF_RPROMPT_STATUS in
      # Stop processing updates and reset message back to original RPROMPT
      1)
        __alf-rprompt-reset
        zle reset-prompt
        ALF_CONFIG_RPROMPT_PROGRESS_ARRAY=()
        ALF_CONFIG_RPROMPT_PROGRESS_CURRENT=1
        [[ -f "$ALF_CONFIG_RPROMPT_ORIGINAL" ]] && rm "$ALF_CONFIG_RPROMPT_ORIGINAL"
        [[ -f "$ALF_CONFIG_RPROMPT_NEW" ]] && rm "$ALF_CONFIG_RPROMPT_NEW"
        [[ -f "$ALF_CONFIG_RPROMPT_STATUS" ]] && rm "$ALF_CONFIG_RPROMPT_STATUS"
        plog "rprompt-update" "[ TRAPALRM ] | TMOUT: ${TMOUT}##"
        unset TMOUT
        ;;
      # Start processing updates
      *)
        TMOUT=1
        zle reset-prompt
        plog "rprompt-update" "[ TRAPALRM ] - status: $ALF_RPROMPT_STATUS | TMOUT: ${TMOUT}##"
        ;;
    esac
  fi
}
