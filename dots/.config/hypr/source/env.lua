hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

hl.env("XCURSOR_SIZE", "24")

hl.config({
	cursor = {
		no_hardware_cursors = true,
	},
})

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland,xcb")
hl.env("SDL_VIDEODRIVER", "wayland")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_SELECTION", "/usr/bin/qmake")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

hl.env("MOZ_DBUS_REMOTE", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.env("EDITOR", "nvim")
hl.env("VISUAL", "nvim")
