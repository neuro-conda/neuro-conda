#!/bin/bash
#
# Install conda + env in macOS + Linux
#
# This script is loosely based on the Homebrew installer (albeit heavliy truncated):
# https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

# TODO:
# - check if we really need $USER; we probably do for debugging...

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
CondaDownloadDirectory="${HOME}/.local/downloads"
CondaDownloadTarget="${CondaDownloadDirectory}/miniconda.sh"
NeuroCondaLatestUrl="https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/envs/neuro-conda-latest.yml"
NeuroCondaLatestTarget="${CondaDownloadDirectory}/neuro-conda-latest.yml"
NeuroCondaDate=$(date +"%Y_%m_%d")

# ----------------------------------------------------------------------
#   CHECK ENVIRONMENT
# ----------------------------------------------------------------------

# Start actual script execution
debug "Installation started at $(date)"
tic=`date +%s`

# USER isn't always set so provide a fallback for the installer and subprocesses.
if [[ -z "${USER-}" ]]; then
  USER="$(chomp "$(id -un)")"
  export USER
fi
debug "Running as user ${USER}"

# First ensure OS and machine architecture are supported
OS="$(uname)"
mArch=`uname -m`
debug "Detected ${OS} running on ${mArch}"
if [[ "${OS}" == "Linux" ]]; then
  if [[ "${mArch}" == "x86_64" ]]; then
    MinicondaLatestUrl="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
  elif [[ "${mArch}" == "arm64" ]]; then
    MinicondaLatestUrl="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
  elif [[ "${mArch}" == "ppc64le" ]]; then
    MinicondaLatestUrl="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-ppc64le.sh"
  else
    error "Unsupported platform: ${mArch}"
  fi
elif [[ "${OS}" == "Darwin" ]]; then
  if [[ "${mArch}" == "arm64" ]]; then
    MinicondaLatestUrl="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
  elif [[ "${mArch}" == "x86_64" ]]; then
    MinicondaLatestUrl="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
  else
    error "Unsupported platform: ${mArch}"
  fi
else
  error "This neuro-conda installer only supports macOS and Linux."
fi

# Ensure all necessary tools are available
curlPath=`command -v curl`
if [[ -z "${curlPath-}" ]]; then
  error "cURL not found. Please install cURL before installing neuro-conda. "
fi
debug "Found cURL: ${curlPath}"
mkdirPath=`command -v mkdir`
if [[ -z "${mkdirPath-}" ]]; then
  error 'mkdir not available. Please ensure `mkdir` works before installing neuro-conda. '
fi
debug "Found mkdir: ${mkdirPath}"
rmPath=`command -v rm`
if [[ -z "${rmPath-}" ]]; then
  error 'rm not available. Please ensure `rm` works before installing neuro-conda. '
fi
debug "Found rm: ${rmPath}"
chmodPath=`command -v chmod`
if [[ -z "${chmodPath-}" ]]; then
  error 'chmod not available. Please ensure `chmod` works before installing neuro-conda. '
fi
debug "Found chmod: ${chmodPath}"

# Display a warning message in case we're running non-interactively
if [[ ! -z "${ncNoninteractive-}" ]]; then
  warn "Running in non-interactive mode - will not prompt for input!"
fi

# ----------------------------------------------------------------------
#   PERFORM INSTALLATION
# ----------------------------------------------------------------------

# First, check if another conda version is already installed and initialized
condaPath=`command -v conda`
if [[ ! -z "${condaPath-}" ]]; then
  existingConda=`dirname $(dirname $CONDA_EXE)`
  if [[ -z "${ncNoninteractive-}" ]]; then
    warn "conda is already installed and initialized. Do you really want to install neuro-conda alongside the version in ${existingConda}?"
    user_input
  else
    info "Installing neuro-conda alongside ${existingConda}"
  fi
  # Deactivate all active conda environments
  for i in $(seq ${CONDA_SHLVL}); do
    conda deactivate
    debug "Deactivated pre-installed conda environment"
  done
fi

# Set up temp directory as download target
if [[ ! -d "${CondaDownloadDirectory}" ]]; then
  execute "mkdir" "-p" "${CondaDownloadDirectory}"
  debug "Created ${CondaDownloadDirectory}"
fi

# Install conda
if [[ ! -f "${CondaInstallationDirectory}/bin/conda" ]]; then
  if [[ ! -f "${CondaDownloadTarget}" ]]; then
    info "Downloading miniconda3..."
    execute "curl" "-fsSL" "${MinicondaLatestUrl}" "-o" "${CondaDownloadTarget}"
    debug "Downloaded ${MinicondaLatestUrl} to ${CondaDownloadTarget}"
  else
    debug "${CondaDownloadTarget} exists, miniconda has already been downloaded"
  fi
  execute "chmod" "550" "${CondaDownloadTarget}"
  debug "Made ${CondaDownloadTarget} executable"
  info "Installing conda..."
  execute "${CondaDownloadTarget}" "-b" "-p" "${CondaInstallationDirectory}"
  info "Installed miniconda into ${CondaInstallationDirectory}"
else
  info "miniconda3 is already installed"
fi

# Backup current shell config
if [[ -f "${HOME}/.bashrc" ]]; then
  execute "cp" "${HOME}/.bashrc" "${HOME}/.bashrc.neuro-conda.backup-${NeuroCondaDate}"
  debug "backed up ~/.bashrc"
fi
if [[ -f "${HOME}/.zshrc" ]]; then
  execute "cp" "${HOME}/.zshrc" "${HOME}/.zshrc.neuro-conda.backup-${NeuroCondaDate}"
  debug "backed up ~/.zshrc"
fi

# Initialize shell (we're running inside a bash, so use conda.sh)
execute "source" "${CondaInstallationDirectory}/etc/profile.d/conda.sh"
execute "conda" "init" "zsh"
execute "conda" "init" "bash"
debug "Ran conda init for zsh and bash"

# Check if conda command is available (i.e., if the above worked as intended)
condaPath=`command -v conda`
if [[ -z "${condaPath-}" ]]; then
  error 'conda not available. Something went wrong with initializing conda. '
fi
debug "Found new conda at ${condaPath}"

# Update conda
execute "conda" "update" "-n" "base" "conda" "-c" "defaults" "-y"
debug "Updated conda itself"

# Install mamba for faster dependency resolution
execute "conda" "install" "mamba" "-n" "base" "-c" "conda-forge" "-y"
debug "Installed mamba"

# Download latest neuro-conda environment (if necessary)
info "Creating latest neuro-conda environment"
if [[ ! -f "${NeuroCondaLatestTarget}" ]]; then
  execute "curl" "-fsSL" "${NeuroCondaLatestUrl}" "-o" "${NeuroCondaLatestTarget}"
  debug "Downloaded ${NeuroCondaLatestUrl} to ${NeuroCondaLatestTarget}"
else
  debug "${NeuroCondaLatestTarget} exists, environment file has already been downloaded"
fi

# Install neuro-conda environment (remove previously existing env of the same name)
execute "${CondaInstallationDirectory}/bin/mamba" "env" "create" "--file" "${NeuroCondaLatestTarget}" "--force"

# Try to activate environment as most basal sanity check
envName=`cat ${NeuroCondaLatestTarget} | grep "name:" | awk '{print $2}'`
execute "conda" "activate" "${envName}"
debug "Activated ${envName}"
if [[ -z "$(command -v python | grep ${CondaInstallationDirectory})" ]]; then
  error "Environment ${envName} was not installed correclty"
fi

# Install editor if requested
if [[ ! -z "${ncEditor-}" ]]; then
  execute "mamba" "install" "spyder"
  debug "Variable ncEditor is set, installed Spyder"
fi

# Do not activate base environment upon startup...
execute "conda" "config" "--set" "auto_activate_base" "false"
debug "Turned off auto-activation of base environment"

# ...but instead activate neuro-conda environment
echo "conda activate ${envName}" >> "${HOME}/.bashrc"
echo "conda activate ${envName}" >> "${HOME}/.zshrc"
debug "Auto-activate ${envName}"

# Everything works, remove tmp dir
info "Cleaning up"
execute "rm" "-rf" "${CondaDownloadDirectory}"
info "All done."
info "Please close this window and open a new terminal to start using neuo-conda"

# If we're debugging, print timing info
toc=`date +%s`
runtime=$((toc-tic))
runHrs=$((runtime / 3600)); runMin=$(( (runtime % 3600) / 60 )); runSec=$(( (runtime % 3600) % 60 ))
debug "Installation finished. Runtime: ${runHrs}:${runMin}:${runSec} (hh:mm:ss)"

exit 0
