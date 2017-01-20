local awful = require("awful")

local util = {}

-- {{{ util.move_tag_screen(incr)
-- Move a tag with all of it's clients to a different screen.
-- Inspired from http://stackoverflow.com/questions/31272329/awesome-wm-how-to-change-tag-of-screen
function util.move_tag_screen(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	t.screen = awful.util.cycle(screen:count(), s.index + incr)
	awful.screen.focus(s)
	awful.tag.viewonly(t)
end
-- }}}

-- {{{ util.move_all_clients_tag(incr)
-- move all clients in a tag to a different tag.
function util.move_all_clients_tag(incr)
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

-- {{{ util.move_all_clients_screen(incr)
-- move all of the clients of a tag to a different tag on a different screen.
function util.move_all_clients_screen(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	local dumb = function()
		return true
	end
	for c in awful.util.table.iterate(t:clients(),dumb,1) do
		c:move_to_screen(s)
	end
	awful.screen.focus(t.screen)
	awful.tag.viewonly(new_tag)
end
-- }}}

-- {{{ util.move_client_tag
function util.move_client_tag(c,incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	new_tag = s.tags[awful.util.cycle(#s.tags, t.index + incr)]
	c:move_to_tag(new_tag)
	awful.tag.viewonly(new_tag)
end
-- }}}

return util

-- vim:ft=lua:foldmethod=marker
