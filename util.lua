local awful = require("awful")

local util = {}

-- {{{ util.move_tag_to_screen(incr)
function util.move_tag_to_screen(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	t.screen = awful.util.cycle(screen:count(), s.index + incr)
	awful.screen.focus(s)
	awful.tag.viewonly(t)
end
-- }}}

-- {{{ util.move_all_clients_to_tag(incr)
-- move all clients in a tag to a different tag.
function util.move_all_clients_to_tag(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	local new_tag = s.tags[awful.util.cycle(#s.tags, t.index + incr)]
	local dumb = function()
		return true
	end
	for c in awful.util.table.iterate(t:clients(),dumb,1) do
		c:move_to_tag(new_tag)
	end
	awful.tag.viewonly(new_tag)
end
-- }}}

-- {{{ util.move_all_clients_to_screen(incr)
-- move all of the clients of a tag to a different tag on a different screen.
function util.move_all_clients_to_screen(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	local new_screen = awful.util.cycle(screen:count(), s.index + incr)
	local dumb = function()
		return true
	end
	for c in awful.util.table.iterate(t:clients(),dumb,1) do
		c:move_to_screen(new_screen)
	end
	awful.screen.focus(new_screen)
end
-- }}}

return util

-- vim:ft=lua:foldmethod=marker
