#!/usr/bin/env bash

set -e
set -u
set -o pipefail

XIDOTS_DIR=${1:-"$HOME/.xidots"}
BACKUP_DIR="$HOME/.dotsbackup"
WALLPAPERS_DIR="$HOME/Pictures/Wallpapers/"
WALLPAPERS_REPO_URL="https://github.com/Xitonight/Papers"
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

sync_repo() {
  if [ -d "$XIDOTS_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$XIDOTS_DIR" pull
  else
    echo "Cloning dotfiles..."
    git clone "$REPO_URL" "$XIDOTS_DIR"
  fi
}

sync_wallpapers() {
  if [ -d "$WALLPAPERS_DIR" ]; then
    echo "Updating wallpapers..."
    git -C "$WALLPAPERS_DIR" pull
  else
    echo "Cloning wallpapers..."
    git clone "$WALLPAPERS_REPO_URL" "$WALLPAPERS_DIR"
  fi
}

install_packages() {
  echo "Installing required packages..."
  grep -v '^$' "$XIDOTS_DIR"/requirements.lst | sed '/^#/d' | $aur_helper -Syy --noconfirm --needed --norebuild -
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
    dir_name=$(basename "$dir")
    dir_in_home="$HOME/$dir_name"

    # Special handling for .config
    if [ "$dir_name" == ".config" ] && [ -d "$dir_in_home" ]; then
      echo "Checking individual directories inside .config..."

      # Iterate through each subdirectory in .config
      for sub_dir in "$DOTS_DIR/.config"/*; do
        # E.g. if sub_dir is "$DOTS_DIR/.config/someapp", sub_file_name will be "someapp"
        sub_dir_name=$(basename "$sub_dir")
        sub_dir_in_home="$dir_in_home/$sub_dir_name"

        if [ -e "$sub_dir_in_home" ]; then
          if [ -L "$sub_dir_in_home" ] && [ "$(readlink -f "$sub_dir_in_home")" == "$sub_dir" ]; then
            echo "$sub_dir_name is already correctly stowed, skipping backup."
          else
            backup="$BACKUP_DIR/.config/$sub_dir_name"
            if [ -e "$backup" ]; then
              echo "Backup already exists for $sub_dir_name, skipping..."
            else
              mkdir -p "$backup"
              echo "Moving existing $sub_dir_name to $backup"
              cp -R "$sub_dir_in_home" "$backup"
            fi
          fi
          rm -rf "$sub_dir_in_home"
        fi
      done
    else
      # Normal files and directories outside .config
      if [ -e "$dir_in_home" ]; then
        if [ -L "$dir_in_home" ] && [ "$(readlink -f "$dir_in_home")" == "$dir" ]; then
          echo "$dir_name is already correctly stowed, skipping backup."
        else
          backup="$BACKUP_DIR/$dir_name"
          if [ -e "$backup" ]; then
            echo "Backup already exists for $dir_name, skipping..."
          else
            mkdir -p "$BACKUP_DIR"
            echo "Moving existing $dir_name to $backup"
            cp -R "$dir_in_home" "$backup"
          fi
        fi
        rm -rf "$dir_in_home"
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
  autologin_dir="/etc/systemd/system/getty@tty1.service.d"
  autologin_file="$autologin_dir/autologin.conf"
  autologin_dot="$XIDOTS_DIR/autologin/autologin.conf"

  if [ ! -d autologin_dir ]; then
    sudo mkdir -p "$autologin_dir"
  fi
  if [ -e "$autologin_file" ]; then
    if [ -L "$autologin_file" ] && [ "$(readlink -f "$autologin_file")" == "$autologin_dot" ]; then
      echo "autologin.conf is already correctly stowed, skipping backup."
    else
      backup="$BACKUP_DIR/autologin"
      if [ -e "$backup" ]; then
        echo "Backup already exists for autologin.conf, skipping..."
      else
        mkdir -p "$BACKUP_DIR"
        echo "Moving existing autologin.conf to $backup"
        sudo cp "$autologin_file" "$backup"
      fi
    fi
    sudo rm -rf "$autologin_file"
  fi
  sudo stow --target="$autologin_dir" --dir="$XIDOTS_DIR" autologin
}

setup_telegram_material_theme() {
  walogram_dir="/usr/share/walogram"
  walogram_file="$walogram_dir/constants.tdesktop-theme"
  walogram_dot="$XIDOTS_DIR/telegram/constants.tdesktop-theme"

  if [ ! -d walogram_dir ]; then
    sudo mkdir -p "$walogram_dir"
  fi
  if [ -e "$walogram_file" ]; then
    if [ -L "$walogram_file" ] && [ "$(readlink -f "$walogram_file")" == "$walogram_dot" ]; then
      echo "constants.tdesktop-theme is already correctly stowed, skipping backup."
    else
      backup="$BACKUP_DIR/telegram"
      if [ -e "$backup" ]; then
        echo "Backup already exists for constants.tdesktop-theme, skipping..."
      else
        mkdir -p "$BACKUP_DIR"
        echo "Moving existing constants.tdesktop-theme to $backup"
        sudo cp "$walogram_file" "$backup"
      fi
    fi
    sudo rm -rf "$walogram_file"
  fi
  sudo stow --target="$walogram_dir" --dir="$XIDOTS_DIR" telegram
}

setup_kanata() {
  sudo groupdel uinput
  sudo groupadd --system uinput

  sudo usermod -aG input "$USER"
  sudo usermod -aG uinput "$USER"

  if [ ! -e /etc/udev/rules.d/99-input.rules ]; then
    sudo touch /etc/udev/rules.d/99-input.rules
    echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-input.rules
  fi

  sudo udevadm control --reload-rules && sudo udevadm trigger

  sudo modprobe uinput

  systemctl --user daemon-reload
  systemctl --user enable --now kanata.service
}

enable_bluetooth() {
  systemctl enable --now bluetooth.service
}

if [ "$(id -u)" -eq 0 ]; then
  echo "Please do not run this script as root."
  exit 1
fi

sync_repo
install_aur_helper
install_packages
stow_dots
install_npm
install_tmux_plugins
setup_silent_boot
setup_telegram_material_theme
setup_kanata
sync_wallpapers
enable_bluetooth
