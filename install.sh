#!/usr/bin/env bash

# install.sh
 # Author: Daniel Pellegrino
 # Date Created: 12/31/2023
 # Last Modified: 1/11/2024
 # Description: Installs the dotfiles in this repo.

# Usage: sudo ./install.sh <user>

# Variables
ENV_FILE="personal/.config/personal/env"
XCONF_DOTFILES="xorg.conf.d/"
XCONF_FOLDER="/usr/share/X11/xorg.conf.d/"

main ()
{
  # Make sure the user is in root
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
  fi

  # Check if the user passed in a user to install the dotfiles for
  if [ $# -eq 1 ]; then
    NORMAL_USER="$1"

    # Verify the user exists
    if ! id "$NORMAL_USER" &> /dev/null; then
      echo "The user $NORMAL_USER does not exist. Please enter a valid user."
      exit 1
    fi
  else
    echo "Please enter a user to install the dotfiles for."
    echo "Usage: sudo ./install.sh <user>"
    exit 1
  fi

  # Verify the user has required programs
  if ! command -v sudo &> /dev/null; then
    echo "Sudo is not installed. Please install it."
    exit 1
  fi
  if ! command -v getent &> /dev/null; then
    echo "Getent is not installed. Please install it."
    exit 1
  fi
  if ! command -v stow &> /dev/null; then
    echo "Stow is not installed. Please install it."
    exit 1
  fi
  if ! command -v git &> /dev/null; then
    echo "Git is not installed. Please install it."
    exit 1
  fi
  if ! command -v tmux &> /dev/null; then
    echo "Tmux is not installed. Please install it."
    exit 1
  fi
  if ! command -v nvim &> /dev/null; then
    echo "Neovim is not installed. Please install it."
    exit 1
  fi

  # Remember the current directory
  CURRENT_DIR=$(pwd)

  # Find the directory of the script
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

  # Change to the directory of the script
  cd "$SCRIPT_DIR"

  stow_dotfiles

  xorgrules

  # Change back to the original directory
  cd "$CURRENT_DIR"
}

# Functions
stow_dotfiles ()
{
  # Check if the env file exists
  if [ ! -f "$ENV_FILE" ]; then
    echo "The env file does not exist. Please create it."
    exit 1
  fi

  # Source the env file
  source "$ENV_FILE"

  # Verify the STOW_FOLDERS variable is set
  if [ -z "$STOW_FOLDERS" ]; then
    echo "The STOW_FOLDERS variable is not set. Something went wrong with grabbing the env file."
    exit 1
  fi

  # The $STOW_FOLDERS variable is a comma separated list of folders to stow
  folders=(${STOW_FOLDERS//,/ })

  # Find the home directory of the user
  NORMAL_USER_HOME=$(getent passwd "$NORMAL_USER" | cut -d: -f6)
  
  # Install the dotfiles
  for folder in "${folders[@]}"; do
    echo "Installing $folder."
    sudo -u "$NORMAL_USER" stow --no-folding -vt "$NORMAL_USER_HOME" "$folder"
    # Install the tmux plugins
    if [ $folder == "tmux" ]; then
      sudo -u "$NORMAL_USER" tmux source-file "$NORMAL_USER_HOME/.tmux.conf"
      if [ ! -d "$NORMAL_USER_HOME/.tmux/plugins/tpm" ]; then
        echo "Installing tmux plugin manager."
        sudo -u "$NORMAL_USER" git clone https://github.com/tmux-plugins/tpm "$NORMAL_USER_HOME/.tmux/plugins/tpm"
      fi
      sudo -u "$NORMAL_USER" $NORMAL_USER_HOME/.tmux/plugins/tpm/bin/install_plugins
    fi
    # Install the neovim plugins
    if [ $folder == "nvim" ]; then
      # Lazy load the plugins
      sudo -u "$NORMAL_USER" nvim --headless "+Lazy! sync" +qa
    fi
  done
}

xorgrules ()
{
  # Check if the xorg.conf.d folder exists
  if [ ! -d "$XCONF_FOLDER" ]; then
    echo "The xorg.conf.d folder does not exist. Creating it."
    mkdir -pv "$XCONF_FOLDER"
  fi

  # Copy the xorg.conf.d folder to the xorg.conf.d folder
  cp -rv "$XCONF_DOTFILES"* "$XCONF_FOLDER"
}

# Main
main "$@"
