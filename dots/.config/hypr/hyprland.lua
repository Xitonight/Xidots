local hostname = io.popen("hostname"):read("*a"):gsub("%s+", "")

if hostname ~= "archpad" then
	require("source/nvidia")
end

require("source/env")
require("source/autostart")
require("source/misc")
require("source/submaps")
require("source/appearence")
require("source/animations")
require("source/input")
require("source/windowrules")
require("source/keybinds")

hl.monitor({
	output = hostname == "archpad" and "eDP-1" or "HDMI-A-1",
	mode = hostname == "archpad" and "1920x1080@60" or "1920x1080@75",
	position = "auto",
	scale = hostname == "archpad" and 1.33 or 1,
})
