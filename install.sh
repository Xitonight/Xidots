#!/usr/bin/env bash

set -e
set -u
set -o pipefail

INSTALL_DIR="$HOME/neoconf"
REPO_URL="https://github.com/Xitonight/neoconf"

install_aur_helper() {
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

install_packages() {
  echo "Installing required packages..."
  grep -v '^$' ./requirements.lst | sed '/^#/d' | yay -Sy --noconfirm -
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
  stow dots --target=$HOME
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

symlink_nvim_config() {
  sudo mkdir -p /root/.config/nvim
  sudo ln -s ~/.config/nvim/ /root/.config/nvim
}

setup_kanata() {
  sudo groupadd uinput

  sudo usermod -aG input $USER
  sudo usermod -aG uinput $USER

  sudo touch /etc/udev/rules.d/99-input.rules

  echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-input.rules

  sudo udevadm control --reload-rules && sudo udevadm trigger

  sudo modprobe uinput

  systemctl --user daemon-reload
  systemctl enable --now --user kanata.service
}

setup_silent_boot() {
  sudo stow --target=/etc/systemd/system/ system
}

if [ "$(id -u)" -eq 0 ]; then
  echo "Please do not run this script as root."
  exit 1
fi

install_aur_helper
install_packages
clone_repo
stow_dots
install_npm
install_tmux_plugins
change_shell
setup_kanata
setup_silent_boot
git clone https://github.com/Xitonight/papers.git ~/Pictures/Wallpapers
curl -fsSL https://raw.githubusercontent.com/Axenide/Ax-Shell/main/install.sh | bash
