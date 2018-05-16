local awful = require("awful")
local gears = require("gears")

local util = {}

-- {{{ util.move_tag_to_screen(incr)
function util.move_tag_to_screen(incr)
	local s = awful.screen.focused()
	local t = s.selected_tag
	local clients = t:clients()
	for c = 1, #clients do
		if clients[c].class == "Polybar" then
			naughty.notify({
				preset = naughty.config.presets.critical,
				title = "Won't move tag to next screen since it contains polybar",
				timeout = 10
			})
			return
		end
	end
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

-- {{{ util.view_nonempty_tag(direction, sc)
-- view the next empty tag in the direction
function util.view_nonempty_tag(direction, sc)
	local s = sc or awful.screen.focused()
	for i = 1, #s.tags do
		awful.tag.viewidx(direction, s)
		-- now, in the newly selected tag,
		local clients = s.selected_tag:clients()
		-- we check if there are no clients at all
		if #clients == 1 then
			if clients[1].class ~= "Polybar" then
				return
			end
		elseif #clients ~= 0 then
			return
		end
	end
end
-- }}}

-- {{{ util.add_tag(layout)
-- add a tag.
function util.add_tag(layout)
	awful.prompt.run {
		prompt = "New tag name: ",
		textbox = awful.screen.focused().mypromptbox.widget,
		exe_callback = function(name)
			if not name or #name == 0 then return end
			awful.tag.add(name, { screen = awful.screen.focused(), layout = layout or awful.layout.suit.tile }):view_only()
		end
	}
end
-- }}}

-- {{{ util.delete_tag()
-- delete the current tag.
function util.delete_tag()
	local t = awful.screen.focused().selected_tag
	if not t then return end
	t:delete()
end
-- }}}

-- {{{ util.rename_tag()
-- rename the current tag.
function util.rename_tag()
	awful.prompt.run {
		prompt = "Rename tag: ",
		textbox = awful.screen.focused().mypromptbox.widget,
		exe_callback = function(new_name)
			if not new_name or #new_name == 0 then return end
			local t = awful.screen.focused().selected_tag
			if t then
				t.name = new_name
			end
		end
	}
end
-- }}}

-- {{{ util.move_tag(pos)
-- move the current tag to pos
function util.move_tag(pos)
	local tag = awful.screen.focused().selected_tag
	if tonumber(pos) <= -1 then
		awful.tag.move(tag.index - 1, tag)
	else
		awful.tag.move(tag.index + 1, tag)
	end
end
-- }}}

return util

-- vim:ft=lua:foldmethod=marker
