local function focus_workspace(n)
	local specialws = hl.get_active_special_workspace()
	if specialws then
		hl.dispatch(hl.dsp.workspace.toggle_special())
	end
	hl.dispatch(hl.dsp.focus({ workspace = tostring(n) }))
end

-- Window management
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + Y", hl.dsp.window.pin({ action = "toggle" }))
hl.bind("SUPER + C", hl.dsp.window.center())
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces
for i = 1, 10 do
	local n = i == 10 and 0 or i
	hl.bind("SUPER + " .. n, function()
		focus_workspace(i)
	end)
end

-- Move window to workspace
for i = 1, 10 do
	local n = i == 10 and 0 or i
	hl.bind("SUPER + ALT + " .. n, hl.dsp.window.move({ workspace = tostring(n) }))
end

-- Move window to workspace (silent)
for i = 1, 10 do
	local n = i == 10 and 0 or i
	hl.bind("SUPER + SHIFT + ALT + " .. n, hl.dsp.window.move({ workspace = tostring(n), silent = true }))
end

-- Switch occupied workspaces
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + Z", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + SHIFT + X", hl.dsp.focus({ workspace = "e+1" }))

-- Focus
hl.bind("SUPER + k", function()
	if hl.get_active_workspace().tiled_layout == "scrolling" then
		hl.dispatch(hl.dsp.layout("focus u"))
	else
		hl.dispatch(hl.dsp.focus({ direction = "u" }))
	end
end)
hl.bind("SUPER + j", function()
	if hl.get_active_workspace().tiled_layout == "scrolling" then
		hl.dispatch(hl.dsp.layout("focus d"))
	else
		hl.dispatch(hl.dsp.focus({ direction = "d" }))
	end
end)
hl.bind("SUPER + h", function()
	if hl.get_active_workspace().tiled_layout == "scrolling" then
		hl.dispatch(hl.dsp.layout("focus l"))
	else
		hl.dispatch(hl.dsp.focus({ direction = "l" }))
	end
end)
hl.bind("SUPER + l", function()
	if hl.get_active_workspace().tiled_layout == "scrolling" then
		hl.dispatch(hl.dsp.layout("focus r"))
	else
		hl.dispatch(hl.dsp.focus({ direction = "r" }))
	end
end)

local function focus_opposite_float()
	local active = hl.get_active_window()
	if not active then
		return
	end
	local is_floating = active.floating
	local ws = hl.get_active_special_workspace() or hl.get_active_workspace()
	if not ws then
		return
	end
	local windows = ws.get_windows(ws)
	if not windows then
		return
	end
	for _, w in ipairs(windows) do
		if w.floating ~= is_floating then
			hl.dispatch(hl.dsp.focus({ window = "address:" .. w.address }))
			return
		end
	end
end

hl.bind("ALT + Tab", function()
	focus_opposite_float()
end)

-- Move window direction
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "l" }), { repeating = true })
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "r" }), { repeating = true })
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "u" }), { repeating = true })
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "d" }), { repeating = true })

-- Resize
hl.bind("SUPER + CTRL + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })

-- Move floating window
hl.bind("SUPER + ALT + H", hl.dsp.window.move({ x = -50, y = 0 }), { release = true })
hl.bind("SUPER + ALT + J", hl.dsp.window.move({ x = 0, y = -50 }), { release = true })
hl.bind("SUPER + ALT + K", hl.dsp.window.move({ x = 0, y = 50 }), { release = true })
hl.bind("SUPER + ALT + L", hl.dsp.window.move({ x = 50, y = 0 }), { release = true })

-- Fullscreen
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Special workspace
hl.bind("SUPER + T", hl.dsp.workspace.toggle_special(""))
hl.bind("SUPER + ALT + T", hl.dsp.window.move({ workspace = "special" }))
hl.bind("SUPER + SHIFT + ALT + T", hl.dsp.window.move({ workspace = "special" }))

-- Applications
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + ALT + Return", hl.dsp.exec_cmd("kitty --class kitty-floating -1"))
hl.bind("SUPER + ALT + Escape", hl.dsp.exec_cmd("kitty --class kitty-btop btop"))
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("kitty --class kitty-wiremix wiremix"))
hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd("kitty --class kitty-nmtui --override window_padding_width=0 nmtui"))
hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

-- Rofi
hl.bind("SUPER + A", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("pkill rofi || rofi -show run -config ~/.config/rofi/run.rasi"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("pkill rofi || rofi-rbw -a copy"))
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("pkill rofi || rofi -show window -config ~/.config/rofi/window.rasi"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("pkill rofi || rofi -show emoji -config ~/.config/rofi/emoji.rasi"))
hl.bind("SUPER + Comma", hl.dsp.exec_cmd("pkill rofi || ~/.local/bin/rofi-wallpaper"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill rofi || ~/.local/bin/rofi-clipboard"))

-- System
hl.bind("SUPER + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind("SUPER + SHIFT + CTRL + ALT + Escape", hl.dsp.exit())

-- Lid switch
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off"))
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"))

-- Media keys
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioMedia", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Screenshots
hl.bind("SUPER + P", hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only"))
hl.bind("SUPER + ALT + P", hl.dsp.exec_cmd("hyprshot -m window -m active --clipboard-only"))
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.local/bin/brightness up"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.local/bin/brightness down"), { repeating = true })
