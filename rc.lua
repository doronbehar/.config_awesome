--{{{ Libraries
-- Standard awesome library
-- package.path = package.path .. ";/usr/share/awesome/lib/?.lua"
-- package.path = package.path .. ";/usr/share/awesome/lib/?/init.lua"
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Arch linux library for xdg-menu
xdg_menu = require("archmenu")

-- package.path = package.path .. ";/home/doron/repos/dotfiles/.config/awesome/?.lua"
-- package.path = package.path .. ";/home/doron/repos/dotfiles/.config/awesome/?/init.lua"
-- shifty - dynamic tagging library
local shifty = require("shifty")
local tyrannical = require("tyrannical")
-- sound widget:
require("volume/widget")

-- Obvious widgets library
require("obvious")

--}}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
	title = "Oops, there were errors during startup!",
	timeout = 10,
	text = awesome.startup_errors
})
end
-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			timeout = 10,
			text = err
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/theme.lua")
-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.maximized(beautiful.wallpaper, s, true)
	end
end
-- }}}

-- {{{ Shifty:
-- {{{Available options for each tag:
	-- init			:boolean	-- Create this tag at startup and be persistant.
	-- position		:integer	-- the position of the window.
	-- screen		:integer	-- the index of the screen: _Tip:_ use `screen = math.max(screen.count(), 2)` for the second monitor
	-- persistant	:boolean	-- Tell shifty to delete that tag if no client is present on it.
	-- mwfact		:float		-- Tell shifty what is the ratio of the windows to tile
	-- spawn		:string		-- A name of a program to open in that particular window when created.
	-- leave_kills	:boolean	-- Destroy/don't destroy after last client is closed _until switching to another tag_.
	-- icon_only	:boolean	-- Show icone only.
	-- icon			:string		-- Path to the icon in the tag list.
	-- rel_index	:integer	-- the index to open this tag compared to the current - Not at the end.
	-- nopopup		:boolean	-- if true, the tag will not be focused when created.
shifty.config.tags = {
	["web"] = {
		init		= true,
		position	= 1,
		screen		= 1,
	},
	["man"] = {
		init		= true,
		position	= 2,
		screen		= 1
	},
	["project"] = {
		init		= true,
		position	= 1,
		screen		= math.min(screen.count(), 2)
	},
	["Media"] = {
		init		= true,
		position	= 2,
		screen		= math.min(screen.count(), 2)
	},
	["config"] = {
		init		= true,
		position	= 3,
		screen		= math.min(screen.count(), 2)
	}
}
--}}}
-- {{{SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
	{
		match = {
			"ncmpcpp",
		},
		tag = "Media",
		nopopup = false,
	},
	{
		match = {""},
		buttons = awful.util.table.join(
			awful.button({}, 1, function (c) client.focus = c; c:raise() end),
			awful.button({modkey}, 1, function(c)
				client.focus = c
				c:raise()
				awful.mouse.client.move(c)
				end),
			awful.button({modkey}, 3, awful.mouse.client.resize)
			)
	},
}
--}}}
-- {{{SHIFTY: default tag creation rules
-- parameter description
--	* floatBars : if floating clients should always have a titlebar
--	* guess_name : should shifty try and guess tag names when creating
--				 new (unconfigured) tags?
--	* guess_position: as above, but for position parameter
--	* run : function to exec when shifty creates a new tag
--	* all other parameters (e.g. layout, mwfact) follow awesome's tag API
--	layout        :func   -- a layout from awful.layout.suit (e.g. awful.layout.suit.tile)
--	mwfact        :float  -- how big the master window is
--	nmaster       :int    -- how many columns for master windows
--	ncol          :int    -- how many columns for non-master windows
--	exclusive     :bool   -- if true, only clients from rules (config.apps) allowed in this tag
--	persist       :bool   -- persist after no apps are in it
--	nopopup       :bool   -- do not focus on creation
--	leave_kills   :bool   -- if true, tag won't be deleted until unselected
--	position      :int    -- determines position in taglist (then what does index do?)
--	icon          :string -- image file for icon
--	icon_only     :bool   -- if true, no text (just icon)
--	init          :bool   -- if true, create on startup (implies persist)
--	sweep_delay   :int    -- ???
--	keys          :{}     -- a table of keys, which are associated with the tag
--	overload_keys :{}     -- ???
--	index         :int    -- ???
--	rel_index     :int    -- ???
--	run           :func   -- a lua function which is execute on tag creation
--	spawn         :string -- shell command which is execute on tag creation (ex. a programm)
--	screen        :int    -- which screen to spawn on (see above)
--	max_clients   :int    -- if more than this many clients are started, then a new tag is made
shifty.config.defaults = {
	layout = awful.layout.suit.tile.bottom,
	ncol = 1,
	mwfact = 0.5,
	floatBars = false,
	guess_name = true,
	persist = true,
}
--}}}
-- }}}

-- {{{ Tyrannical:
-- First, set some settings
tyrannical.settings.default_layout =  awful.layout.suit.tile
tyrannical.settings.mwfact = 0.5
-- Setup some tags
tyrannical.tags = {
}
-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
}
-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
}
-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
}
-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
}
-- Do not honor size hints request for those classes
tyrannical.properties.size_hints_honor = {
}
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
mymainmenu = awful.menu({
	items = {
		{ "Apps", xdgmenu },
		{ "Manual", terminal .. " -e man awesome" },
		{ "Config", editor_cmd .. " " .. awesome.conffile },
		{ "Terminal", terminal },
		{ "Restart", awful.util.restart },
		{ "Quit", awesome.quit }
	}
})
mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
-- {{{ tasklist buttons.
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1,
		function (c)
			if c == client.focus then
				c.minimized = true
			else
				-- Without this, the following
				-- :isvisible() makes no sense
				c.minimized = false
				if not c:isvisible() then
					awful.tag.viewonly(c:tags()[1])
				end
				-- This will also un-minimize
				-- the client, if needed
				client.focus = c
				c:raise()
			end
		end),
	awful.button({ }, 3,
		function ()
			if instance then
				instance:hide()
				instance = nil
			else
				instance = awful.menu.clients({
					theme = { width = 250 }
				})
			end
		end),
	awful.button({ }, 4,
		function ()
			awful.client.focus.byidx(1)
			if client.focus then client.focus:raise() end
		end),
	awful.button({ }, 5,
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end)
)
-- }}}
-- {{{ Promptboxes
for s = 1, screen.count() do
	-- Create a promptbox for each screen
	mypromptbox[s] = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(
		awful.util.table.join(
		awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
		awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
		awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
		awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", height ="20", screen = s })
	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(mylauncher)
	left_layout:add(mytaglist[s])
	left_layout:add(mypromptbox[s])
	-- Widgets that are aligned to the right
	local right_layout = wibox.layout.fixed.horizontal()
		if s == math.min(screen.count(), 2) then
			right_layout:add(volume_widget)
			right_layout:add(awful.widget.textclock(" | %d/%m/%y - %H:%M:%S ",1))
		end
		if s == 1 then
			obvious.basic_mpd.set_format("$title - $album")
			obvious.basic_mpd.set_update_interval(0.5)
			right_layout:add(obvious.basic_mpd())
			right_layout:add(wibox.widget.systray())
		end
	right_layout:add(mylayoutbox[s])
	-- Now bring it all together (with the tasklist in the middle)
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)
	mywibox[s]:set_widget(layout)
end
-- }}}
-- }}}

-- {{{ Tags
-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()
-- }}}

-- {{{ Key bindings

-- {{{ globalkeys
-- {{{ functions
-- {{{ move tag with all of it's clients to a different position.
-- taken from https://github.com/geektophe/awesome-config/blob/de8cd6a3cd0d2d58effacfdc1d3698c34b17d172/utils/tag.lua#L10
function incr_tag_index(incr)
	local tag = awful.tag.selected()
	local old_tag_index = awful.tag.getidx(tag)
	local tag_count = #awful.tag.gettags(awful.tag.getscreen(tag))
	local new_tag_index = awful.util.cycle(tag_count, old_tag_index + incr)
	awful.tag.move(new_tag_index, tag)
end
-- }}}
-- {{{ move tag with all of it's clients to a different screen.
-- inspired from http://stackoverflow.com/questions/31272329/awesome-wm-how-to-change-tag-of-screen
function incr_tag_screen_index(incr)
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
-- {{{ move all of the client of a tag to a different tag on the current screen.
function incr_tag_clients_tag_index(incr)
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
-- {{{ move all of the clients of a tag to a different tag in a different screen.
function incr_tag_clients_screen_index(incr)
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
-- }}}
globalkeys = awful.util.table.join(
	--{{{ Tags and window manipulation and movement
	awful.key({modkey,				}, "Tab",		function() awful.screen.focus_relative( 1) end),
	awful.key({modkey,				}, "i",			function() awful.screen.focus_relative( 1) end),
	awful.key({modkey,				}, "u",			function() awful.screen.focus_relative(-1) end),
	awful.key({modkey,				}, "l",			awful.tag.viewnext),
	awful.key({modkey,				}, "h",			awful.tag.viewprev),
	awful.key({modkey,				}, "j",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({modkey,				}, "k",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({modkey,				}, "w",			shifty.del), -- delete a tag
	awful.key({modkey,"Shift"		}, "l",			shifty.send_next), -- client to next tag
	awful.key({modkey,"Shift"		}, "h",			shifty.send_prev), -- client to prev tag
	-- Move all tag's clients to next tag
	awful.key({modkey,"Mod1"		}, "l",			function() incr_tag_clients_tag_index(1) end),
	-- Move all tag's clients to previous tag
	awful.key({modkey,"Mod1"		}, "h",			function() incr_tag_clients_tag_index(-1) end),
	-- Move all tag's clients to next screen
	awful.key({modkey,"Mod1"		}, "i",			function() incr_tag_clients_screen_index(1) end),
	-- Move all tag's clients to previous screen
	awful.key({modkey,"Mod1"		}, "u",			function() incr_tag_clients_screen_index(-1) end),
	-- Move a tag right in one index
	awful.key({modkey,"Control"		}, "l",			function() incr_tag_index(1) end),
	-- Move a tag left in one index
	awful.key({modkey,"Control"		}, "h",			function() incr_tag_index(-1) end),
	-- Move a tag to a different screen
	awful.key({modkey,"Control"		}, "i",			function() incr_tag_screen_index(1) end),
	awful.key({modkey,"Control"		}, "u",			function() incr_tag_screen_index(-1) end),
	awful.key({modkey,"Shift"		}, "r",
		-- {{{ rename a tag
		function ()
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
		end),
		--}}}
	-- creat a new tag:
	awful.key({modkey,				}, "n",			shifty.add),
	--}}}
	--{{{ Layout manipulation
	awful.key({modkey,				}, "Up",		function () awful.client.swap.byidx(  1) end),
	awful.key({modkey,				}, "Down",		function () awful.client.swap.byidx( -1) end),
	awful.key({modkey,				}, "Right",		function () awful.tag.incmwfact( 0.02) end),
	awful.key({modkey,				}, "Left",		function () awful.tag.incmwfact(-0.02) end),
	awful.key({modkey,"Shift"		}, "Right",		function () awful.tag.incnmaster( 1) end),
	awful.key({modkey,"Shift"		}, "Left",		function () awful.tag.incnmaster(-1) end),
	awful.key({modkey,"Control"		}, "Right",		function () awful.tag.incncol( 1) end),
	awful.key({modkey,"Control"		}, "Left",		function () awful.tag.incncol(-1) end),
	awful.key({modkey,				}, "space",		function () awful.layout.inc(layouts, 1) end),
	awful.key({modkey,"Shift"		}, "space",		function () awful.layout.inc(layouts,-1) end),
	--}}}
	--{{{ Standard program
	awful.key({modkey,				}, "Return",	function () awful.util.spawn(terminal) end),
	awful.key({"Control","Mod1"		}, "t",			function () awful.util.spawn(terminal .. " -T project -e sh -c \"tmux attach-session -t project || tmux new -s project\"") end),
	awful.key({"Control","Mod1"		}, "w",			function () awful.util.spawn("google-chrome-stable") end),
	awful.key({"Control","Mod1"		}, "r",			function () awful.util.spawn(terminal .. " -e ranger") end),
	awful.key({"Control","Mod1"		}, "p",			function () awful.util.spawn(terminal .. " -e ncmpcpp") end),
	awful.key({"Control","Mod1"		}, "q",			function () awful.util.spawn("quartus") end),
	awful.key({modkey,"Mod1"		}, "r",			awful.util.restart),
	--}}}
	--{{{ bind PrintScrn to capture a screen
	awful.key({						}, "Print",		function () awful.util.spawn("capscr all",false) end),
	awful.key({"Control"			}, "Print",		function () awful.util.spawn("capscr frame",false) end),
	awful.key({modkey				}, "Print",		function () awful.util.spawn("capscr window",false) end),
	awful.key({"Mod1"				}, "Print",		function () awful.util.spawn("screencast",false) end),
	awful.key({modkey,"Mod1"		}, "q",			awesome.quit),
	awful.key({modkey,"Mod1"		}, "x",			function () awful.util.spawn("systemctl poweroff",false) end),
	--}}}
	--{{{ Music Player:
	awful.key({modkey,"Control"		}, "Pause",		function () awful.util.spawn("mpc toggle") end),
	awful.key({modkey,"Control"		}, "F9",		function () awful.util.spawn("mpc next") end),
	awful.key({modkey,"Control"		}, "F8",		function () awful.util.spawn("mpc prev") end),
	awful.key({modkey,"Control"		}, "F12",		function () awful.util.spawn("mpc seek +5") end),
	awful.key({modkey,"Control"		}, "F11",		function () awful.util.spawn("mpc seek -5") end),
	awful.key({modkey,"Control"		}, "F10",		function () awful.util.spawn("mpc volume +5") end),
	awful.key({modkey,"Control"		}, "F7",		function () awful.util.spawn("mpc volume -5") end),
	awful.key({modkey,"Control"		}, "Scroll_Lock", function () awful.util.spawn("mpc-toggle-mute") end),
	--}}}
	--{{{ General Machine Volume managment:
	awful.key({modkey 				}, "F10",		function () awful.util.spawn("amixer -D pulse set Master 4%+", false) end),
	awful.key({modkey				}, "F7",		function () awful.util.spawn("amixer -D pulse set Master 4%-", false) end),
	awful.key({modkey				}, "Scroll_Lock", function () awful.util.spawn("amixer -D pulse set Master toggle", false) end),
	awful.key({modkey				}, "F1",		function () awful.util.spawn("toggle-sinks", false) end),
	--}}}
	--{{{ Prompt
	awful.key({modkey				}, "r",			function () mypromptbox[mouse.screen]:run()end),
	awful.key({modkey				}, "x",
		function ()
			awful.prompt.run({ prompt = "Run Lua code: " },
			mypromptbox[mouse.screen].widget,
			awful.util.eval, nil,
			awful.util.getdir("cache") .. "/history_eval")
		end),
	--}}}
	--{{{ Menubar
	awful.key({modkey,"Mod1"		}, "m",			function () menubar.show() end),
	awful.key({modkey,				}, "s",			function () mymainmenu:show() end)
	--}}}
)
-- }}}

--{{{ clientkeys.
clientkeys = awful.util.table.join(
	awful.key({modkey,				}, "f",			function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({modkey,				}, "q",			function (c) c:kill()                         end),
	awful.key({modkey,"Shift"		}, "q",			awful.client.restore),
	awful.key({modkey,"Shift"		}, "space",		awful.client.floating.toggle                     ),
	awful.key({modkey,"Control"		}, "Return",	function (c) c:swap(awful.client.getmaster()) end),
	awful.key({modkey,"Shift"		}, "u",			function (c) awful.client.movetoscreen(c,c.screen-1) end ),
	awful.key({modkey,"Shift"		}, "i",			function (c) awful.client.movetoscreen(c,c.screen+1) end ),
	awful.key({modkey,				}, "t",			function (c) c.ontop = not c.ontop            end),
	awful.key({modkey,				}, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
)
--}}}

-- }}}

--{{{ SHIFTY: assign client keys to shifty for use in match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, (shifty.config.maxtags or 9) do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({ modkey }, "#" .. i + 9,
			function ()
				awful.tag.viewonly(shifty.getpos(i))
			end),
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				awful.tag.viewtoggle(shifty.getpos(i))
			end),
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function ()
				if client.focus then
					local t = shifty.getpos(i)
					awful.client.movetotag(t)
					awful.tag.viewonly(t)
				end
			end),
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				if client.focus then
					awful.client.toggletag(shifty.getpos(i))
				end
			end))
end
clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)
--}}}

-- {{{Set keys
root.keys(globalkeys)
-- }}}

--{{{
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
--}}}

-- vim:ft=lua:foldmethod=marker
