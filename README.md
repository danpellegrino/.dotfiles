# Dotfiles

This repository contains my personal dotfiles configuration.

## Requirements

Before installing these dotfiles, ensure you have the following prerequisite installed:

- **GNU Stow:** Stow is a symlink farm manager which will be used to manage the symlinks for these dotfiles.
  - Installation instructions: [GNU Stow Installation](https://www.gnu.org/software/stow/)

### Installing GNU Stow

Below are instructions for installing `GNU Stow` on different Linux distributions:

#### Debian/Ubuntu

```bash
sudo apt update
sudo apt install stow
```

#### Red Hat based (RHEL, CentOS, Fedora)

```bash
sudo yum install stow      # For RHEL and CentOS
# OR
sudo dnf install stow      # For Fedora
```

#### Arch Linux

```bash
sudo pacman -S stow
```

#### openSUSE

```bash
sudo zypper install stow
```

#### Void Linux

```bash
sudo xbps-install -S stow
```

#### Alpine Linux

```bash
sudo apk add stow
```

## Installation

To install these dotfiles, follow these steps:

1. **Clone the repository:**

    ```bash
    git clone https://github.com/danpellegrino/.dotfiles.git
    # OR
    git clone --recurse-submodules https://github.com/danpellegrino/.dotfiles.git      # To clone submodules (nvim,personal)
    ```

2. **Navigate to the dotfiles directory:**

    ```bash
    cd .dotfiles
    ```

3. **Run the install script:**

    ```bash
    chmod +x install.sh
    sudo ./install.sh <user>
    ```

## What's Included

- `alacritty`: Configuration files for Alacritty terminal emulator.
- `bin`: Custom scripts or executables.
- `i3`: Configuration files for the i3 window manager.
- `nvim`: Configuration files for Neovim text editor.
- `ohmyzsh`: Submodule for [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh).
- `personal`: Personal configurations or miscellaneous files.
- `picom`: Configuration for picom, a compositor for X11.
- `sxhkd`: Configuration files for sxhkd, a X hotkey daemon.
- `tmux`: Configuration files for tmux terminal multiplexer.
- `x11`: X11 configuration files.
- `xorg.conf.d`: Additional Xorg configuration files.
- `zsh`: Configuration files for the Zsh shell.
