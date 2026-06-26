if uwsm check may-start >/dev/null; then
  exec uwsm start hyprland.desktop >/dev/null 2>&1
fi
