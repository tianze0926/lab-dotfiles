return {
	setup = function()
		ps.sub("cd", function()
			local dir = tostring(cx.active.current.cwd)
			if string.find(dir, "mlruns") then
				ya.manager_emit("sort", { "mtime", reverse = true, dir_first = true })
			else
				ya.manager_emit("sort", { "natural", reverse = false, dir_first = true })
			end
		end)
	end,
}
