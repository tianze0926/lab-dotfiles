local M = {}

function M.http_link(file)
	return string.format("https://fs.local.tianze.me:62023%s", tostring(file.url))
end

local function base64(data)
	local fp = io.popen(string.format("echo -n '%s' | base64", data))
	if not fp then
		return ""
	end
	return fp:read("*a")
end

local function tmux_wrap(sequence)
	local tmux = os.getenv("TMUX")
	if not tmux then
		return sequence
	end
	return "\x1bPtmux;" .. string.gsub(sequence, "\x1b", "\x1b\x1b") .. "\x1b\\"
end

io.stderr:setvbuf("no")
local function print(sequence)
	io.stderr:write(sequence)
end

function M.set_user_var(key, value)
	-- https://wezfurlong.org/wezterm/config/lua/window-events/user-var-changed.html
	local template = tmux_wrap("\x1b]1337;SetUserVar=%s=%s\x07")
	print(string.format(template, key, base64(value)))
end

function M.copy(data)
	local template = tmux_wrap("\x1b]52;c;%s\x07")
	print(string.format(template, base64(data)))
end

return M
