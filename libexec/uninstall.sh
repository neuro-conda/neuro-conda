#!/bin/bash
#
# Uninstall neuro-conda + env in macOS + Linux
#
# This script is loosely based on the Homebrew uninstaller (albeit heavliy truncated):
# https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh

# TODO:
# - do we need a dry-run option?

# ----------------------------------------------------------------------
#   CHECK SHELL
# ----------------------------------------------------------------------

# Keep it simple in case we're running in a POSIX-shell
posix_abort() {
  printf "ERROR: %s\n" "$@" >&2
  exit 1
}

# Fail fast with a concise message when not using bash
# Single brackets are needed here for POSIX compatibility
# shellcheck disable=SC2292
if [ -z "${BASH_VERSION:-}" ]
then
  posix_abort "Bash is required to interpret this script."
fi

# ----------------------------------------------------------------------
#   PREPARE STDOUT
# ----------------------------------------------------------------------

# String formatters to prettify output
if [[ -t 1 ]]; then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi
tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_blue="$(tty_mkbold 34)"
tty_green="$(tty_mkbold 32)"
tty_magenta="$(tty_mkbold 35)"
tty_red="$(tty_mkbold 31)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

shell_join()
{
  local arg
  printf "%s" "$1"
  shift
  for arg in "$@"
  do
    printf " "
    printf "%s" "${arg// /\ }"
  done
}

chomp()
{
  printf "%s" "${1/"$'\n'"/}"
}

debug()
{
  if [[ ! -z "${ncDebug-}" ]]; then
    printf "${tty_green}DEBUG: ${tty_reset}%s\n" "$(shell_join "$@")"
  fi
}

info()
{
  printf "${tty_blue}===${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

warn()
{
  printf "${tty_magenta}WARNING:${tty_bold} %s${tty_reset}\n" "$(chomp "$1")"
}

error()
{
  printf "${tty_red}ERROR:${tty_bold} %s${tty_reset}\n" "$(chomp "$1")"
  exit 1
}

# ----------------------------------------------------------------------
#   CUSTOM FUNCTIONS AND SETTINGS
# ----------------------------------------------------------------------

# Command executor: eval string and catch errors
execute() {
  if ! "$@"
  then
    error "$(printf "Failed during: %s" "$(shell_join "$@")")"
  fi
}

# Blocking wait for user input
user_input() {
  local ans save_state
  echo
  echo "Press ${tty_bold}RETURN${tty_reset}/${tty_bold}ENTER${tty_reset} to continue or any other key to abort:"
  save_state="$(/bin/stty -g)"
  /bin/stty raw -echo
  IFS='' read -r -n 1 -d '' "ans"
  /bin/stty "${save_state}"
  # we test for \r and \n because some stuff does \r instead
  if ! [[ "${ans}" == $'\r' || "${ans}" == $'\n' ]]
  then
    exit 1
  fi
}

# Config file restore
config_restore() {
  configFile="$1"
  configBackup=`find "${HOME}" -maxdepth 1 -mindepth 1 -type f -name "${configFile}"'.neuro-conda.backup*'`
  if [[ ! -z "${configBackup}" ]]; then
    info "Restoring ${configFile} configuration backup"
    execute "mv" "${configBackup}" "${HOME}/${configFile}"
  else
    info "No ${configFile} configuration backup found. Manually removing conda init from ${configFile}"
    execute "conda" "init" "--reverse"
    debug "Ran conda init reverse"
    execute "awk" '{gsub("conda activate neuro-conda", "# conda activate neuro-conda"); print}' "${HOME}/${configFile}" >| "${HOME}/.tmp${configFile}"
    execute "mv" "${HOME}/.tmp${configFile}" "${HOME}/${configFile}"
    debug "Removed 'conda activate neuro-conda*' from ~/${configFile}"
  fi
}

# (Try to) fetch neuro-conda installation directory from config file(s)
get_condabinpath() {
  configFile="$1"
  if test -f "${configFile}"; then condaBinPath=`awk -F"'" '/__conda_setup/{print $2}' "${configFile}"`; fi
  return
}

# Default neuro-conda installation directory
CondaInstallationDirectory="${HOME}/.local/miniforge"

# ----------------------------------------------------------------------
#   CHECK ENVIRONMENT
# ----------------------------------------------------------------------

# Start actual script execution
debug "Uninstall script started at $(date)"
tic=`date +%s`

# USER isn't always set so provide a fallback for the installer and subprocesses.
if [[ -z "${USER-}" ]]; then
  USER="$(chomp "$(id -un)")"
  export USER
fi
debug "Running as user ${USER}"

rmPath=`command -v rm`
if [[ -z "${rmPath-}" ]]; then
  error 'rm not available. Please ensure `rm` works before installing neuro-conda. '
fi
debug "Found rm: ${rmPath}"

# Check if script is executed by a CI runner
if [[ ! -z "${ncCI-}" ]]; then
  info "Running inside CI pipeline, turning on non-interactive mode"
  ncNoninteractive=1
fi

# Display a warning message in case we're running non-interactively
if [[ ! -z "${ncNoninteractive-}" ]]; then
  warn "Running in non-interactive mode - will not prompt for input!"
fi

# ----------------------------------------------------------------------
#   UNINSTALL
# ----------------------------------------------------------------------

# Use helper to set `condaBinPath`
configFile="${HOME}/.bashrc"
get_condabinpath "${HOME}/.bashrc"
if [[ -z "${condaBinPath-}" ]]; then
  get_condabinpath "${HOME}/.zshrc"
fi

# Abort if no conda installation was found
if [[ -z "${condaBinPath-}" ]]; then
  error "No neuro-conda installation found on this system. Exiting..."
fi

# Check if we're working with a default installation
if [[ "${condaBinPath}" == *"${CondaInstallationDirectory}"* ]]; then
  debug "Found neuro-conda in default location"
else
  CondaInstallationDirectory="${condaBinPath%%/bin/conda}"
  warn "Found non-standard neuro-conda installation at ${CondaInstallationDirectory}"
  if [[ -z "${ncNoninteractive-}" ]]; then
    warn "Do you want to proceed removing this installation?"
    user_input
  fi
fi

# Check if there's even anything to uninstall
if [[ ! -d "${CondaInstallationDirectory}" ]]; then
  error "The directory ${CondaInstallationDirectory} does not exist. Exiting..."
fi

# Be specific: show which conda installation we're about to wipe
info "About to remove the conda installation found in ${CondaInstallationDirectory}"
if [[ -z "${ncNoninteractive-}" ]]; then
  user_input
fi

# Initialize shell (we're running inside a bash, so use conda.sh)
execute "source" "${CondaInstallationDirectory}/etc/profile.d/conda.sh"
debug "Sourced ${CondaInstallationDirectory}/etc/profile.d/conda.sh"

# If deletion candidate does not contain a neuro-conda environment, ask for confirmation...
if [[ ! -z "$(command -v conda)" ]]; then
  if [[ -z "$(conda env list | grep neuro-conda)" ]]; then
    if [[ -z "${ncNoninteractive-}" ]]; then
      warn "neuro-conda environment NOT found in ${CondaInstallationDirectory}. Are you sure you want to delete this installation?"
      user_input
    else
      warn "Removing ${CondaInstallationDirectory} despite it not containing a neuro-conda environment"
    fi
  fi
else
  info "Could not initialize conda in ${CondaInstallationDirectory}. Continuing anyway."
fi

# Check if shell RC backup files exist and restore them
if [[ -f "${HOME}/.bashrc" ]]; then
  config_restore ".bashrc"
fi
if [[ -f "${HOME}/.zshrc" ]]; then
  config_restore ".zshrc"
fi

# Now wipe the actual installation directory
info "Removing conda located in ${CondaInstallationDirectory}"
execute "rm" "-rf" "${CondaInstallationDirectory}"
info "All done."
info "Please close this window and open a new terminal."

# If we're debugging, print timing info
toc=`date +%s`
runtime=$((toc-tic))
runHrs=$((runtime / 3600)); runMin=$(( (runtime % 3600) / 60 )); runSec=$(( (runtime % 3600) % 60 ))
debug "Removal finished. Runtime: ${runHrs}:${runMin}:${runSec} (hh:mm:ss)"

exit 0
