hl.on("hyprland.start", function()
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd('udiskie --event-hook="stow --target=$HOME/Mounts/ --dir=/run/media/ --restow $USER"')
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME")

	hl.exec_cmd("awww-daemon")

	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("swaync")

	hl.exec_cmd("[workspace special silent] Telegram")
	hl.exec_cmd("[workspace 2 silent] zen-browser")
	hl.exec_cmd("[workspace 3 silent] bitwarden-desktop")
	hl.exec_cmd("[workspace 1 silent] kitty")
end)
