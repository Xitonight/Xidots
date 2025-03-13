if uwsm check may-start &> /dev/null; then
    exec uwsm start hyprland.desktop &> /dev/null
fi
