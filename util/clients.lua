local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local clients = {}

-- {{{ clients.move_all_to_tag(incr)
-- move all clients in a tag to a different tag.
function clients.move_all_to_tag(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	local new_tag = s.tags[gears.math.cycle(#s.tags, t.index + incr)]
	local dumb = function()
		return true
	end
	for c in awful.util.table.iterate(t:clients(),dumb,1) do
		c:move_to_tag(new_tag)
	end
	new_tag:view_only()
end
-- }}}

-- {{{ clients.move_all_to_screen(incr)
-- move all of the clients of a tag to a different tag on a different screen.
function clients.move_all_to_screen(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	local clients = t:clients()
	local new_screen = gears.math.cycle(screen:count(), s.index + incr)
	for c = 1, #clients do
		if clients[c].class ~= "Polybar" then
			clients[c]:move_to_screen(new_screen)
		end
	end
	awful.screen.focus_relative(incr)
end
-- }}}

return clients

-- vim:ft=lua:foldmethod=marker
