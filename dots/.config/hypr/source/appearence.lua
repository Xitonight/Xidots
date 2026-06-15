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
			active_border = c.surface,
			inactive_border = c.background,
		},
		border_size = 2,
		layout = "dwindle",
		gaps_in = 4,
		gaps_out = 16,
	},
	decoration = {
		active_opacity = 0.85,
		inactive_opacity = 0.85,

		dim_strength = 0.05,
		dim_inactive = true,
		dim_special = 0.3,

		blur = {
			enabled = true,
			size = 6,
			passes = 3,
			new_optimizations = true,
			contrast = 1,
			brightness = 1,
		},
		rounding = 20,
		shadow = {
			enabled = true,
			range = 16,
			render_power = 2,
			color = "rgba(0, 0, 0, 1)",
		},
	},
})
