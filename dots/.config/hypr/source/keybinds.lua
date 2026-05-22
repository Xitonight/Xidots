local mainMod = "SUPER"

-- Ambxst launchers
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("ambxst run launcher"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("ambxst run dashboard"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("ambxst run clipboard"))
hl.bind(mainMod .. " + PERIOD", hl.dsp.exec_cmd("ambxst run emoji"))
hl.bind(mainMod .. " + COMMA", hl.dsp.exec_cmd("ambxst run wallpapers"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("ambxst run overview"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("ambxst run powermenu"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("ambxst run config"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("ambxst run tools"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("ambxst run screenshot"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("ambxst run screenrecord"))
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd("ambxst run lens"))
hl.bind(mainMod .. " + ALT + B", hl.dsp.exec_cmd("ambxst reload"))
hl.bind(mainMod .. " + CTRL + ALT + SHIFT + B", hl.dsp.exec_cmd("ambxst quit"))

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Y", hl.dsp.window.pin())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + SHIFT + CTRL + ALT + ESCAPE", hl.dsp.exit())

-- Focus
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Resize
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))

-- Move active window (pixel)
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.move({ x = -50, y = 0 }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ x = 0, y = -50 }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ x = 0, y = 50 }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.move({ x = 50, y = 0 }))

-- Center window
hl.bind(mainMod .. " + C", hl.dsp.window.center({ always_center = true }))

-- Workspaces
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + ALT + " .. key, hl.dsp.window.move({ workspace = i, silent = true }))
end

-- Special workspace (telegram/obsidian)
hl.bind(mainMod .. " + T", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. " + ALT + T", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + SHIFT + ALT + T", hl.dsp.window.move({ workspace = "special", silent = true }))

-- Workspace scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.focus({ workspace = "e+1" }))

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Apps
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + ALT + RETURN", hl.dsp.exec_cmd("kitty --class kitty-floating -1"))
hl.bind(mainMod .. " + ALT + K", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))
hl.bind(mainMod .. " + ALT + ESCAPE", hl.dsp.exec_cmd("kitty --class kitty-btop btop"))
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("kitty --class kitty-pulsemixer pulsemixer"))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("kitty --class kitty-nmtui --override window_padding_width=0 nmtui"))

-- Lock session
hl.bind(mainMod .. " + ALT + SHIFT + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Media keys
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioMedia", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- Volume
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+"),
  { repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),
  { repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("ambxst brightness +5"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ambxst brightness -5"), { repeating = true })

-- Misc
hl.bind("XF86Calculator", hl.dsp.exec_cmd("notify-send 'Soon'"))

-- Lid switch
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("axctl monitor set-dpms 0 0"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("axctl monitor set-dpms 0 1"), { locked = true })
