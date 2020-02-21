-- {{{ Libraries
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
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
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Added libraries
-- - local libraries
-- * tags and clients manipulation.
local util = require("util")
-- * Media Player (mpc as well) generic controller
local MediaPlayer = require('mediaplayer')

-- - luarocks
-- * pulseaudio widget
local Pulseaudio = require("pulseaudio_cli")
-- * constrain-mounse for multi-monitor setup for games
local constrm = require("constrain-mouse")
-- * getting width and hight of an image
local image = require('image')
-- * autostart made easy
local Autostart = require('autostart')
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
			text = tostring(err)
		})
		in_error = false
	end)
end
-- }}}

-- {{{ General variables
-- This is used later as the default terminal and editor to run.
local terminal = "urxvt"
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
local editor = os.getenv("EDITOR") or "editor"
local editor_cmd = terminal .. " -e " .. editor
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local mediaplayer = MediaPlayer()
local modkey = "Mod4"
local pulseaudio = Pulseaudio()
-- }}}
-- {{{ Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
	awful.layout.suit.corner.ne,
	awful.layout.suit.corner.sw,
	awful.layout.suit.corner.se,
}
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
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
beautiful.init(gears.filesystem.get_configuration_dir() .. "mytheme/init.lua")
-- }}}

-- {{{ Menu
local mymainmenu = awful.menu({
	items = {
		{ "Refresh Launcher Applications", function() menubar.refresh() end },
		{ "hotkeys", function() return false, hotkeys_popup.show_help end},
		{ "Manual", terminal .. " -e man awesome" },
		{ "Config", editor_cmd .. " " .. awesome.conffile },
		{ "Terminal", terminal },
		{ "Restart", awful.util.restart },
		{ "Quit", function () awesome.quit() end }
	}
})
local mylauncher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mymainmenu
})
-- }}}

-- {{{ calendar widgets settings
local calendar_popup_base_settings = {
	position = "tr",
	opacity = 1,
	bg = string.sub(beautiful.bg_normal, 1, 7) .. "80",
	font = beautiful.font,
	spacing = 0,
	week_numbers = true,
	start_sunday = true,
	long_weekdays = true,
	style_month = {fg_color = "#FFFFFF"},
	style_header = {fg_color = "#FFFFFF"},
	style_weekday = {fg_color = "#FFFFFF"},
	style_weeknumber = {fg_color = "#CCCCFF"},
	style_normal = {fg_color = "#FFFFFF"},
	style_focus = {},
}
local calendar_popup_widgets = {}
local datetime_widgets = {}
-- }}}
-- {{{ Tags
local tags = {
	settings = {
		{
			names = {
				"project",
				"media",
				"config"
			},
			layout = {
				awful.layout.suit.tile,
				awful.layout.suit.fair,
				awful.layout.suit.fair
			}
		},
		{
			names = {
				"web",
				"man"
			},
			layout = {
				awful.layout.suit.fair,
				awful.layout.suit.max
			}
		}
	}
}
-- repair tags.settings if screen:count is different than the hypothetical number of screens defined
-- tags.settings (#tags.settings)
local screen_count = screen:count()
local estimated_screen_count = #tags.settings
if estimated_screen_count > screen_count then
	for i = screen_count + 1, estimated_screen_count do
		for _,v in ipairs(tags.settings[i].names) do
			table.insert(tags.settings[screen_count].names, v)
		end
		for _,v in ipairs(tags.settings[i].layout) do
			table.insert(tags.settings[screen_count].layout, v)
		end
		tags.settings[i] = nil
	end
end
-- }}}
-- {{{ Taglist buttons
local taglist_buttons = gears.table.join(
	awful.button({						}, 1, function (t) t:view_only() end),
	awful.button({modkey				}, 1,
		function (t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end
	),
	awful.button({modeky				}, 3, awful.tag.viewtoggle),
	awful.button({modkey				}, 3,
		function (t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end
	),
	awful.button({						}, 4, function (t) awful.tag.viewnext(t.screen) end),
	awful.button({						}, 5, function (t) awful.tag.viewprev(t.screen) end)
)
-- }}}
-- {{{ Tasklist
local tasklist_buttons = gears.table.join(
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
-- {{{ Bringing all widgets tags and tasklist together
awful.screen.connect_for_each_screen(function (s)
	-- Wallpaper
	set_wallpaper(s)
	-- Each screen has its own tag table
	tags[s] = awful.tag(tags.settings[s.index].names, s, tags.settings[s.index].layout)
	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget for each screen
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(
		gears.table.join(
			awful.button({					}, 1, function () awful.layout.inc( 1) end),
			awful.button({					}, 3, function () awful.layout.inc(-1) end),
			awful.button({					}, 4, function () awful.layout.inc( 1) end),
			awful.button({					}, 5, function () awful.layout.inc(-1) end)
		)
	)
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		height ="20",
		screen = s
	})
	-- create callendar widgets for each screen
	if s.index == 1 then
		datetime_widgets[s.index] = wibox.widget.textclock(" | %A | %F | %R", 1)
	else
		datetime_widgets[s.index] = wibox.widget.textclock("%A | %F | %R", 1)
	end
	local settings = calendar_popup_base_settings
	settings.screen = s.index
	calendar_popup_widgets[s.index] = awful.widget.calendar_popup.month(settings)
	calendar_popup_widgets[s.index]:attach(datetime_widgets[s.index], "tr" , {on_hover = false})
	-- Add widgets to the wibox
	myrightwidgets = {
		{
			layout = wibox.layout.fixed.horizontal,
			wibox.widget.systray(),
			datetime_widgets[1],
			s.mylayoutbox
		},
		{
			layout = wibox.layout.fixed.horizontal,
			datetime_widgets[2],
			s.mylayoutbox
		}
	}
	myleftwidgets = {
		layout = wibox.layout.fixed.horizontal,
		mylauncher,
		s.mytaglist,
		s.mypromptbox,
	}
	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
		myleftwidgets,
		s.mytasklist, -- Middle widget
		myrightwidgets[s.index]
	}
end)
-- }}}
-- {{{ Autostart: Executed only after all widgets and tags and tasklist are put
local conf_dir = os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME') .. '/.config'
local autostart_conf_file = conf_dir .. '/autostart/'

local autostart_config = dofile(conf_dir .. '/autostart/awesomewm.lua')
autostart = Autostart:new(autostart_config)
autostart:run_all()
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
-- {{{ Global keys
globalkeys = gears.table.join(
	-- {{{ Tags Focus
	awful.key({modkey,				}, "l",			awful.tag.viewnext,
		{description = "view next", group = "tags focus"}),
	awful.key({modkey,				}, "h",			awful.tag.viewprev,
		{description = "view previous", group = "tags focus"}),
	awful.key({modkey,				}, "]",			function () util.tag.view_next_nonempty(1) end,
		{description = "view next nonempty", group = "tags focus"}),
	awful.key({modkey,				}, "[",			function () util.tag.view_next_nonempty(-1) end,
		{description = "view previous nonempty", group = "tags focus"}),
	awful.key({modkey,				}, "Escape",	awful.tag.history.restore,
		{description = "go to previously focused", group = "tags focus"}),
	awful.key({modkey,				}, "`",			constrm.toggle,
		{description = "go to previously focused", group = "tags focus"}),
	-- }}}
	-- {{{ Tags Edit
	awful.key({modkey,				}, "n",			function () util.tag.add() end,
		{description = "create a new tag with a prompt", group = "tags edit"}),
	awful.key({modkey,				}, "w",			function () util.tag.delete() end,
		{description = "delete currently focused tag", group = "tags edit"}),
	awful.key({modkey,				}, "r",			function () util.tag.rename() end,
		{description = "rename currently focused tag", group = "tags edit"}),
	-- }}}
	-- {{{ Tags Movement
	awful.key({modkey,"Control"		}, "l",			function () util.tag.move(1) end,
		{description = "move to next index", group = "tags movement"}),
	awful.key({modkey,"Control"		}, "h",			function () util.tag.move(-1) end,
		{description = "move to previous index", group = "tags movement"}),
	awful.key({modkey,"Control"		}, "i",			function () util.tag.move_to_screen(1) end,
		{description = "move to next screen", group = "tags movement"}),
	awful.key({modkey,"Control"		}, "u",			function () util.tag.move_to_screen(-1) end,
		{description = "move to previous screen", group = "tags movement"}),
	-- }}}
	-- {{{ Screens Focus
	awful.key({modkey,				}, "i",			function () awful.screen.focus_relative( 1) end,
		{description = "focus the next screen", group = "screens focus"}),
	awful.key({modkey,				}, "u",			function () awful.screen.focus_relative(-1) end,
		{description = "focus the previous screen", group = "screens focus"}),
	awful.key({modkey,				}, "d",			function () naughty.destroy_all_notifications(nil, nil) end,
		{description = "Destroy all notifications", group = "screens focus"}),
	-- }}}
	-- {{{ Prompts
	awful.key({modkey				}, "e", function () awful.screen.focused().mypromptbox:run() end,
		{description = "run a shell command", group = "prompts"}),
	awful.key({modkey				}, "x",
		function ()
			awful.prompt.run({
				prompt = "Run Lua code: ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = gears.filesystem.get_cache_dir() .. "/history_eval"
			})
		end,
		{description = "run a lua command", group = "prompts"}),
	awful.key({modkey				}, "b",
		function ()
			awful.prompt.run({
				prompt = "Run background command: ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = function(input)
					if not input or #input == 0 then
						return
					end
					local program = {
						bin = input
					}
					local pid = autostart:spawn(program)
					if type(pid) == "string" then
						naughty.notify({
							preset = naughty.config.presets.critical,
							text = pid
						})
					end
				end,
				history_path = gears.filesystem.get_cache_dir() .. "/history_eval"
			})
		end,
		{description = "run a background command with autostart", group = "prompts"}),
	-- }}}
	-- {{{ HELP
	awful.key({modkey,"Shift"		}, "/",			hotkeys_popup.show_help,
		{description="show help", group="HELP"}),
	-- }}}
	-- {{{ Menus
	awful.key({modkey,				}, "s",			function () menubar.show() end,
		{description = "show programs menu", group = "menus"}),
	awful.key({modkey				}, "m",			function () mymainmenu:show() end,
		{description = "show main menu", group = "menus"}),
	-- }}}
	-- {{{ Launchers
	awful.key({modkey,				}, "t",			function ()
		awful.spawn("nautilus " .. os.getenv('HOME') .. '/desktop/university')
	end,
		{description = "open file manager in ~/desktop/university", group = "launchers"}),
	awful.key({modkey,				}, "Return",	function () awful.spawn(terminal) end,
		{description = "open a terminal", group = "launchers"}),
	awful.key({modkey, "Shift"		}, "d",			function ()
		local screen_index = awful.screen.focused().index
		calendar_popup_widgets[screen_index]:toggle()
	end,
		{description = "Toggle calendar popup", group = "launchers"}),
	-- }}}
	-- {{{ Session
	awful.key({modkey,"Mod1"		}, "r",			function ()
		local message
		if autostart:is_running('xscreensaver') then
			if autostart:kill_by_name('xscreensaver') then
				message = "xscreensaver was killed"
			else
				message = "couldn't kill xscreensaver process, perhaps it's a bug with autostart module"
			end
		else
			autostart:spawn({
				bin = { 'xscreensaver', '-no-splash' }
			})
			message = "xscreensaver was restarted"
		end
		naughty.notify({
			preset = naughty.config.presets.normal,
			text = message
		})
	end,
		{description = "toggle screen saver", group = "session"}),
	awful.key({modkey,"Mod1"		}, "q",			function ()
		if not autostart:is_running('xscreensaver') then
			autostart:spawn({
				name = 'xscreensaver',
				bin = { 'xscreensaver', '-no-splash' }
			})
			naughty.notify({
				preset = naughty.config.presets.normal,
				text = "xscreensaver was restarted"
			})
			-- If the xscreensaver daemon was needed to be restarted, a small delay is needed
			awful.spawn.with_shell("sleep 0.1 && xscreensaver-command -lock", false)
		else
			-- otherwise, not
			awful.spawn("xscreensaver-command -lock", false)
		end
	end,
		{description = "lock now the session with xscreensaver", group = "session"}),
	awful.key({modkey,"Mod1"		}, "z",			function ()
		awful.spawn.with_shell("xscreensaver-command -lock && systemctl suspend", false)
	end,
		{description = "lock now the session with xscreensaver and enter suspension", group = "session"}),
	-- }}}
	-- {{{ Autostart module logging level
	awful.key({modkey, "Shift"		}, "=",			function ()
		autostart.logger:setLevel(autostart.logger.level_order + 1)
		naughty.notify({
			preset = naughty.config.presets.normal,
			text = "autostart logger log level set to " .. autostart.logger.level
		})
	end,
		{description = "Raise autostart module logging level", group = "autostart"}),
	awful.key({modkey,				}, "-",			function ()
		autostart.logger:setLevel(autostart.logger.level_order - 1)
		naughty.notify({
			preset = naughty.config.presets.normal,
			text = "autostart logger log level set to " .. autostart.logger.level
		})
	end,
		{description = "Lower autostart module logging level", group = "autostart"}),
	-- }}}
	-- {{{ PrintScrn
	awful.key({						}, "Print",		function () awful.spawn.with_shell(
		"maim --format=png " .. os.getenv("HOME") .. "/pictures/screenshots/" .. os.getenv("HOST") .. "-desktop:" .. os.date("%Y.%m.%d-%X") .. ".png",
		false
	) end,
		{description = "screenshot all desktop and save it to ~/pictures/screenshots/", group = "PrintScrn"}),
	awful.key({"Control"			}, "Print",		function () awful.spawn.with_shell(
		"maim --format=png -s -c 1,0,0.6 " .. os.getenv("HOME") .. "/pictures/screenshots/" .. os.getenv("HOST") .. "-selection:" .. os.date("%Y.%m.%d-%X") .. ".png",
		false
	) end,
		{description = "screenshot a selection and save it to ~/pictures/screenshots/", group = "PrintScrn"}),
	awful.key({"Control", "Shift"	}, "Print",		function () awful.spawn.with_shell(
		"maim --format=png -s -c 1,0,0.6 \"$(zenity --file-selection --save --filename=\"" .. os.getenv("HOME") .. "/pictures/screenshots/" .. os.getenv("HOST") .. "-selection:" .. os.date("%Y.%m.%d-%X") .. ".png\" --confirm-overwrite --file-filter='PNG files | *.png')\"",
		false
	) end,
		{description = "screenshot a selection and save it to in a path of your choice", group = "PrintScrn"}),
	awful.key({modkey				}, "Print",		function () awful.spawn.with_shell(
		"maim --format=png -i $(xdotool getactivewindow) " .. os.getenv("HOME") .. "/pictures/screenshots/" .. os.getenv("HOST") .. " - \"$(xdotool getwindowname $(xdotool getactivewindow))\":" .. os.date("%Y.%m.%d-%X") .. ".png",
		true
	) end,
		{description = "screenshot the current window focused and save it to ~/pictures/screenshots/", group = "PrintScrn"}),
	awful.key({"Mod1"				}, "Print",		function () awful.spawn.with_shell(
		"recordmydesktop --no-sound",
		false
	) end,
		{description = "video record the Desktop and save it to the home directory", group = "PrintScrn"}),
	-- }}}
	-- {{{ Media Players:
	awful.key({modkey,"Control"		}, "Scroll_Lock",function () mediaplayer:cycle_players() end,
		{description = "toggle Play/Pause", group = "media player"}),
	awful.key({modkey,"Control"		}, "Pause",		function () mediaplayer:toggle_play() end,
		{description = "toggle Play/Pause", group = "media player"}),
	awful.key({modkey,"Control"		}, "F9",		function () mediaplayer:next() end,
		{description = "next song in playlist", group = "media player"}),
	awful.key({modkey,"Control"		}, "F8",		function () mediaplayer:previous() end,
		{description = "privious song in playlist", group = "media player"}),
	awful.key({modkey,"Control"		}, "F12",		function () mediaplayer:seek(5) end,
		{description = "seek forward", group = "media player"}),
	awful.key({modkey,"Control"		}, "F11",		function () mediaplayer:seek(-5) end,
		{description = "seek backwards", group = "media player"}),
	awful.key({modkey,"Control"		}, "F10",		function () mediaplayer:volume_up(5) end,
		{description = "volume up", group = "media player"}),
	awful.key({modkey,"Control"		}, "F7",		function () mediaplayer:volume_down(5) end,
		{description = "volume down", group = "media player"}),
	-- }}}
	-- {{{ General Machine Volume management:
	awful.key({modkey,				}, "F10",		pulseaudio.volume_up,
		{description = "volume up", group = "machine volume"}),
	awful.key({modkey,				}, "F7",		pulseaudio.volume_down,
		{description = "volume down", group = "machine volume"}),
	awful.key({modkey,				}, "Scroll_Lock",pulseaudio.toggle_muted,
		{description = "toggle volume mute", group = "machine volume"}),
	awful.key({modkey,				}, "F1",		pulseaudio.cycle_sinks,
		{description = "cycle through available sinks", group = "machine volume"}),
	awful.key({modkey,"Shift"		}, "F10",		pulseaudio.volume_up_mic,
		{description = "microphone volume up", group = "machine volume"}),
	awful.key({modkey,"Shift"		}, "F7",		pulseaudio.volume_down_mic,
		{description = "microphone volume down", group = "machine volume"}),
	awful.key({modkey,"Shift"		}, "Scroll_Lock",pulseaudio.toggle_muted_mic,
		{description = "microphone toggle volume mute", group = "machine volume"}),
	awful.key({modkey,"Shift"		}, "F1",		pulseaudio.cycle_sources,
		{description = "cycle through available sources", group = "machine volume"})
	-- }}}
)
-- }}}
-- {{{ Bind all key numbers to tags.
local numericpad = {87, 88, 89, 83, 84, 85, 79, 80, 81}
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		-- {{{ Clients focus
		awful.key({modkey,"Control","Shift"	}, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{description = "toggle focused client on tag #" .. i, group = "clients focus"}
		),
		awful.key({modkey,"Control","Shift"	}, "#" .. numericpad[i],
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{description = "toggle focused client on tag #" .. i, group = "clients focus"}
		),
		-- }}}
		-- {{{ Tags Focus
		awful.key({modkey					}, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{description = "view tag #"..i, group = "tags focus"}
		),
		awful.key({modkey					}, "#" .. numericpad[i],
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			{description = "view tag #"..i, group = "tags focus"}
		),
		awful.key({modkey,"Control"			}, "#" .. i + 9,
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{description = "toggle tag #" .. i, group = "tags focus"}
		),
		awful.key({modkey,"Control"			}, "#" .. numericpad[i],
			function ()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			{description = "toggle tag #" .. i, group = "tags focus"}
		),
		-- }}}
		-- {{{ Tags Movement
		awful.key({modkey,"Shift"			}, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{description = "move focused client to tag #"..i, group = "tags movement"}
		),
		awful.key({modkey,"Shift"			}, "#" .. numericpad[i],
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{description = "move focused client to tag #"..i, group = "tags movement"}
		)
		-- }}}
	)
end
-- }}}
-- {{{ Client keys
clientkeys = gears.table.join(
	-- {{{ Clients Focus
	awful.key({modkey,				}, "j", function () awful.client.focus.byidx( 1) end,
		{description = "focus next by index", group = "clients focus"}),
	awful.key({modkey,				}, "k", function () awful.client.focus.byidx(-1) end,
		{description = "focus previous by index", group = "clients focus"}),
	awful.key({modkey,				}, "g", awful.client.urgent.jumpto,
		{description = "jump to urgent client", group = "clients focus"}),
	awful.key({modkey,				}, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
		{description = "go to previously focused", group = "clients focus"}),
	-- }}}
	-- {{{ Clients Edit
	awful.key({modkey,				}, "q",	 		function (c) c:kill() end,
		{description = "close", group = "clients edit"}),
	-- }}}
	-- {{{ Clients Movement
	awful.key({modkey,"Shift"		}, "i",			function (c) c:move_to_screen(c.screen.index + 1) end,
		{description = "move to next screen", group = "clients movement"}),
	awful.key({modkey,"Shift"		}, "u",			function (c) c:move_to_screen(c.screen.index - 1) end,
		{description = "move to previous screen", group = "clients movement"}),
	awful.key({modkey,"Shift"		}, "l",			function (c) c:move_to_tag(c.screen.tags[gears.math.cycle(#c.screen.tags, c.first_tag.index + 1)]) end,
		{description = "move to next tag", group = "clients movement"}),
	awful.key({modkey,"Shift"		}, "h",			function (c) c:move_to_tag(c.screen.tags[gears.math.cycle(#c.screen.tags, c.first_tag.index - 1)]) end,
		{description = "move to previous tag", group = "clients movement"}),
	awful.key({modkey,"Mod1"		}, "l",			function () util.clients.move_all_to_tag(1) end,
		{description = "move all to next tag", group = "clients movement"}),
	awful.key({modkey,"Mod1"		}, "h",			function () util.clients.move_all_to_tag(-1) end,
		{description = "move all to previous tag", group = "clients movement"}),
	awful.key({modkey,"Mod1"		}, "i",			function () util.clients.move_all_to_screen(1) end,
		{description = "move all to next screen", group = "clients movement"}),
	awful.key({modkey,"Mod1"		}, "u",			function () util.clients.move_all_to_screen(-1) end,
		{description = "move all to previous screen", group = "clients movement"}),
	-- }}}
	-- {{{ Clients Layout
	awful.key({modkey,				}, "Up",		function () awful.client.swap.byidx(1) end,
		{description = "swap with next client by index", group = "clients layout"}),
	awful.key({modkey,				}, "Down",		function () awful.client.swap.byidx(-1) end,
		{description = "swap with previous client by index", group = "clients layout"}),
	awful.key({modkey,				}, "Right",		function () awful.tag.incmwfact( 0.02) end,
		{description = "increase master width factor", group = "clients layout"}),
	awful.key({modkey,				}, "Left",		function () awful.tag.incmwfact(-0.02) end,
		{description = "decrease master width factor", group = "clients layout"}),
	awful.key({modkey,"Shift"		}, "Right",		function () awful.tag.incnmaster( 1) end,
		{description = "increase the number of master clients", group = "clients layout"}),
	awful.key({modkey,"Shift"		}, "Left",		function () awful.tag.incnmaster(-1) end,
		{description = "decrease the number of master clients", group = "clients layout"}),
	awful.key({modkey,"Control"		}, "Right",		function () awful.tag.incncol( 1) end,
		{description = "increase the number of columns", group = "clients layout"}),
	awful.key({modkey,"Control"		}, "Left",		function () awful.tag.incncol(-1) end,
		{description = "decrease the number of columns", group = "clients layout"}),
	awful.key({modkey,				}, "space",		function () awful.layout.inc( 1) end,
		{description = "select next", group = "clients layout"}),
	awful.key({modkey,"Shift"		}, "space",		function () awful.layout.inc(-1) end,
		{description = "select previous", group = "clients layout"}),
	awful.key({modkey,"Control"		}, "Return",	function (c) c:swap(awful.client.getmaster()) end,
		{description = "move to master", group = "clients layout"}),
	awful.key({modkey,"Control"		}, "space", 	awful.client.floating.toggle,
		{description = "toggle floating", group = "clients layout"}),
	awful.key({modkey,"Control"		}, "t",
		function (c)
			c.ontop = not
			c.ontop
		end,
		{description = "toggle keep on top", group = "clients layout"}),
	awful.key({modkey,"Control"		}, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "clients layout"}
	),
	awful.key({modkey,"Control"		}, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end,
		{description = "maximize", group = "clients layout"}
	)
	-- }}}
)
-- }}}
-- {{{ Client buttons
clientbuttons = gears.table.join(
	awful.button({					}, 1, function (c) client.focus = c; c:raise() end),
	awful.button({modkey,			}, 1, awful.mouse.client.move),
	awful.button({modkey,			}, 3, awful.mouse.client.resize)
)
-- }}}
-- {{{ Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Notifications configuration - rejection and modification
naughty.config.notify_callback = function(args)
	-- The following callback function makes sure that no matter what size a notification wants to present an icon, it's size won't be above 250 pixels.
	if args.icon then
		if type(args.icon) == "string" then
			local icon_fpath = string.gsub(args.icon, "^file://", "", 1)
			if gears.filesystem.file_readable(icon_fpath) then
				local icon_width, icon_height = image.width_and_height(icon_fpath)
				if icon_width > 250 and icon_height > 250 then
					args.icon_size = 250
				end
			end
		end
	end
	-- The following condition makes sure that instant messages of kdeconnect
	-- notifications get an infinite timeout so I'll be able to respond to
	-- those messages by left clicking on the 'reply' button of them
	if args.title == "WhatsApp" or args.title == "QKSMS" then
		args.timeout = 0
	end
	-- The following makes sure no notifications are sent when there is a client on fullscreen
	local c = client.focus
	if c then
		if c.fullscreen then
			naughty.suspend()
			return
		else
			naughty.resume()
			return args
		end
	end
	return args
end
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
	{
		rule = {
			class = "Keybase",
			width = 360
		},
		properties = {
			placement = awful.placement.closest_corner
		},
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

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function (c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

client.connect_signal("focus", function (c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ modeline
-- vim:ft=lua:foldmethod=marker
-- }}}
