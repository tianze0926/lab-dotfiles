local wezterm = require("wezterm")

wezterm.on("user-var-changed", function(window, pane, name, value)
	local win = wezterm.target_triple == "x86_64-pc-windows-msvc"
	local actions = {
		play = "mpv '%s'",
		download = "brave '%s'",
	}
	if not actions[name] then
		return
	end
	io.popen(string.format(actions[name], value))
end)
