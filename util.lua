local awful = require("awful")
local gears = require("gears")

local util = {}

-- {{{ util.move_tag_to_screen(incr)
function util.move_tag_to_screen(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	-- the variable `next_tag_to_be_focused` holds the object of the tag next to the tag we want to move
	-- and it is the tag that should be focused once the move has been made.
	local next_tag_to_be_focused = {}
	if t.index == 1 then
		next_tag_to_be_focused = s.tags[gears.math.cycle(#s.tags, t.index + 1)]
	elseif t.index == #s.tags then
		next_tag_to_be_focused = s.tags[gears.math.cycle(#s.tags, t.index - 1)]
	else
		next_tag_to_be_focused = s.tags[gears.math.cycle(#s.tags, t.index + incr)]
	end
	next_tag_to_be_focused:view_only()
	t.screen = gears.math.cycle(screen:count(), s.index + incr)
	awful.screen.focus_relative(incr)
	t:view_only()
end
-- }}}

-- {{{ util.move_all_clients_to_tag(incr)
-- move all clients in a tag to a different tag.
function util.move_all_clients_to_tag(incr)
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

-- {{{ util.move_all_clients_to_screen(incr)
-- move all of the clients of a tag to a different tag on a different screen.
function util.move_all_clients_to_screen(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	local new_screen = gears.math.cycle(screen:count(), s.index + incr)
	local dumb = function()
		return true
	end
	for c in awful.util.table.iterate(t:clients(),dumb,1) do
		c:move_to_screen(new_screen)
	end
	awful.screen.focus_relative(incr)
end
-- }}}

return util

-- vim:ft=lua:foldmethod=marker
