local awful = require("awful")

tag = {}

-- {{{ tag.move2position(incr)
-- Move a tag with all of it's clients to a different position.
-- Taken from https://github.com/geektophe/awesome-config/blob/de8cd6a3cd0d2d58effacfdc1d3698c34b17d172/utils/tag.lua#L10
function tag.move2position(incr)
	local tag = awful.tag.selected()
	local old_tag_index = awful.tag.getidx(tag)
	local tag_count = #awful.tag.gettags(awful.tag.getscreen(tag))
	local new_tag_index = awful.util.cycle(tag_count, old_tag_index + incr)
	awful.tag.move(new_tag_index, tag)
end
-- }}}

-- {{{ tag.move2screen(incr)
-- Move a tag with all of it's clients to a different screen.
-- Inspired from http://stackoverflow.com/questions/31272329/awesome-wm-how-to-change-tag-of-screen
function tag.move2screen(incr)
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

-- {{{ tag.rename()
-- Rename a tag
function tag.rename()
	awful.prompt.run({ prompt = "New tag name: " },
	mypromptbox[mouse.screen].widget,
	function(new_name)
		if not new_name or #new_name == 0 then
			return
		else
			local screen = mouse.screen
			local tag = awful.tag.selected(screen)
			if tag then
				tag.name = new_name
			end
		end
	end)
end
-- }}}

return tag

-- vim:ft=lua:foldmethod=marker
