-- {{{ Libraries
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local util = require('awful.util')
-- }}}

-- {{{ Directories
local configuration_dir                         = util.get_configuration_dir()
local copycats_themes_dir                       = configuration_dir .. "themes@copycats/"
local system_themes_dir                         = util.get_themes_dir()
local serialoverflow_themes_dir                 = configuration_dir .. "themes@serialoverflow/"
local system_icon_dir                           = util.get_awesome_icon_dir()
-- }}}

local theme                                     = {}

-- {{{ General
theme.font                                      = "Terminus 9"
theme.awesome_icon                              = system_icon_dir .. "awesome16.png"
theme.icon_theme                                = nil
theme.useless_gap                               = 0
theme.useless_gap_width                         = 0
theme.border_width                              = dpi(1)
-- }}}
-- {{{ Layout Icons
theme.layout_tile                               = copycats_themes_dir .. "powerarrow-darker/icons/tile.png"
theme.layout_tilegaps                           = copycats_themes_dir .. "powerarrow-darker/icons/tilegaps.png"
theme.layout_tileleft                           = copycats_themes_dir .. "powerarrow-darker/icons/tileleft.png"
theme.layout_tilebottom                         = copycats_themes_dir .. "powerarrow-darker/icons/tilebottom.png"
theme.layout_tiletop                            = copycats_themes_dir .. "powerarrow-darker/icons/tiletop.png"
theme.layout_fairv                              = copycats_themes_dir .. "powerarrow-darker/icons/fairv.png"
theme.layout_fairh                              = copycats_themes_dir .. "powerarrow-darker/icons/fairh.png"
theme.layout_spiral                             = copycats_themes_dir .. "powerarrow-darker/icons/spiral.png"
theme.layout_dwindle                            = copycats_themes_dir .. "powerarrow-darker/icons/dwindle.png"
theme.layout_max                                = copycats_themes_dir .. "powerarrow-darker/icons/max.png"
theme.layout_fullscreen                         = copycats_themes_dir .. "powerarrow-darker/icons/fullscreen.png"
theme.layout_magnifier                          = copycats_themes_dir .. "powerarrow-darker/icons/magnifier.png"
theme.layout_floating                           = copycats_themes_dir .. "powerarrow-darker/icons/floating.png"
theme.layout_cornernw                           = system_themes_dir .. "default/layouts/cornernww.png"
theme.layout_cornerne                           = system_themes_dir .. "default/layouts/cornernew.png"
theme.layout_cornersw                           = system_themes_dir .. "default/layouts/cornersww.png"
theme.layout_cornerse                           = system_themes_dir .. "default/layouts/cornersew.png"
-- }}}
-- {{{ Menu
theme.menu_bg_normal                            = "#1A1A1A"
theme.menu_bg_focus                             = "#313131"
theme.menu_fg_normal                            = "#DDDDFF"
theme.menu_fg_focus                             = "#F0DFAF"
theme.menu_border_color                         = "#FDFDFD"
theme.menu_submenu_icon                         = system_themes_dir .. "default/submenu.png"
theme.menu_height                               = dpi(15)
theme.menu_width                                = dpi(100)
theme.menu_border_width                         = 0
theme.submenu_icon                              = copycats_themes_dir .. "powerarrow-darker/icons/submenu.png"
-- }}}

-- {{{ Colors
theme.fg_normal                                 = "#DDDDFF"
theme.fg_focus                                  = "#F0DFAF"
theme.fg_urgent                                 = "#CC9393"
theme.fg_minimize                               = "#ffffff"

theme.bg_normal                                 = "#1A1A1A"
theme.bg_focus                                  = "#313131"
theme.bg_urgent                                 = "#1A1A1A"
theme.bg_minimize                               = "#444444"
theme.bg_systray                                = theme.bg_normal

theme.border_normal                             = "#000000"
theme.border_focus                              = "#535d6c"
theme.border_marked                             = "#91231c"

theme.notify_fg                                 = theme.fg_normal
theme.notify_bg                                 = theme.bg_normal
theme.notify_border                             = theme.border_focus

theme.mouse_finder_color                        = "#CC9393"
-- }}}

-- {{{ Widgets Icons
theme.widget_ac                                 = copycats_themes_dir .. "powerarrow-darker/icons/ac.png"
theme.widget_battery                            = copycats_themes_dir .. "powerarrow-darker/icons/battery.png"
theme.widget_battery_low                        = copycats_themes_dir .. "powerarrow-darker/icons/battery_low.png"
theme.widget_battery_empty                      = copycats_themes_dir .. "powerarrow-darker/icons/battery_empty.png"
theme.widget_mem                                = copycats_themes_dir .. "powerarrow-darker/icons/mem.png"
theme.widget_cpu                                = copycats_themes_dir .. "powerarrow-darker/icons/cpu.png"
theme.widget_temp                               = copycats_themes_dir .. "powerarrow-darker/icons/temp.png"
theme.widget_net                                = copycats_themes_dir .. "powerarrow-darker/icons/net.png"
theme.widget_hdd                                = copycats_themes_dir .. "powerarrow-darker/icons/hdd.png"
theme.widget_music                              = copycats_themes_dir .. "powerarrow-darker/icons/note.png"
theme.widget_music_on                           = copycats_themes_dir .. "powerarrow-darker/icons/note_on.png"
theme.widget_vol                                = copycats_themes_dir .. "powerarrow-darker/icons/vol.png"
theme.widget_vol_low                            = copycats_themes_dir .. "powerarrow-darker/icons/vol_low.png"
theme.widget_vol_no                             = copycats_themes_dir .. "powerarrow-darker/icons/vol_no.png"
theme.widget_vol_mute                           = copycats_themes_dir .. "powerarrow-darker/icons/vol_mute.png"
theme.widget_mail                               = copycats_themes_dir .. "powerarrow-darker/icons/mail.png"
theme.widget_mail_on                            = copycats_themes_dir .. "powerarrow-darker/icons/mail_on.png"
-- }}}
-- {{{ Taglist
theme.taglist_squares_sel                       = copycats_themes_dir .. "powerarrow-darker/icons/square_sel.png"
theme.taglist_squares_unsel                     = copycats_themes_dir .. "powerarrow-darker/icons/square_unsel.png"
theme.taglist_fg_focus                          = "#D8D782"
-- }}}
-- {{{ Tasklist
theme.tasklist_bg_focus                         = "#1A1A1A"
theme.tasklist_fg_focus                         = "#D8D782"
-- }}}

-- {{{ Titlebar Icons
theme.titlebar_close_button_normal              = system_themes_dir .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = system_themes_dir .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = system_themes_dir .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = system_themes_dir .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = system_themes_dir .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = system_themes_dir .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = system_themes_dir .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = system_themes_dir .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = system_themes_dir .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = system_themes_dir .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = system_themes_dir .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = system_themes_dir .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = system_themes_dir .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = system_themes_dir .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = system_themes_dir .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = system_themes_dir .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = system_themes_dir .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = system_themes_dir .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = system_themes_dir .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = system_themes_dir .. "default/titlebar/maximized_focus_active.png"
-- }}}

return theme

-- vim:filetype=lua:foldmethod=marker
