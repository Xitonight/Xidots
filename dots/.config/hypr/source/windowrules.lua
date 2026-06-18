-- Float
hl.window_rule({ match = { class = "Bitwarden" }, float = true })

-- Opacity
hl.window_rule({ match = { class = "mpv" }, opaque = true })

-- Center floating (not xwayland popups)
hl.window_rule({ match = { xwayland = false, float = true }, center = true })

-- Float, resize and center specific apps
hl.window_rule({
	match = { class = "kitty-floating" },
	float = true,
	size = { "monitor_w*0.4", "monitor_h*0.6" },
	center = true,
})
hl.window_rule({
	match = { class = "kitty-nmtui" },
	float = true,
	size = { "monitor_w*0.4", "monitor_h*0.6" },
	center = true,
})
hl.window_rule({
	match = { class = "kitty-btop" },
	float = true,
	size = { "monitor_w*0.6", "monitor_h*0.7" },
	center = true,
})
hl.window_rule({
	match = { class = "kitty-wiremix" },
	float = true,
	size = { "monitor_w*0.5", "monitor_h*0.6" },
	center = true,
})
hl.window_rule({
	match = { class = "nwg-look" },
	float = true,
	size = { "monitor_w*0.5", "monitor_h*0.6" },
	center = true,
})
hl.window_rule({
	match = { class = "blueman-manager" },
	float = true,
	size = { "monitor_w*0.5", "monitor_h*0.6" },
	center = true,
})
hl.window_rule({
	match = { class = "one.alynx.showmethekey" },
	float = true,
	move = { "monitor_w - monitor_w * 0.3 - monitor_w * 0.02", "monitor_h - monitor_h * 0.1 - monitor_h * 0.02" },
	size = { "monitor_w*0.3", "monitor_h*0.1" },
	border_size = 0,
	pin = true,
})

-- Workspace rules
hl.workspace_rule({ workspace = "special:telegram", persistent = true })
hl.workspace_rule({ workspace = "special:obsidian", persistent = true })

-- Layer rules
hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0.5,
})
hl.layer_rule({
	match = { namespace = "swaync-control-center" },
	blur = true,
	ignore_alpha = 0.5,
})
hl.layer_rule({
	match = { namespace = "swaync-notification-window" },
	blur = true,
	ignore_alpha = 0.5,
})

-- Useful rules
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
hl.window_rule({ match = { fullscreen = true }, idle_inhibit = "always" })
