local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local tag = {}

-- {{{ tag.move_to_screen(incr)
function tag.move_to_screen(incr)
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

-- {{{ tag.view_next_nonempty(direction, sc)
-- view the next empty tag in the direction
function tag.view_next_nonempty(direction, sc)
	local s = sc or awful.screen.focused()
	local curtag_index = s.selected_tag.index
	for i = 1, #s.tags do
		local nexttag
		if direction == 1 then
			nexttag = s.tags[gears.math.cycle(#s.tags, curtag_index + i)]
		else
			nexttag = s.tags[gears.math.cycle(#s.tags, curtag_index - i)]
		end
		-- now, in the newly selected tag,
		local clients = nexttag:clients()
		-- we check if there are no clients at all
		if #clients == 1 then
			if clients[1].class ~= "Polybar" then
				return nexttag:view_only()
			end
		elseif #clients ~= 0 then
			return nexttag:view_only()
		end
	end
end
-- }}}

-- {{{ tag.add(layout)
-- add a tag.
function tag.add(layout)
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

-- {{{ tag.delete()
-- delete the current tag.
function tag.delete()
	local t = awful.screen.focused().selected_tag
	if not t then return end
	t:delete()
end
-- }}}

-- {{{ tag.rename()
-- rename the current tag.
function tag.rename()
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

-- {{{ tag.move(pos)
-- move the current tag to pos
function tag.move(pos)
	local tag = awful.screen.focused().selected_tag
	if tonumber(pos) <= -1 then
		awful.tag.move(tag.index - 1, tag)
	else
		awful.tag.move(tag.index + 1, tag)
	end
end
-- }}}

return tag

-- vim:ft=lua:foldmethod=marker
