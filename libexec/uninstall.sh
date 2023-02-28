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

# Check if script is run in POSIX mode
if [[ -n "${POSIXLY_CORRECT+1}" ]]
then
  posix_abort 'Bash must not run in POSIX mode. Please unset POSIXLY_CORRECT and try again.'
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

# All neuro-conda specific env vars
CondaInstallationDirectory="${HOME}/.local/miniconda3"

# ----------------------------------------------------------------------
#   CHECK ENVIRONMENT
# ----------------------------------------------------------------------

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

# Display a warning message in case we're running non-interactively
if [[ ! -z "${ncNoninteractive-}" ]]; then
  warn "Running in non-interactive mode - will not prompt for input!"
fi

# ----------------------------------------------------------------------
#   UNINSTALL
# ----------------------------------------------------------------------

# Be specific: show which conda installation we're about to wipe
info "About to remove the conda installation found in ${CondaInstallationDirectory}"
if [[ -z "${ncNoninteractive-}" ]]; then
  user_input
fi

# Initialize shell (we're running inside a bash, so use conda.sh)
execute "source" "${CondaInstallationDirectory}/etc/profile.d/conda.sh"
debug "Sourced ${CondaInstallationDirectory}/etc/profile.d/conda.sh"

# If deletion candidate does not contain a neuro-conda environment, ask for confirmation...
if [[ -z "$(conda env list | grep neuro-conda)" ]]; then
  if [[ -z "${ncNoninteractive-}" ]]; then
    warn "neuro-conda environment NOT found in ${CondaInstallationDirectory}. Are you sure you want to delete this installation?"
    user_input
  else
    info "Removing ${CondaInstallationDirectory} despite it not containing a neuro-conda environment"
fi

# Check if shell RC backup files exist and restore them if wanted
bashrcBackup=`find "${HOME}" -maxdepth 1 -mindepth 1 -type f -name '.bashrc.neuro-conda.backup*'`
if [[ ! -z "${bashrcBackup}" ]]; then
  info "Restoring bash configuration backup"
  execute "mv" "bashrcBackup" "${HOME}/.bashrc"
else
  info "No bash configuration backup found. Manually Removing conda init from bash config"
  execute "conda" "init" "--reverse"
  debug "Ran conda init reverse"
  execute "awk" '{gsub("conda activate neuro-conda", "# conda activate neuro-conda"); print}' "${HOME}/.bashrc" >| "${HOME}/.tmp.bashrc"
  execute "mv" "${HOME}/.tmp.bashrc" "${HOME}/.bashrc"
  debug "Removed 'conda activate neuro-conda*' from ~/.bashrc"
fi
zshrcBackup=`find "${HOME}" -maxdepth 1 -mindepth 1 -type f -name '.zshrc.neuro-conda.backup*'`
if [[ ! -z "${zshrcBackup}" ]]; then
  info "Restoring zsh configuration backup"
  execute "mv" "zshrcBackup" "${HOME}/.zshrc"
else
  info "No zsh configuration backup found. Manually Removing conda init from zshell config"
  execute "conda" "init" "--reverse"
  debug "Ran conda init reverse"
  execute "awk" '{gsub("conda activate neuro-conda", "# conda activate neuro-conda"); print}' "${HOME}/.zshrc" >| "${HOME}/.tmp.zshrc"
  execute "mv" "${HOME}/.tmp.zshrc" "${HOME}/.zshrc"
  debug "Removed 'conda activate neuro-conda*' from ~/.zshrc"
fi

# Now wipe the actual installation directory
info "Removing conda located in ${CondaInstallationDirectory}"
execute "rm" "-rf" "${CondaInstallationDirectory}"
info "All done."
info "Please close this window and open a new terminal. "

exit 0
