require("folder-rules"):setup()

-- https://yazi-rs.github.io/docs/tips#user-group-in-status
function Status:owner()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	})
end

-- https://github.com/sxyazi/yazi/discussions/1113#discussioncomment-9645650
function Status:time()
	local time = cx.active.current.hovered.cha.modified
	return ui.Span(time and os.date("%y-%m-%d %H:%M ", time // 1) or " "):fg("blue")
end

function Status:render(area)
	self.area = area

	local left = ui.Line({ self:mode(), self:size(), self:time(), self:name() })
	local right = ui.Line({ self:owner(), self:permissions(), self:percentage(), self:position() })
	return {
		ui.Paragraph(area, { left }),
		ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
		table.unpack(Progress:render(area, right:width())),
	}
end
