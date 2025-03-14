#!/usr/bin/env bash

set -e
set -u
set -o pipefail

INSTALL_DIR="$HOME/Xidots"
WALLPAPERS_DIR="$HOME/Pictures/Wallpapers/"
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
  grep -v '^$' $INSTALL_DIR/requirements.lst | sed '/^#/d' | $aur_helper -Syy --noconfirm --needed -
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
  echo "Stowing dotfiles in $HOME"
  stow --target=$HOME --dir=$INSTALL_DIR dots
}

install_tmux_plugins() {
  if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    echo "TPM is not installed. Installing right now..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

change_shell() {
  echo "Changing shell to zsh for $USER"
  chsh -s /usr/bin/zsh
}

setup_kanata() {
  sudo groupadd uinput

  if [[ -z "$(getent group input)" ]]; then
    sudo usermod -aG input $USER
  fi
  if [[ -z "$(getent group uinput)" ]]; then
    sudo usermod -aG uinput $USER
  fi

  sudo touch /etc/udev/rules.d/99-input.rules

  echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-input.rules

  sudo udevadm control --reload-rules && sudo udevadm trigger

  sudo modprobe uinput

  systemctl --user daemon-reload
  systemctl enable --now --user kanata.service
}

setup_silent_boot() {
  sudo stow --target=/etc/systemd/system/ --dir=$INSTALL_DIR system
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
curl -fsSL https://raw.githubusercontent.com/Axenide/Ax-Shell/main/install.sh | bash
