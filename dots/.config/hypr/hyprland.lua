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
require("source/monitors")
