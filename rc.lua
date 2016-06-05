-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- shifty - dynamic tagging library
local shifty = require("shifty")
-- Awesompd:
local awesompd = require("mpd/awesompd")
local tyrannical = require("tyrannical")
-- sound widget:
require("volume/widget")
-- Load Debian menu entries
require("debian.menu")

-- {{{ Error handling
	-- Check if awesome encountered an error during startup and fell back to
	-- another config (This code will only ever execute for the fallback config)
	if awesome.startup_errors then
		naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors })
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
	terminal = "xterm"
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
	-- Available OPtions for each tag:
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
	-- configured tags.
	-- {{ Tag configuration for when the screens are switched.
		--shifty.config.tags = {
		--	["web"] = {
		--		position	= 1,
		--		init		= true,
		--		screen		= 1,
		--	},
		--	["1:project"] = {
		--		position	= 1,
		--		init		= true,
		--		screen		= math.max(screen.count(), 2),
		--	},
		--	["2:Media"] = {
		--		init		= true,
		--		position	= 2,
		--		screen		= math.max(screen.count(), 2),
		--	},
		--	["3:config"] = {
		--		init		= true,
		--		screen		= math.max(screen.count(), 2),
		--		position	= 3,
		--	}
		--}
	-- }}
	-- {{ Tag configuration for a single monitor enviorment.
		--shifty.config.tags = {
		--	["web"] = {
		--		position	= 1,
		--		init		= true,
		--		screen		= 1,
		--	},
		--	["1:project"] = {
		--		position	= 1,
		--		init		= true,
		--		screen		= 1,
		--	},
		--	["2:Media"] = {
		--		init		= true,
		--		position	= 2,
		--		screen		= 1,
		--	},
		--	["3:config"] = {
		--		init		= true,
		--		screen		= 1,
		--		position	= 3,
		--	}
		--}
	-- }}
	-- {{ Tag configuration for when the screens are not switched.
		shifty.config.tags = {
			["web"] = {
				position	= 1,
				init		= true,
				screen		= math.max(screen.count(), 2),
			},
			["1:project"] = {
				position	= 1,
				init		= true,
				screen		= 1,
			},
			["2:Media"] = {
				init		= true,
				screen		= 1,
				position	= 2,
			},
			["3:config"] = {
				init		= true,
				screen		= 1,
				position	= 3,
			}
		}
	-- }}
	-- SHIFTY: application matching rules
	-- order here matters, early rules will be applied first
	shifty.config.apps = {
		{
			match = {
				"ncmpcpp",
			},
			tag = "2:Media",
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
	-- SHIFTY: default tag creation rules
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
	myawesomemenu = {
		{ "manual", terminal .. " -e man awesome" },
		{ "edit config", editor_cmd .. " " .. awesome.conffile },
		{ "restart", awful.util.restart },
		{ "quit", awesome.quit }
	}
	mymainmenu = awful.menu({
		items = {
			{ "awesome", myawesomemenu, beautiful.awesome_icon },
			{ "Debian", debian.menu.Debian_menu.Debian },
			{ "open terminal", terminal }
		}
	})
	mylauncher = awful.widget.launcher({
		image = beautiful.awesome_icon,
		menu = mymainmenu
	})
	-- Menubar configuration
	menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ awesompd:
	musicwidget = awesompd:create() -- Create awesompd widget
	musicwidget.font = "DejaVu Sans Book 10" -- Set widget font
	musicwidget.scrolling = false -- If true, the text in the widget will be scrolled
	musicwidget.output_size = 40 -- Set the size of widget in symbols
	musicwidget.update_interval = 5 -- Set the update interval in seconds
	-- Set the folder where icons are located (change username to your login name)
	musicwidget.path_to_icons = "~/.config/awesome/mpd/icons"
	-- Set the default music format for Jamendo streams. You can change
	-- this option on the fly in awesompd itself.
	-- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
	musicwidget.jamendo_format = awesompd.FORMAT_MP3
	-- If true, song notifications for Jamendo tracks and local tracks will also contain
	-- album cover image.
	musicwidget.show_album_cover = true
	-- Specify how big in pixels should an album cover be. Maximum value
	-- is 100.
	musicwidget.album_cover_size = 70
	-- This option is necessary if you want the album covers to be shown
	-- for your local tracks.
	musicwidget.mpd_config = "/etc/mpd.conf"
	-- Specify the browser you use so awesompd can open links from
	-- Jamendo in it.
	musicwidget.browser = "google-chrome"
	-- Specify decorators on the left and the right side of the
	-- widget. Or just leave empty strings if you decorate the widget
	-- from outside.
	musicwidget.ldecorator = " "
	musicwidget.rdecorator = " "
	-- Set all the servers to work with (here can be any servers you use)
	musicwidget.servers = {{
		server = "localhost",
		port = 6600
	}}
	-- Set the buttons of the widget
	musicwidget:register_buttons({
		{ "", awesompd.MOUSE_LEFT,					musicwidget:command_playpause()		},
		{ "Control", awesompd.MOUSE_SCROLL_UP,		musicwidget:command_prev_track()	},
		{ "Control", awesompd.MOUSE_SCROLL_DOWN,	musicwidget:command_next_track()	},
		{ "", awesompd.MOUSE_SCROLL_UP,				musicwidget:command_volume_up()		},
		{ "", awesompd.MOUSE_SCROLL_DOWN,			musicwidget:command_volume_down()	},
		{ "", awesompd.MOUSE_RIGHT,					musicwidget:command_show_menu()		},
		{ "", "XF86AudioLowerVolume",				musicwidget:command_volume_down()	},
		{ "", "XF86AudioRaiseVolume",				musicwidget:command_volume_up()		},
		{ "Control", "Pause",						musicwidget:command_playpause()		}
	})
	musicwidget:run() -- After all configuration is done, run the widget
-- }}}

-- {{{ Wibox
	-- Create a textclock widget
	mytextclock = awful.widget.textclock()
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
			end))
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
		-- {{ layout for when the monitors are switched
			if s == math.max(screen.count(), 2) then
				-- Awesompd:
				right_layout:add(musicwidget.widget)
				right_layout:add(wibox.widget.systray())
			end
			if s == 1 then
				right_layout:add(volume_widget)
			end
		-- }}
		-- {{ layout for when the monitors are not switched
			--if s == math.max(screen.count(), 2) then
			--	right_layout:add(volume_widget)
			--end
			--if s == 1 then
			--	-- Awesompd:
			--	right_layout:add(musicwidget.widget)
			--	right_layout:add(wibox.widget.systray())
			--end
		-- }}
		right_layout:add(mytextclock)
		right_layout:add(mylayoutbox[s])
		-- Now bring it all together (with the tasklist in the middle)
		local layout = wibox.layout.align.horizontal()
		layout:set_left(left_layout)
		layout:set_middle(mytasklist[s])
		layout:set_right(right_layout)
		mywibox[s]:set_widget(layout)
	end
-- }}}

-- {{{ Tags
	-- SHIFTY: initialize shifty
	-- the assignment of shifty.taglist must always be after its actually
	-- initialized with awful.widget.taglist.new()
	shifty.taglist = mytaglist
	shifty.init()
-- }}}

-- {{{ Key bindings
	globalkeys = awful.util.table.join(
	-- Tags and window manipulation and movement with shifty:
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
		-- rename a tag:
		awful.key({modkey,"Shift"		}, "r",
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
		-- creat a new tag:
		awful.key({modkey,				}, "n",			shifty.add),
	-- Layout manipulation
		awful.key({modkey,				}, "Up",		function () awful.client.swap.byidx(  1)    end),
		awful.key({modkey,				}, "Down",		function () awful.client.swap.byidx( -1)    end),
		awful.key({modkey,				}, "Tab",		function () awful.screen.focus_relative( 1) end),
		awful.key({modkey,				}, "Right",		function () awful.tag.incmwfact( 0.02) end),
		awful.key({modkey,				}, "Left",		function () awful.tag.incmwfact(-0.02) end),
		awful.key({modkey,"Shift"		}, "Right",		function () awful.tag.incnmaster( 1)  end),
		awful.key({modkey,"Shift"		}, "Left",		function () awful.tag.incnmaster(-1)  end),
		awful.key({modkey,"Control"		}, "Right",		function () awful.tag.incncol( 1)   end),
		awful.key({modkey,"Control"		}, "Left",		function () awful.tag.incncol(-1)   end),
		awful.key({modkey,				}, "space",		function () awful.layout.inc(layouts, 1) end),
		awful.key({modkey,"Shift"		}, "space",		function () awful.layout.inc(layouts,-1) end),
	-- Standard program
		awful.key({modkey,				}, "Return",	function () awful.util.spawn(terminal) end),
		awful.key({"Control","Mod1"		}, "t",
			function ()
				awful.util.spawn(
					"xterm -T project -e \"tmux attach-session -t project || tmux\""
				)
			end),
		awful.key({"Control","Mod1"		}, "w",			function () awful.util.spawn("google-chrome") end),
		awful.key({"Control","Mod1"		}, "r",			function () awful.util.spawn("xterm -e ranger") end),
		awful.key({"Control","Mod1"		}, "p",			function () awful.util.spawn("xterm -T ncmpcpp -e ncmpcpp") end),
		awful.key({"Control","Mod1"		}, "e",			function () awful.util.spawn("xterm -e \"cd repos/dotfiles/.config/awesome; nvim rc.lua\"") end),
		awful.key({"Control","Mod1"		}, "q",			function () awful.util.spawn("quartus") end),
		awful.key({modkey,"Mod1"		}, "r",			awful.util.restart),
		-- bind PrintScrn to capture a screen
		awful.key({						}, "Print",		function () awful.util.spawn("capscr all",false) end),
		awful.key({"Control"			}, "Print",		function () awful.util.spawn("capscr frame",false) end),
		awful.key({modkey				}, "Print",		function () awful.util.spawn("capscr window",false) end),
		awful.key({modkey,"Mod1"		}, "q",			awesome.quit),
	-- Music Player:
		awful.key({						}, "Pause",		function () awful.util.spawn("mpc toggle") end),
		awful.key({						}, "F9",		function () awful.util.spawn("mpc next") end),
		awful.key({						}, "F8",		function () awful.util.spawn("mpc prev") end),
		awful.key({"Control"			}, "F12",		function () awful.util.spawn("mpc seek +5") end),
		awful.key({"Control"			}, "F11",		function () awful.util.spawn("mpc seek -5") end),
		awful.key({"Control"			}, "F10",		function () awful.util.spawn("mpc volume +5") end),
		awful.key({"Control"			}, "F7",		function () awful.util.spawn("mpc volume -5") end),
		awful.key({"Control"			}, "Scroll_Lock", function () awful.util.spawn("mpc-toggle-mute") end),
	-- General Machine Volume managment:
		awful.key({"Shift" 				}, "F10",		function () awful.util.spawn("amixer -D pulse set Master 4%+", false) end),
		awful.key({"Shift"				}, "F7",		function () awful.util.spawn("amixer -D pulse set Master 4%-", false) end),
		awful.key({"Shift"				}, "Scroll_Lock", function () awful.util.spawn("amixer -D pulse set Master toggle", false) end),
		awful.key({"Shift"				}, "F1",		function () awful.util.spawn("toggle-sinks", false) end),
	-- Prompt
		awful.key({modkey				}, "r",			function () mypromptbox[mouse.screen]:run()end),
		awful.key({modkey				}, "x",
			function ()
				awful.prompt.run({ prompt = "Run Lua code: " },
				mypromptbox[mouse.screen].widget,
				awful.util.eval, nil,
				awful.util.getdir("cache") .. "/history_eval")
			end),
	-- Menubar
		awful.key({modkey,"Mod1"		}, "m",			function () menubar.show() end),
		awful.key({modkey,				}, "s",			function () mymainmenu:show() end)
	)
	clientkeys = awful.util.table.join(
		awful.key({modkey,				}, "f",			function (c) c.fullscreen = not c.fullscreen  end),
		awful.key({modkey,				}, "q",			function (c) c:kill()                         end),
		awful.key({modkey,"Shift"		}, "q",			awful.client.restore),
		awful.key({modkey,"Shift"		}, "space",		awful.client.floating.toggle                     ),
		awful.key({modkey,"Control"		}, "Return",	function (c) c:swap(awful.client.getmaster()) end),
		awful.key({modkey,				}, "u",			function (c) awful.client.movetoscreen(c,c.screen-1) end ),
		awful.key({modkey,				}, "i",			function (c) awful.client.movetoscreen(c,c.screen+1) end ),
		awful.key({modkey,				}, "t",			function (c) c.ontop = not c.ontop            end),
		awful.key({modkey,				}, "m",
			function (c)
				c.maximized_horizontal = not c.maximized_horizontal
				c.maximized_vertical   = not c.maximized_vertical
			end)
	)
	-- SHIFTY: assign client keys to shifty for use in
	-- match() function(manage hook)
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
	-- Set keys
	root.keys(globalkeys)
-- }}}

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}
