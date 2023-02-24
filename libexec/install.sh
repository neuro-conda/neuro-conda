#!/bin/bash
#
# Install conda + env in macOS + Linux
#
# This script is loosely based on the Homebrew installer (albeit heavliy truncated):
# https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

# TODO:
# - include debug prints!
# - check if really need $USER

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
  printf "${tty_green}DEBUG: ${tty_reset}%s\n" "$(shell_join "$@")"
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

CondaInstallationDirectory="${HOME}/.local/miniconda3"
CondaDownloadDirectory="${HOME}/.local/downloads"
CondaDownloadTarget="${CondaDownloadDirectory}/miniconda.sh"
NeuroCondaLatestUrl="https://raw.githubusercontent.com/neuro-conda/neuro-conda/main/envs/neuro-conda-latest.yml"
NeuroCondaLatestTarget="${CondaDownloadDirectory}/neuro-conda-latest.yml"

# ----------------------------------------------------------------------
#   CHECK ENVIRONMENT
# ----------------------------------------------------------------------

# USER isn't always set so provide a fallback for the installer and subprocesses.
if [[ -z "${USER-}" ]]; then
  USER="$(chomp "$(id -un)")"
  export USER
fi
if [[ ! -z "${DEBUG-}" ]]; then
  debug "Running as user ${USER}"
fi

# First ensure OS and machine architecture are supported
OS="$(uname)"
mArch=`uname -m`
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
if [[ ! -z "${DEBUG-}" ]]; then
  debug "Found cURL: ${curlPath}"
fi
mkdirPath=`command -v mkdir`
if [[ -z "${mkdirPath-}" ]]; then
  error 'mkdir not available. Please ensure `mkdir` works before installing neuro-conda. '
fi
if [[ ! -z "${DEBUG-}" ]]; then
  debug "Found mkdir: ${mkdirPath}"
fi
rmPath=`command -v rm`
if [[ -z "${rmPath-}" ]]; then
  error 'rm not available. Please ensure `rm` works before installing neuro-conda. '
fi
if [[ ! -z "${DEBUG-}" ]]; then
  debug "Found rm: ${rmPath}"
fi
chmodPath=`command -v chmod`
if [[ -z "${chmodPath-}" ]]; then
  error 'chmod not available. Please ensure `chmod` works before installing neuro-conda. '
fi
if [[ ! -z "${DEBUG-}" ]]; then
  debug "Found rm: ${chmodPath}"
fi

# ----------------------------------------------------------------------
#   PERFORM INSTALLATION
# ----------------------------------------------------------------------

# Set up temp directory as download target
if [[ ! -d "${CondaDownloadDirectory}" ]]; then
  execute "mkdir" "-p" "${CondaDownloadDirectory}"
fi

# Install conda
if [[ ! -f "${CondaInstallationDirectory}/bin/conda" ]]; then
  if [[ ! -f "${CondaDownloadTarget}" ]]; then
    info "Downloading miniconda3..."
    execute "curl" "-fsSL" "${MinicondaLatestUrl}" "-o" "${CondaDownloadTarget}"
  fi
  execute "chmod" "550" "${CondaDownloadTarget}"
  info "Installing conda..."
  execute "${CondaDownloadTarget}" "-b" "-p" "${CondaInstallationDirectory}"
  info "Installed miniconda into ${CondaInstallationDirectory}"
else
  info "miniconda3 is already installed"
fi

# Initialize shell (we're running inside a bash, so use conda.sh)
execute "source" "${CondaInstallationDirectory}/etc/profile.d/conda.sh"
execute "conda" "init" "zsh"
execute "conda" "init" "bash"

# Check if conda command is available (i.e., if the above worked as intended)
condaPath=`command -v conda`
if [[ -z "${condaPath-}" ]]; then
  error 'conda not available. Something went wrong with initializing conda. '
fi
if [[ ! -z "${DEBUG-}" ]]; then
  debug "Found conda: ${condaPath}"
fi

# Update conda
execute "conda" "update" "-n" "base" "conda" "-c" "defaults" "-y"

# Install mamba for faster dependency resolution
execute "conda" "install" "mamba" "-n" "base" "-c" "conda-forge" "-y"

# Download latest neuro-conda environment (if necessary)
if [[ ! -f "${NeuroCondaLatestTarget}" ]]; then
  info "Downloading latest neuro-conda environment"
  execute "curl" "-fsSL" "${NeuroCondaLatestUrl}" "-o" "${NeuroCondaLatestTarget}"
fi

# Install neuro-conda environment (remove previously existing env of the same name)
info "Creating latest neuro-conda environment"
execute "${CondaInstallationDirectory}/bin/mamba" "env" "create" "--file" "${NeuroCondaLatestTarget}" "--force"

# If everything works (should we test this?), remove tmp dir
info "Cleaning up"
execute "rm" "-rf" "${CondaDownloadDirectory}"
info "All done."

exit 0
