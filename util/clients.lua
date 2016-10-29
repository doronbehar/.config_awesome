local awful = require("awful")

clients = {}

-- {{{ clients.move2tag(incr)
-- move all of the clients of a tag to a different tag in the current screen.
function clients.move2tag(incr)
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

-- {{{ clients.move2screen(incr)
-- move all of the clients of a tag to a different tag on a different screen.
function clients.move2screen(incr)
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

-- {{{ clients.move2(tag_index)
-- Move all the clients of a tag to a specific tag on the current screen.
function clients.move2(new_tag)
	local tag = awful.tag.selected()
	local all_tags = awful.tag.gettags(awful.tag.getscreen(tag))
	local dumb = function()
		return true
	end
	for c in awful.util.table.iterate(tag:clients(),dumb,1) do
		awful.client.movetotag(new_tag,c)
	end
	awful.tag.viewonly(new_tag)
end
-- }}}

return clients

-- vim:ft=lua:foldmethod=marker
