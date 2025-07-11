#!/usr/bin/env bash

set -e
set -u
set -o pipefail

XIDOTS_DIR=${1:-"$HOME/.xidots"}
if ! grep -q "export XIDOTS_DIR=\"$XIDOTS_DIR\"" ~/.zshrc; then
  sed -i "1i\export XIDOTS_DIR=\"$XIDOTS_DIR\"" ~/.zshrc
fi

BACKUP_DIR="$HOME/.dotsbackup"
WALLPAPERS_DIR="$HOME/Pictures/Wallpapers/"
DOTS_DIR="$XIDOTS_DIR/dots/"
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
  if [ -d "$XIDOTS_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$XIDOTS_DIR" pull
  else
    echo "Cloning dotfiles..."
    git clone "$REPO_URL" "$XIDOTS_DIR"
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
  grep -v '^$' "$XIDOTS_DIR"/requirements.lst | sed '/^#/d' | $aur_helper -Syy --noconfirm --needed -
}

install_personal_packages() {
  echo "Installing personal packages..."
  grep -v '^$' "$XIDOTS_DIR"/personal.lst | sed '/^#/d' | $aur_helper -Syy --noconfirm --needed -
}

install_npm() {
  source /usr/share/nvm/init-nvm.sh
  if command -v npm &>/dev/null; then
    echo "Installing node / npm..."
    nvm install node
    nvm install --lts
    nvm use node
  fi
}

stow_dots() {
  shopt -s dotglob nullglob

  for dir in "$DOTS_DIR"/*; do
    # E.g. if dir is "$DOTS_DIR/.config", file_name will be ".config"
    file_name=$(basename "$dir")
    target="$HOME/$file_name"

    # Special handling for .config
    if [ "$file_name" == ".config" ] && [ -d "$target" ]; then
      echo "Checking individual directories inside .config..."

      # Iterate through each subdirectory in .config
      for sub_dir in "$DOTS_DIR/.config"/*; do
        # E.g. if sub_dir is "$DOTS_DIR/.config/someapp", sub_file_name will be "someapp"
        sub_file_name=$(basename "$sub_dir")
        sub_target="$target/$sub_file_name"

        if [ -e "$sub_target" ]; then
          if [ -L "$sub_target" ] && [ "$(readlink -f "$sub_target")" == "$sub_dir" ]; then
            echo "$sub_file_name is already correctly stowed, skipping backup."
          else
            if [ ! -e "$BACKUP_DIR" ]; then
              mkdir -p "$BACKUP_DIR/.config"
            fi
            backup="$BACKUP_DIR/.config/$sub_file_name"

            if [ -e "$backup" ]; then
              echo "Backup already exists for $sub_file_name, skipping..."
            else
              echo "Moving existing $sub_file_name to $backup"
              cp -R "$sub_target" "$backup"
            fi
          fi
          rm -rf "$sub_target"
        fi
      done
    else
      # Normal files and directories outside .config
      if [ -e "$target" ]; then
        if [ -L "$target" ] && [ "$(readlink -f "$target")" == "$dir" ]; then
          echo "$file_name is already correctly stowed, skipping backup."
        else
          if [ ! -e "$BACKUP_DIR" ]; then
            mkdir -p "$BACKUP_DIR"
          fi
          backup="$BACKUP_DIR/$file_name.bkp"

          if [ -e "$backup" ]; then
            echo "Backup already exists for $file_name, skipping..."
          else
            echo "Moving existing $file_name to $backup"
            cp -R "$target" "$backup"
          fi
        fi
        rm -rf "$target"
      fi
    fi
  done

  echo "Stowing dotfiles in $HOME"
  stow --target="$HOME" --dir="$XIDOTS_DIR" dots
}

install_tmux_plugins() {
  if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    echo "TPM is not installed. Installing right now..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

setup_silent_boot() {
  if [ -e /etc/systemd/system/getty@tty1.service.d/autologin.conf ]; then
    if [ ! -e "$BACKUP_DIR/system" ]; then
      mkdir "$BACKUP_DIR/system"
    fi
    sudo cp /etc/systemd/system/getty@tty1.service.d/autologin.conf "$BACKUP_DIR/system/autologin.bkp"
    sudo rm -rf /etc/systemd/system/getty@tty1.service.d
  fi
  sudo stow --target=/etc/systemd/system/ --dir="$XIDOTS_DIR" system
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
install_personal_packages
stow_dots
install_npm
install_tmux_plugins
setup_silent_boot
install_wallpapers
enable_bluetooth
