local function mime_is_media(mime)
	if not mime then
		return false
	end
	for _, mime_type in ipairs({
		"video",
		"audio",
	}) do
		if mime:find("^" .. mime_type .. "/") ~= nil then
			return true
		end
	end
	return false
end

local function remote(file, action)
	local term = dofile(BOOT.config_dir .. "/term.lua")
	term.set_user_var(action, term.http_link(file))
end

return {
	entry = function(self, args)
		local file = cx.active.current.hovered
		if not file then
			return
		end
		if args[1] == "download" then
			return remote(file, "download")
		end
		if file.cha.is_dir then
			return ya.manager_emit("enter", {})
		end
		if mime_is_media(file:mime()) then
			return remote(file, "play")
		end

		return ya.manager_emit("open", { hovered = true })
	end,
}
