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
LOCAL_INSTALL=false

# Parse command-line arguments
for arg in "$@"; do
  if [ "$arg" == "--local" ]; then
    LOCAL_INSTALL=true
    break
  fi
done

print_header() {
  local art="$1"
  local message="$2"
  echo -e "\n\e[1;34m$art\e[0m"
  echo -e "\e[1;32m$message\e[0m\n"
}

install_aur_helper() {
  print_header "
    _
   / \\  _   _ _ __
  / _ \\| | | | '__|
 / ___ \\ |_| | |
/_/   \\_\\__,_|_|
" "Setting up AUR helper..."
  if ! command -v git &>/dev/null; then
    sudo pacman -Sy git
  fi
  AUR_HELPER=""
  if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
    echo "Detected AUR helper: $AUR_HELPER"
  elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
    echo "Detected AUR helper: $AUR_HELPER"
  else
    echo "No AUR helper detected. Installing yay-bin..."
    TMPDIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$TMPDIR/yay-bin"
    cd "$TMPDIR/yay-bin"
    makepkg -si --noconfirm
    cd - >/dev/null
    rm -rf "$TMPDIR"
    AUR_HELPER="yay"
  fi
}

sync_repo() {
  print_header "
 ____                   _
/ ___| _   _ _ __   ___(_)_ __   __ _
\\___ \\| | | | '_ \\ / __| | '_ \\ / _\` |
 ___) | |_| | | | | (__| | | | | (_| |
|____/ \\__, |_| |_|\\___|_|_| |_|\\__, |
       |___/                    |___/
" "Syncing Xidots repository..."
  if [ "$LOCAL_INSTALL" = true ]; then
    echo "Skipping repository synchronization for local installation."
    return
  fi

  if [ -d "$XIDOTS_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$XIDOTS_DIR" pull
  else
    echo "Cloning dotfiles..."
    git clone "$REPO_URL" "$XIDOTS_DIR"
  fi
}

sync_wallpapers() {
  print_header "
__        __    _ _
\\ \\      / /_ _| | |_ __   __ _ _ __   ___ _ __ ___
 \\ \\ /\\ / / _\` | | | '_ \\ / _\` | '_ \\ / _ \\ '__/ __|
  \\ V  V / (_| | | | |_) | (_| | |_) |  __/ |  \\__ \\
   \\_/\\_/ \\__,_|_|_| .__/ \\__,_| .__/ \\___|_|  |___/
                   |_|         |_|
" "Syncing wallpapers..."
  if [ -d "$WALLPAPERS_DIR" ]; then
    echo "Updating wallpapers..."
    git -C "$WALLPAPERS_DIR" pull
  else
    echo "Cloning wallpapers..."
    git clone "$WALLPAPERS_REPO_URL" "$WALLPAPERS_DIR"
  fi
}

install_packages() {
  print_header "
 ____
|  _ \\ __ _  ___ _ __ ___   __ _ _ __
| |_) / _\` |/ __| '_ \` _ \\ / _\` | '_ \\
|  __/ (_| | (__| | | | | | (_| | | | |
|_|   \\__,_|\\___|_| |_| |_|\\__,_|_| |_|
" "Installing packages..."
  if ! grep -v '^$' "$XIDOTS_DIR"/requirements.lst | sed '/^#/d' | "$AUR_HELPER" -Syy --noconfirm --needed --norebuild -; then
    echo "Failed to install packages." >&2
    exit 1
  fi
}

install_npm() {
  print_header "
 _   _
| \\ | |_ __  _ __ ___
|  \\| | '_ \\| '_ \` _ \\
| |\\  | |_) | | | | | |
|_| \\_| .__/|_| |_| |_|
      |_|
" "Setting up Node.js environment..."
  source /usr/share/nvm/init-nvm.sh
  if command -v npm &>/dev/null; then
    echo "Installing node / npm..."
    nvm install lts/jod
    nvm use lts/jod
  fi
  # Install pnpm globally
  npm install -g pnpm@latest
}

stow_dots() {
  print_header "
 ____  _
/ ___|| |_ _____      __
\\___ \\| __/ _ \\ \\ /\\ / /
 ___) | || (_) \\ V  V /
|____/ \\__\\___/ \\_/\\_/
" "Stowing dotfiles..."
  # kill zen to prevent overwriting of files
  if pgrep -x "zen-bin" >/dev/null; then
    killall zen-bin
  fi
  shopt -s dotglob nullglob

  for dir in "$DOTS_DIR"/*; do
    dir_name=$(basename "$dir")
    dir_in_home="$HOME/$dir_name"

    # Special handling for .config
    if [ "$dir_name" == ".config" ] && [ -d "$dir_in_home" ]; then
      echo "Checking individual directories inside .config..."

      # Iterate through each subdirectory in .config
      for sub_dir in "$DOTS_DIR/.config"/*; do
        sub_dir_name=$(basename "$sub_dir")
        sub_dir_in_home="$dir_in_home/$sub_dir_name"

        if [ -e "$sub_dir_in_home" ]; then
          if [ -L "$sub_dir_in_home" ] && [ "$(readlink -f "$sub_dir_in_home")" == "$sub_dir" ]; then
            echo "$sub_dir_name is already correctly stowed, skipping backup."
          else
            backup="$BACKUP_DIR/.config/$sub_dir_name"
            create_backup "$sub_dir_in_home" "$backup" "$sub_dir_name"
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
          create_backup "$dir_in_home" "$backup" "$dir_name"
        fi
        rm -rf "$dir_in_home"
      fi
    fi
  done

  echo "Stowing dotfiles in $HOME"
  if ! stow --target="$HOME" --dir="$XIDOTS_DIR" dots; then
    echo "Failed to stow dotfiles." >&2
    exit 1
  fi
}

install_tmux_plugins() {
  print_header "
 _____
|_   _| __ ___  _   ___  __
  | || '_ \` _ \\| | | \\ \\/ /
  | || | | | | | |_| |>  <
  |_||_| |_| |_|\\__,_/_/\\_\\
" "Installing tmux plugins..."
  if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    echo "TPM is not installed. Installing right now..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

create_backup() {
  local target="$1"
  local backup="$2"
  local name="$3"
  local use_sudo="${4:-}"

  # Check if a backup already exists
  if [ -e "$backup" ]; then
    echo "Backup already exists for $name, skipping..."
    return
  fi

  # Create the backup directory and copy the files
  if [ "$use_sudo" == "sudo" ]; then
    sudo mkdir -p "$(dirname "$backup")"
    echo "Backing up existing $name to $backup..."
    sudo cp -R "$target" "$backup"
  else
    mkdir -p "$(dirname "$backup")"
    echo "Backing up existing $name to $backup..."
    cp -R "$target" "$backup"
  fi
}

setup_silent_boot() {
  print_header "
 ____              _
| __ )  ___   ___ | |_
|  _ \\ / _ \\ / _ \\| __|
| |_) | (_) | (_) | |_
|____/ \\___/ \\___/ \\__|

" "Configuring silent boot..."
  autologin_dir="/etc/systemd/system/getty@tty1.service.d"
  autologin_file="$autologin_dir/autologin.conf"
  autologin_dot="$XIDOTS_DIR/autologin/autologin.conf"

  if [ ! -d "$autologin_dir" ]; then
    sudo mkdir -p "$autologin_dir"
  fi
  if [ -e "$autologin_file" ]; then
    if [ -L "$autologin_file" ] && [ "$(readlink -f "$autologin_file")" == "$autologin_dot" ]; then
      echo "autologin.conf is already correctly stowed, skipping backup."
    else
      backup="$BACKUP_DIR/autologin"
      create_backup "$autologin_file" "$backup" "autologin.conf" "sudo"
    fi
    sudo rm -rf "$autologin_file"
  fi
  if ! sudo stow --target="$autologin_dir" --dir="$XIDOTS_DIR" autologin; then
    echo "Failed to stow autologin files." >&2
    exit 1
  fi
}

setup_telegram_material_theme() {
  print_header "
__        __    _
\\ \\      / /_ _| | ___   __ _ _ __ __ _ _ __ ___
 \\ \\ /\\ / / _\` | |/ _ \\ / _\` | '__/ _\` | '_ \` _ \\
  \\ V  V / (_| | | (_) | (_| | | | (_| | | | | | |
   \\_/\\_/ \\__,_|_|\\___/ \\__, |_|  \\__,_|_| |_| |_|
                        |___/
" "Setting up Telegram theme..."
  walogram_dir="/usr/share/walogram"
  walogram_file="$walogram_dir/constants.tdesktop-theme"
  walogram_dot="$XIDOTS_DIR/telegram/constants.tdesktop-theme"

  if [ ! -d "$walogram_dir" ]; then
    sudo mkdir -p "$walogram_dir"
  fi
  if [ -e "$walogram_file" ]; then
    if [ -L "$walogram_file" ] && [ "$(readlink -f "$walogram_file")" == "$walogram_dot" ]; then
      echo "constants.tdesktop-theme is already correctly stowed, skipping backup."
    else
      backup="$BACKUP_DIR/telegram"
      create_backup "$walogram_file" "$backup" "constants.tdesktop-theme" "sudo"
    fi
    sudo rm -rf "$walogram_file"
  fi
  if ! sudo stow --target="$walogram_dir" --dir="$XIDOTS_DIR" telegram; then
    echo "Failed to stow telegram theme files." >&2
    exit 1
  fi
}

setup_kanata() {
  print_header "
 _  __                 _
| |/ /__ _ _ __   __ _| |_ __ _
| ' // _\` | '_ \\ / _\` | __/ _\` |
| . \\ (_| | | | | (_| | || (_| |
|_|\\_\\__,_|_| |_|\\__,_|\\__\\__,_|
" "Configuring Kanata..."
  # Ensure the uinput group exists and is a system group (GID < 1000)
  if getent group uinput >/dev/null; then
    UINPUT_GID=$(getent group uinput | cut -d: -f3)
    if [ "$UINPUT_GID" -ge 1000 ]; then
      echo "uinput group exists but is not a system group. Recreating..."
      sudo groupdel uinput
      sudo groupadd --system uinput
    else
      echo "uinput system group is already configured."
    fi
  else
    echo "Creating uinput system group..."
    sudo groupadd --system uinput
  fi

  sudo usermod -aG input "$USER"
  sudo usermod -aG uinput "$USER"

  if [ ! -e /etc/udev/rules.d/99-input.rules ]; then
    sudo touch /etc/udev/rules.d/99-input.rules
    echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-input.rules
    sudo udevadm control --reload-rules && sudo udevadm trigger
  fi

  sudo modprobe uinput

  systemctl --user daemon-reload
  if [ "$(systemctl --user is-enabled kanata.service)" != "enabled" ]; then
    systemctl --user enable --now kanata.service
  else
    echo "Kanata is already up and running!"
  fi
}

enable_bluetooth() {
  print_header "
 ____  _            _              _   _
| __ )| |_   _  ___| |_ ___   ___ | |_| |__
|  _ \\| | | | |/ _ \\ __/ _ \\ / _ \\| __| '_ \\
| |_) | | |_| |  __/ || (_) | (_) | |_| | | |
|____/|_|\\__,_|\\___|\\__\\___/ \\___/ \\__|_| |_|
" "Enabling Bluetooth..."
  if [ "$(systemctl is-enabled bluetooth.service)" != "enabled" ]; then
    systemctl enable --now bluetooth.service
  else
    echo "Bluetooth is already enabled."
  fi
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
