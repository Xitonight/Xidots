hl.env("GTK_THEME", "adw-gtk3-dark")
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor 'Bibata-Modern-Classic' 24")
end)

local c = require("source/colors")

hl.config({
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	general = {
		col = {
			active_border = "#" .. c.primary,
			inactive_border = "#" .. c.surface,
		},
		border_size = 2,
		layout = "dwindle",
		gaps_in = 2,
		gaps_out = 2,
	},
	decoration = {
		dim_special = 0.6,
		blur = {
			enabled = true,
			size = 3,
			passes = 3,
			new_optimizations = true,
			contrast = 1,
			brightness = 1,
		},
		rounding = 14,
		shadow = {
			enabled = true,
			range = 10,
			render_power = 2,
			color = "rgba(0, 0, 0, 0.25)",
		},
	},
})
