local util = require('awful.util')

local theme                                     = {}

-- {{{ Directories
local copycats_themes_dir                       = util.get_configuration_dir() .. "themes@copycats/"
local system_themes_dir                         = util.get_themes_dir()
local serialoverflow_themes_dir                 = util.get_configuration_dir() .. "themes@serialoverflow/"
local mywallpapers                              = util.get_configuration_dir() .. "wallpapers/"
local system_icon_dir                           = util.get_awesome_icon_dir()
-- }}}

-- {{{ General
theme.wallpaper                                 = mywallpapers .. "firewatch-tower.png"
theme.font                                      = "Terminus 9"
theme.awesome_icon                              = system_icon_dir .. "awesome16.png"
theme.icon_theme                                = nil
theme.menu_submenu_icon                         = system_themes_dir .. "default/submenu.png"
theme.menu_height                               = 15
theme.menu_width                                = 100
theme.useless_gap                               = 0
theme.useless_gap_width                         = 0
theme.border_width                              = 1
-- }}}

-- {{{ Colors
theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"
-- }}}

-- {{{ Taglist Icons
theme.taglist_squares_sel   = system_themes_dir .. "default/taglist/squarefw.png"
theme.taglist_squares_unsel = system_themes_dir .. "default/taglist/squarew.png"
-- }}}

-- {{{ Titlebar Icons
theme.titlebar_close_button_normal = system_themes_dir .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = system_themes_dir .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = system_themes_dir .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = system_themes_dir .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = system_themes_dir .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = system_themes_dir .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = system_themes_dir .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = system_themes_dir .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = system_themes_dir .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = system_themes_dir .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = system_themes_dir .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = system_themes_dir .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = system_themes_dir .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = system_themes_dir .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = system_themes_dir .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = system_themes_dir .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = system_themes_dir .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = system_themes_dir .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = system_themes_dir .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = system_themes_dir .. "default/titlebar/maximized_focus_active.png"
-- }}}

-- {{{ Layout Icons
theme.layout_fairh = system_themes_dir .. "default/layouts/fairhw.png"
theme.layout_fairv = system_themes_dir .. "default/layouts/fairvw.png"
theme.layout_floating  = system_themes_dir .. "default/layouts/floatingw.png"
theme.layout_magnifier = system_themes_dir .. "default/layouts/magnifierw.png"
theme.layout_max = system_themes_dir .. "default/layouts/maxw.png"
theme.layout_fullscreen = system_themes_dir .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = system_themes_dir .. "default/layouts/tilebottomw.png"
theme.layout_tileleft   = system_themes_dir .. "default/layouts/tileleftw.png"
theme.layout_tile = system_themes_dir .. "default/layouts/tilew.png"
theme.layout_tiletop = system_themes_dir .. "default/layouts/tiletopw.png"
theme.layout_spiral  = system_themes_dir .. "default/layouts/spiralw.png"
theme.layout_dwindle = system_themes_dir .. "default/layouts/dwindlew.png"
theme.layout_cornernw = system_themes_dir .. "default/layouts/cornernww.png"
theme.layout_cornerne = system_themes_dir .. "default/layouts/cornernew.png"
theme.layout_cornersw = system_themes_dir .. "default/layouts/cornersww.png"
theme.layout_cornerse = system_themes_dir .. "default/layouts/cornersew.png"
-- }}}



return theme

-- vim:filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:foldmethod=marker
