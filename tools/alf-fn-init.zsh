#!/usr/bin/env zsh
#
# Source this script to automatically step through each procedure function in
# your script. Allows for automatic resuming of your script if a break in your
# code is detected causing all of your procedure functions to not complete.
#
# Procedure functions will be unfunction'd upon successful completion.
#
# Author:
#   Larry Gordon
#
# Usage:
#   # Sourcing helper script to call all procedure functions in
#   # this script
#   # ----------------------------------------------------------
#   if [[ -s "$ALF_SRC_TOOLS/alf-fn-init.zsh" ]]; then
#     source "$ALF_SRC_TOOLS/alf-fn-init.zsh" $0
#   fi
#
# Notes:
#   Make sure you pass `$0` as a parameter when sourcing this script.
#
# License:
#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
# ------------------------------------------------------------------------------


# Setup variables, detect current progress, and execute each procedure function
# that is found in the script that sourced "alf-fn-init.zsh".
# ------------------------------------------------------------------------------
# Notes
# alf_fn_script_name=${0##*/}
# alf_fn_script_path=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd -P)/`basename "${BASH_SOURCE[0]}"`${alf_fn_script_name}
# ------------------------------------------------------------------------------
ppemphasis "Processing $(\
  echo ${1:t:r} | \
  sed -e 's/http.-//g' \
  -e 's/COLON-//g' \
  -e 's/SLASH-//g' \
  -e 's/--.*com-/-/g' \
  -e 's/-run-once-/: /g' \
  -e 's/-/ /g' | \
  perl -pe 's/\S+/\u$&/g'\
)"

if [[ -n $ALF_PRETTY_PRINT_VERBOSE ]]; then
  ppemphasis "Verbose Mode True"
fi



# Store a reference to the calling script
# ------------------------------------------------------------------------------
alf_fn_script_path=$1
ppverbose "alf_fn_script_path: " "$alf_fn_script_path"

alf_fn_script_namespace="${1:t:r}"
ppverbose "alf_fn_script_namespace: " "$alf_fn_script_namespace"



# Configure paths for conf files
# ------------------------------------------------------------------------------
alf_fn_config_breakpoint="$ALF_PROGRESS/${alf_fn_script_namespace}-progress.conf"
ppverbose "alf_fn_config_breakpoint: " "$alf_fn_config_breakpoint"

alf_fn_config_user_info="$ALF_PROGRESS/${alf_fn_script_namespace}-user-info.conf"
ppverbose "alf_fn_config_user_info: " "$alf_fn_config_user_info"

alf_fn_progress_result="$ALF_PROGRESS/${alf_fn_script_namespace}-progress-result.conf"
ppverbose "alf_fn_progress_result: " "$alf_fn_progress_result"



# Halt if we are already running this process
# ------------------------------------------------------------------------------
if [[ -n $(process -i $alf_fn_script_namespace) ]]; then
  ppverbose "Already processing $alf_fn_script_namespace [Alf]"
  return 0
else
  # Set processing status to true
  process -s "$alf_fn_script_namespace"
fi



# Remove previous results if they exist
# ------------------------------------------------------------------------------
if [[ -s $alf_fn_progress_result ]]; then
  rm $alf_fn_progress_result
fi



# Get all procedure functions in calling script
# ------------------------------------------------------------------------------
alf_fn_functions_array=(`cat $alf_fn_script_path | grep "^_alf-fn-" | cut -d\( -f 1`)
ppverbose "alf_fn_functions_array 1: " "$alf_fn_functions_array"
alf_fn_functions_array+=(`cat $alf_fn_script_path | grep "^function _alf-fn-" | cut -d\  -f 2 | cut -d\( -f 1`)
ppverbose "alf_fn_functions_array 2: " "$alf_fn_functions_array"

alf_fn_max_breakpoints=$((${#alf_fn_functions_array[@]}))
ppverbose "alf_fn_max_breakpoints: " "$alf_fn_max_breakpoints"



# Sourcing alf_fn_current_breakpoint info
# ------------------------------------------------------------------------------
if [[ -s $alf_fn_config_breakpoint ]]; then
  ppverbose "Sourcing: " "$alf_fn_config_breakpoint"
  source $alf_fn_config_breakpoint
fi
if [[ -z $alf_fn_current_breakpoint ]]; then
  ppverbose "No Breakponts set. Initializing: " "\$alf_fn_current_breakpoint"
  alf_fn_current_breakpoint=1
fi



# Output the current breakpoint
# ------------------------------------------------------------------------------
ppverbose "alf_fn_current_breakpoint: " "$alf_fn_current_breakpoint"



# Sourcing user info
# ------------------------------------------------------------------------------
ppverbose "Sourcing: " "$alf_fn_config_user_info"
if [[ -f "$alf_fn_config_user_info" ]]; then
  source "$alf_fn_config_user_info"
else
  touch "$alf_fn_config_user_info"
fi



# Process each function based on the alf_fn_current_breakpoint
# ------------------------------------------------------------------------------
ppverbose "Process each function based on the alf_fn_current_breakpoint"
for (( alf_fn_process_count=$alf_fn_current_breakpoint; alf_fn_process_count<=alf_fn_max_breakpoints; alf_fn_process_count++ )); do
  ppverbose "for: " "$alf_fn_process_count <= $alf_fn_max_breakpoints"


  # Exit if the next function doesn't exist
  ppverbose "Let's see if the next function exists and exit if it doesn't"
  if [[ -n "$(whence -w ${alf_fn_functions_array[$alf_fn_process_count]} | grep "function")" ]]; then
    # Saving the current alf_fn_current_breakpoint for auto resuming of this script
    ppverbose "Saving the current alf_fn_current_breakpoint for auto resuming of this script"
    ppverbose "- alf_fn_current_breakpoint = " "$alf_fn_process_count"
    echo "alf_fn_current_breakpoint=$alf_fn_process_count" > $alf_fn_config_breakpoint

    # Execute the current procedure function
    ppverbose "Execute procedure function: " "${alf_fn_functions_array[$alf_fn_process_count]}"
    ${alf_fn_functions_array[$alf_fn_process_count]} 2> $alf_fn_progress_result

    # Output error and exit if there was a problem
    if [[ -n `cat $alf_fn_progress_result` ]]; then
      # Set processing status to false
      alf process -x "$alf_fn_script_namespace"
      ppdanger "An error was reported:"
      ppdanger "$(cat $alf_fn_progress_result)"
      return 0
    fi

    # Remove the shell function from the command hash table
    ppverbose "Removing shell function from the command hash table: " "${alf_fn_functions_array[$alf_fn_process_count]}"
    unfunction -m ${alf_fn_functions_array[$alf_fn_process_count]}
  else
    ppdanger -i "The following function does not exist:"
    ppwarning " ${alf_fn_functions_array[$alf_fn_process_count]}"
    return 0
  fi
done



# Remove temp files
# ------------------------------------------------------------------------------
ppverbose "Removing temp files:"
if [ -e $alf_fn_config_breakpoint ]; then
  ppverbose "- Removing: " "$alf_fn_config_breakpoint"
  rm -f $alf_fn_config_breakpoint
fi
if [ -e $alf_fn_config_user_info ]; then
  ppverbose "- Removing: " "$alf_fn_config_user_info"
  rm -f $alf_fn_config_user_info
fi
if [ -e $alf_fn_progress_result ]; then
  ppverbose "- Removing: " "$alf_fn_progress_result"
  rm -f $alf_fn_progress_result
fi



# ------------------------------------------------------------------------------
# Cleanup and remove the calling script if it's name contains "run-once"
if [[ -n $(echo ${1##*/} | grep "run-once") ]]; then
  ppverbose "- Removing: " "$1"
  rm -f $1
fi



# Script completed successfully
# ------------------------------------------------------------------------------
ppsuccess ""
ppsuccess "complete!"
if [[ -n $ALF_PRETTY_PRINT_VERBOSE ]]; then
  ppsuccess "- $alf_fn_script_path"
fi



# Set processing status to false
# ------------------------------------------------------------------------------
process -x "$alf_fn_script_namespace"



# Remove any local vars and functions from the command hash table
# ------------------------------------------------------------------------------
unset alf_fn_config_breakpoint
unset alf_fn_config_user_info
unset alf_fn_current_breakpoint
unset alf_fn_functions_array
unset alf_fn_max_breakpoints
unset alf_fn_option
unset alf_fn_process_count
unset alf_fn_progress_result
unset alf_fn_script_namespace
unset alf_fn_script_path
