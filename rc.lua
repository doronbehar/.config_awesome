-- {{{ Libraries

-- Standard awesome library
-- package.path = package.path .. ";/usr/share/awesome/lib/?.lua"
-- package.path = package.path .. ";/usr/share/awesome/lib/?/init.lua"
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- * Widget and layout library
local wibox = require("wibox")
-- * Theme handling library
local beautiful = require("beautiful")
-- * Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- Added libraries
-- package.path = package.path .. ";/home/doron/repos/dotfiles/.config/awesome/?.lua"
-- package.path = package.path .. ";/home/doron/repos/dotfiles/.config/awesome/?/init.lua"

-- * Arch linux xdg-menu
require("archmenu")
-- * A library of mine to manipulate tags and clients.
local util = require("util")
-- * Obvious widgets library
local obvious = require("obvious")
-- * Copycats' `lain` widgets
local lain = require("lain")
-- * pulseaudio dbus widget
local pulseaudio_widget = require("pulseaudio_widget")

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
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

-- {{{ General variables
-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- }}}
-- {{{ Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
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
	awful.layout.suit.magnifier,
	lain.layout.termfair,
	lain.layout.centerfair,
	awful.layout.suit.corner.nw,
	awful.layout.suit.corner.ne,
	awful.layout.suit.corner.sw,
	awful.layout.suit.corner.se,
}
-- }}}
-- {{{ Menu
mymainmenu = awful.menu({
	items = {
		{ "Apps", xdgmenu },
		{ "Manual", terminal .. " -e man awesome" },
		{ "Config", editor_cmd .. " " .. awesome.conffile },
		{ "Terminal", terminal },
		{ "Restart", awful.util.restart },
		{ "Quit", function() awesome.quit() end }
	}
})
-- }}}

-- {{{ Theme
local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end
beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- {{{ Widgets
-- Common to all screens
mykeyboardlayout = awful.widget.keyboardlayout()
myclock = awful.widget.textclock("%H:%M:%S",1)
mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})
-- Create a promptbox for each screen
mypromptbox = awful.widget.prompt()
-- Helper
mydivider = wibox.widget.textbox()
mydivider:set_text(" | ")
-- 1st screen only
myvolume = pulseaudio_widget
mydate = awful.widget.textclock("%d/%m/%y",1)
obvious.basic_mpd.set_format("$title - $album")
obvious.basic_mpd.set_update_interval(0.5)
mymusicplayer = obvious.basic_mpd()
-- 2nd screen only
mysystray = wibox.widget.systray()
-- }}}
-- {{{ Right Widgets Setup
rightwidgets = {
	{
		mykeyboardlayout,
		mydivider,
		myvolume,
		mydivider,
		mydate,
		mydivider,
		myclock,
		mysystray
	},
	{
		mykeyboardlayout,
		mydivider,
		myclock
	}
}
-- }}}
-- {{{ Tags
tags = {
	settings = {
		{
			names = {
				"web",
				"man"
			},
			layout = {
				awful.layout.suit.floating,
				awful.layout.suit.max
			}
		},
		{
			names = {
				"project",
				"media",
				"config"
			},
			layout = {
				awful.layout.suit.tile,
				awful.layout.suit.tile,
				awful.layout.suit.tile
			}
		}
	}
}
-- }}}
-- {{{ Taglist buttons
local taglist_buttons = awful.util.table.join(
	awful.button({						}, 1, function(t) t:view_only() end),
	awful.button({modkey				}, 1,
		function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end
	),
	awful.button({modeky				}, 3, awful.tag.viewtoggle),
	awful.button({modkey				}, 3,
		function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end
	),
	awful.button({						}, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({						}, 5, function(t) awful.tag.viewprev(t.screen) end)
)
-- }}}
-- {{{ Tasklist
local tasklist_buttons = awful.util.table.join(
	awful.button({						}, 1,
		function (c)
			if c == client.focus then
				c.minimized = true
			else
				-- Without this, the following
				-- :isvisible() makes no sense
				c.minimized = false
				if not c:isvisible() and c.first_tag then
					c.first_tag:view_only()
				end
				-- This will also un-minimize
				-- the client, if needed
				client.focus = c
				c:raise()
			end
		end
	),
	awful.button({						}, 3,
		function ()
			if instance and instance.wibox.visible then
				instance:hide()
				instance = nil
			else
				instance = awful.menu.clients({
					theme = {
						width = 250
					}
				})
			end
		end
	),
	awful.button({						}, 4, function () awful.client.focus.byidx(1) end),
	awful.button({						}, 5, function () awful.client.focus.byidx(-1) end)
)
-- }}}
-- {{{ Bringing all widgets together
awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)
	-- Each screen has its own tag table
	tags[s] = awful.tag(tags.settings[s.index].names, s, tags.settings[s.index].layout)
	-- Create an imagebox widget for each screen
	mylayoutbox = awful.widget.layoutbox(s)
	mylayoutbox:buttons(
		awful.util.table.join(
			awful.button({					}, 1, function () awful.layout.inc( 1) end),
			awful.button({					}, 3, function () awful.layout.inc(-1) end),
			awful.button({					}, 4, function () awful.layout.inc( 1) end),
			awful.button({					}, 5, function () awful.layout.inc(-1) end)
		)
	)
	-- Create a taglist widget
	mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
	-- Create a tasklist widget
	mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
	-- Create the wibox
	mywibox = awful.wibar({
		position = "top",
		height ="20",
		screen = s
	})
	-- Add widgets to the wibox
	mywibox:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			mylauncher,
			mytaglist,
			mypromptbox,
		},
		mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			mykeyboardlayout,
			mydivider,
			myvolume,
			mydivider,
			mydate,
			mydivider,
			myclock,
			mysystray,
			mylayoutbox
		},
	}
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
-- {{{ Global keys
globalkeys = awful.util.table.join(
	-- {{{ Clients Focus
	awful.key({modkey,				}, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{description = "go back", group = "client"}
	),
	awful.key({modkey,				}, "j", function () awful.client.focus.byidx( 1) end,
		{description = "focus next by index", group = "client"}
	),
	awful.key({modkey,				}, "k", function () awful.client.focus.byidx(-1) end,
		{description = "focus previous by index", group = "client"}
	),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
		{description = "focus the next screen", group = "screen"}),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
		{description = "focus the previous screen", group = "screen"}),
	awful.key({modkey,				}, "g", awful.client.urgent.jumpto,
		{description = "jump to urgent client", group = "client"}),
	-- }}}
	-- {{{ Clients Layout Manipulation
	awful.key({modkey,				}, "Up",		function () awful.client.swap.byidx(  1) end,
		{description = "swap with next client by index", group = "client"}),
	awful.key({modkey,				}, "Down",		function () awful.client.swap.byidx( -1) end,
		{description = "swap with previous client by index", group = "client"}),
	awful.key({modkey,				}, "Right",		function () awful.tag.incmwfact( 0.02) end,
		{description = "increase master width factor", group = "layout"}),
	awful.key({modkey,				}, "Left",		function () awful.tag.incmwfact(-0.02) end,
		{description = "decrease master width factor", group = "layout"}),
	awful.key({modkey,"Shift"		}, "Right",		function () awful.tag.incnmaster( 1) end,
		{description = "increase the number of master clients", group = "layout"}),
	awful.key({modkey,"Shift"		}, "Left",		function () awful.tag.incnmaster(-1) end,
		{description = "decrease the number of master clients", group = "layout"}),
	awful.key({modkey,"Control"		}, "Right",		function () awful.tag.incncol( 1) end,
		{description = "increase the number of columns", group = "layout"}),
	awful.key({modkey,"Control"		}, "Left",		function () awful.tag.incncol(-1) end,
		{description = "decrease the number of columns", group = "layout"}),
	awful.key({modkey,				}, "space",		function () awful.layout.inc( 1) end,
		{description = "select next", group = "layout"}),
	awful.key({modkey,"Shift"		}, "space",		function () awful.layout.inc(-1) end,
		{description = "select previous", group = "layout"}),
	-- }}}
	-- {{{ Clients Manipulation
	awful.key({modkey,"Shift"		}, "l",			function() util.tag.moveclient(1) end),
	awful.key({modkey,"Shift"		}, "h",			function() util.tag.moveclient(-1) end),
	awful.key({modkey,"Mod1"		}, "l",			function() util.clients.move2tag(1) end),
	awful.key({modkey,"Mod1"		}, "h",			function() util.clients.move2tag(-1) end),
	awful.key({modkey,"Mod1"		}, "i",			function() util.clients.move2screen(1) end),
	awful.key({modkey,"Mod1"		}, "u",			function() util.clients.move2screen(-1) end),
	-- }}}
	-- {{{ Tags Focus
	awful.key({modkey,				}, "]",			function () lain.util.tag_view_nonempty(1) end),
	awful.key({modkey,				}, "[",			function () lain.util.tag_view_nonempty(-1) end),
	awful.key({modkey,				}, "l",			awful.tag.viewnext,
		{description = "view next", group = "tag"}),
	awful.key({modkey,				}, "h",			awful.tag.viewprev,
		{description = "view previous", group = "tag"}),
	awful.key({modkey,				}, "Escape",	awful.tag.history.restore,
		{description = "go back", group = "tag"}),
	-- }}}
	-- {{{ Tags Creation, Deletion and Renaimg
	awful.key({modkey,				}, "t",			function() lain.util.add_tag() end),
	awful.key({modkey,				}, "w",			function() lain.util.delete_tag() end),
	awful.key({modkey,"Shift"		}, "r",			function() lain.util.rename_tag() end),
	-- }}}
	-- {{{ Tags Manipulation
	awful.key({modkey,"Control"		}, "l",			function() lain.util.move_tag(1) end),
	awful.key({modkey,"Control"		}, "h",			function() lain.util.move_tag(-1) end),
	awful.key({modkey,"Control"		}, "i",			function() util.tag.move2screen(1) end),
	awful.key({modkey,"Control"		}, "u",			function() util.tag.move2screen(-1) end),
	-- }}}
	-- {{{ Screen Focus
	awful.key({modkey,				}, "i",			function() awful.screen.focus_relative( 1) end),
	awful.key({modkey,				}, "u",			function() awful.screen.focus_relative(-1) end),
	-- }}}
	-- {{{ Prompts
	awful.key({modkey				}, "r", function () awful.screen.focused().mypromptbox:run() end,
		{description = "run prompt", group = "launcher"}),
	awful.key({modkey				}, "x",
		function ()
			awful.prompt.run {
				prompt = "Run Lua code: ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval"
			}
			end,
		{description = "lua execute prompt", group = "awesome"}),
	awful.key({modkey,"Shift"		}, "/",			hotkeys_popup.show_help,
		{description="show help", group="awesome"}),
	awful.key({modkey,"Shift"		}, "m",			function () menubar.show() end,
		{description = "show main menu", group = "awesome"}
	),
	awful.key({modkey,"Shift"		}, "s",			function () mymainmenu:show() end,
		{description = "show main menu", group = "awesome"}
	),
	-- }}}
	-- {{{ Launchers
	awful.key({modkey,				}, "Return",	function () awful.util.spawn(terminal) end,
		{description = "open a terminal", group = "launcher"}),
	awful.key({"Control","Mod1"		}, "t",			function () awful.util.spawn(terminal .. " -T project -e sh -c \"tmux attach-session -t project || tmuxp load project || tmuxinator start project\"") end),
	awful.key({modkey,"Mod1"		}, "r",			awful.util.restart,
		{description = "reload awesome", group = "awesome"}),
	awful.key({modkey,"Mod1"		}, "q",			awesome.quit,
		{description = "quit awesome", group = "awesome"}),
	awful.key({modkey,"Mod1"		}, "x",			function () awful.util.spawn("systemctl poweroff",false) end),
	-- }}}
	-- {{{ PrintScrn
	awful.key({						}, "Print",		function () awful.util.spawn("maim $HOME/pictures/screenshots/$(date +%d.%m.%Y-%H:%M:%S).png",false) end),
	awful.key({"Control"			}, "Print",		function () awful.util.spawn("maim -s -c 1,0,0.6 $HOME/pictures/screenshots/$(date +%d.%m.%Y-%H:%M:%S).png",false) end),
	awful.key({modkey				}, "Print",		function () awful.util.spawn("maim $HOME/pictures/screenshots/$(date +%d.%m.%Y-%H:%M:%S).png",false) end),
	awful.key({"Mod1"				}, "Print",		function () awful.util.spawn("recordmydesktop --no-sound",false) end),
	-- }}}
	-- {{{ Music Player:
	awful.key({modkey,"Control"		}, "Pause",		function () obvious.basic_mpd.connection:toggle_play() end),
	awful.key({modkey,"Control"		}, "F9",
		function ()
			obvious.basic_mpd.connection:next()
			obvious.basic_mpd.update()
		end),
	awful.key({modkey,"Control"		}, "F8",
		function ()
			obvious.basic_mpd.connection:previous()
			obvious.basic_mpd.update()
		end),
	awful.key({modkey,"Control"		}, "F12",		function () awful.util.spawn("mpc seek +5") end),
	awful.key({modkey,"Control"		}, "F11",		function () awful.util.spawn("mpc seek -5") end),
	awful.key({modkey,"Control"		}, "F10",		function () obvious.basic_mpd.connection:volume_up(5) end),
	awful.key({modkey,"Control"		}, "F7",		function () obvious.basic_mpd.connection:volume_down(5) end),
	awful.key({modkey,"Control"		}, "Scroll_Lock", function () awful.util.spawn("mpc-toggle-mute") end),
	-- }}}
	-- {{{ General Machine Volume managment:
	awful.key({modkey 				}, "F10",		pulseaudio_widget.volume_up),
	awful.key({modkey				}, "F7",		pulseaudio_widget.volume_down),
	awful.key({modkey				}, "Scroll_Lock", pulseaudio_widget.toggle_muted),
	awful.key({modkey				}, "F1",		function () awful.util.spawn("toggle-sinks", false) end)
	-- }}}
)
-- }}}
-- {{{ Client keys
clientkeys = awful.util.table.join(
	-- {{{ General manipulation
	awful.key({modkey,				}, "q",	  function (c) c:kill() end,
		{description = "close", group = "client"}),
	awful.key({modkey,"Control"		}, "Return", function (c) c:swap(awful.client.getmaster()) end,
		{description = "move to master", group = "client"}),
	awful.key({modkey,				}, "o",	  function (c) c:move_to_screen() end,
		{description = "move to screen", group = "client"}),
	-- }}}
	-- {{{ Maximization and Minimaization
	awful.key({modkey,"Control"		}, "space",  awful.client.floating.toggle,
		{description = "toggle floating", group = "client"}),
	awful.key({modkey,				}, "t",	  function (c) c.ontop = not c.ontop end,
		{description = "toggle keep on top", group = "client"}),
	awful.key({ modkey,		   }, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}
	),
	awful.key({modkey,				}, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end,
		{description = "maximize", group = "client"}
	),
	awful.key({modkey,				}, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end,
		{description = "minimize", group = "client"}
	),
	awful.key({modkey,"Shift"		}, "n",
		function ()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				client.focus = c
				c:raise()
			end
		end,
		{description = "restore minimized", group = "client"}
	)
	-- }}}
)
-- }}}
-- {{{ Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local numericpad = { "KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin", "KP_Right", "KP_Home", "KP_Up", "KP_Prior" }
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
		-- {{{ View tag only.
		awful.key({ modkey }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
				   tag:view_only()
				end
			end,
			{description = "view tag #"..i, group = "tag"}
		),
		-- }}}
		-- {{{ Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{description = "toggle tag #" .. i, group = "tag"}
		),
		-- }}}
		-- {{{ Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
				function ()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:move_to_tag(tag)
						end
					end
				end,
			{description = "move focused client to tag #"..i, group = "tag"}
		),
		-- }}}
		-- {{{ Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
				function ()
					if client.focus then
						local tag = client.focus.screen.tags[i]
						if tag then
							client.focus:toggle_tag(tag)
						end
					end
				end,
			{description = "toggle focused client on tag #" .. i, group = "tag"}
		)
		-- }}}
	)
end
-- }}}
-- {{{ Client buttons
clientbuttons = awful.util.table.join(
	awful.button({					}, 1, function (c) client.focus = c; c:raise() end),
	awful.button({modkey,			}, 1, awful.mouse.client.move),
	awful.button({modkey,			}, 3, awful.mouse.client.resize)
)
-- }}}
-- {{{ Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				-- Firefox addon DownThemAll
				"DTA",
				-- Includes session name in class
				"copyq",
			},
			class = {
				"Arandr",
				"Gpick",
				"Kruler",
				-- kalarm
				"MessageWin",
				"Sxiv",
				"Wpa_gui",
				"pinentry",
				"veromix",
				"xtightvncviewer"
			},
			name = {
				-- xev
				"Event Tester",
			},
			role = {
				-- Thunderbird's calendar
				"AlarmWindow",
				-- e.g. Google Chrome's (detached) Developer Tools
				"pop-up",
			}
		},
		properties = {
			floating = true
		}
	},
	-- Add titlebars to normal clients and dialogs
	{
		rule_any = {
			type = {
				"normal",
				"dialog"
			}
		},
		properties = {
			titlebars_enabled = true
		}
	},
	-- Set Firefox to always map on the tag named "2" on screen 1.
	{
		rule = {
			class = "Firefox"
		},
		properties = {
			screen = 1,
			tag = "2"
		}
	},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end
	if awesome.startup and
		not c.size_hints.user_position
		and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = awful.util.table.join(
		awful.button({					}, 1,
			function()
				client.focus = c
				c:raise()
				awful.mouse.client.move(c)
			end
		),
		awful.button({					}, 3,
			function()
				client.focus = c
				c:raise()
				awful.mouse.client.resize(c)
			end
		)
	)
	awful.titlebar(c) : setup {
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout  = wibox.layout.fixed.horizontal
		},
		{ -- Middle
			{ -- Title
				align  = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton (c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton   (c),
			awful.titlebar.widget.ontopbutton	(c),
			awful.titlebar.widget.closebutton	(c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ modeline
-- vim:ft=lua:foldmethod=marker
-- }}}
