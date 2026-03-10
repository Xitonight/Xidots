if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec start-hyprland > ~/.cache/hyprland/hyprlandStart.txt 2>&1
fi

# Created by `pipx` on 2026-02-02 13:49:49
export PATH="$PATH:/home/xitonight/.local/bin"
