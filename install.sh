#!/usr/bin/env bash

set -e
set -u
set -o pipefail

INSTALL_DIR="$HOME/Xidots"
WALLPAPERS_DIR="$HOME/Pictures/Wallpapers/"
DOTS_DIR="$INSTALL_DIR/dots/.config"
REPO_URL="https://github.com/Xitonight/Xidots"

install_aur_helper() {
  if ! command -v git &>/dev/null; then
    sudo pacman -Sy git
  fi
  aur_helper=""
  if command -v yay &>/dev/null; then
    aur_helper="yay"
    echo $aur_helper
  elif command -v paru &>/dev/null; then
    aur_helper="paru"
    echo $aur_helper
  else
    echo "Installing yay-bin..."
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    cd "$tmpdir/yay-bin"
    makepkg -si --noconfirm
    cd - >/dev/null
    rm -rf "$tmpdir"
    aur_helper="yay"
  fi
}

clone_repo() {
  if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$INSTALL_DIR" pull
  else
    echo "Cloning dotfiles..."
    git clone "$REPO_URL" "$INSTALL_DIR"
  fi
}

install_wallpapers() {
  if [ -d "$WALLPAPERS_DIR" ]; then
    echo "Updating wallpapers..."
    git -C "$WALLPAPERS_DIR" pull
  else
    echo "Cloning wallpapers..."
    git clone "https://github.com/Xitonight/papers.git" "$WALLPAPERS_DIR"
  fi
}

install_packages() {
  echo "Installing required packages..."
  grep -v '^$' "$INSTALL_DIR"/requirements.lst | sed '/^#/d' | $aur_helper -Syy --noconfirm --needed -
}

install_npm() {
  if command -v npm &>/dev/null; then
    echo "Installing node / npm..."
    nvm install node
    nvm install --lts
    nvm use node
  fi
}

stow_dots() {
  for dir in "$DOTS_DIR"/*; do
    if [ -d "$dir" ]; then
      folder_name=$(basename "$dir")
      target="$HOME/.config/$folder_name"

      # Check if the folder already exists in ~/.config
      if [ -d "$target" ]; then
        if [ -L "$target" ] && [ "$(readlink -f "$target")" == "$DOTFILES_DIR/$folder_name" ]; then
          echo "$folder_name is already correctly stowed, skipping backup."
        else
          backup="$target.bkp"

          # Ensure we don't overwrite an existing backup
          if [ -d "$backup" ]; then
            echo "Backup already exists for $folder_name, skipping..."
          else
            echo "Moving existing $folder_name to $backup"
            mv "$target" "$backup"
          fi
        fi
      fi
    fi
  done

  echo "Stowing dotfiles in $HOME"
  stow --target="$HOME" --dir="$INSTALL_DIR" dots
}

install_tmux_plugins() {
  if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    echo "TPM is not installed. Installing right now..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

setup_kanata() {
  if [[ -z "$(getent group uinput)" ]]; then
    sudo groupadd uinput
  fi

  sudo usermod -aG input "$USER"
  sudo usermod -aG uinput "$USER"

  if [ ! -e /etc/udev/rules.d/99-input.rules ]; then
    sudo touch /etc/udev/rules.d/99-input.rules
    echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-input.rules
  fi

  sudo udevadm control --reload-rules && sudo udevadm trigger

  sudo modprobe uinput

  systemctl --user daemon-reload
  systemctl enable --now --user kanata.service
}

setup_silent_boot() {
  if [ -e /etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
    sudo mv /etc/systemd/system/getty@tty1.service.d/autologin.conf /etc/systemd/system/getty@tty1.service.d/autologin.conf.bkp
  fi
  sudo stow --target=/etc/systemd/system/ --dir="$INSTALL_DIR" system
}

enable_bluetooth() {
  systemctl enable --now bluetooth.service
}

if [ "$(id -u)" -eq 0 ]; then
  echo "Please do not run this script as root."
  exit 1
fi

clone_repo
install_aur_helper
install_packages
stow_dots
install_npm
install_tmux_plugins
setup_kanata
setup_silent_boot
install_wallpapers
enable_bluetooth
curl -fsSL https://raw.githubusercontent.com/Axenide/Ax-Shell/main/install.sh
