local awful = require("awful")

local util = {}

-- {{{ util.move_tag_screen(incr)
-- Move a tag with all of it's clients to a different screen.
-- Inspired from http://stackoverflow.com/questions/31272329/awesome-wm-how-to-change-tag-of-screen
function util.move_tag_screen(incr)
	local tag = awful.tag.selected()
	local screen_index = awful.tag.getscreen(tag)
	local tag_count = #awful.tag.gettags(screen_index)
	if tag_count > 1 then -- protection against having a screen with no tags
		screen_index = awful.util.cycle(screen.count(), screen_index + incr)
		awful.tag.setscreen(tag, screen_index)
		awful.screen.focus(screen_index)
		awful.tag.viewonly(tag)
	end
end
-- }}}

-- {{{ util.move_clients(incr)
-- move all clients in a tag to a different tag.
function util.move_clients(incr)
	local tag = awful.tag.selected()
	local all_tags = awful.tag.gettags(awful.tag.getscreen(tag))
	local new_tag_index = awful.util.cycle(#all_tags, awful.tag.getidx(tag) + incr)
	local new_tag = all_tags[new_tag_index]
	local dumb = function()
		return true
	end
	for c in awful.util.table.iterate(tag:clients(),dumb,1) do
		awful.client.movetotag(new_tag,c)
	end
	awful.tag.viewonly(new_tag)
end
-- }}}

-- {{{ util.move_clients_screen(incr)
-- move all of the clients of a tag to a different tag on a different screen.
function util.move_clients_screen(incr)
	local tag = awful.tag.selected()
	local dumb = function()
		return true
	end
	for c in awful.util.table.iterate(tag:clients(),dumb,1) do
		awful.client.movetoscreen(c,incr)
	end
	awful.tag.viewonly(new_tag)
end
-- }}}

return util

-- vim:ft=lua:foldmethod=marker
