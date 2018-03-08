-- {{{ Libraries
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require('gears')
-- }}}

-- {{{ Directories
local configuration_dir                         = gears.filesystem.get_configuration_dir()
local system_themes_dir                         = gears.filesystem.get_themes_dir()
local system_icon_dir                           = gears.filesystem.get_awesome_icon_dir()
-- }}}

local theme                                     = {}

-- {{{ General
theme.font                                      = "Terminus 9"
theme.awesome_icon                              = system_icon_dir .. "awesome16.png"
theme.icon_theme                                = nil
theme.useless_gap                               = 0
theme.useless_gap_width                         = 0
theme.border_width                              = dpi(1)
theme.systray_icon_spacing                      = 5
-- }}}
-- {{{ Layout Icons
theme.layout_tile                               = configuration_dir .. "mytheme/icons/tile.png"
theme.layout_tilegaps                           = configuration_dir .. "mytheme/icons/tilegaps.png"
theme.layout_tileleft                           = configuration_dir .. "mytheme/icons/tileleft.png"
theme.layout_tilebottom                         = configuration_dir .. "mytheme/icons/tilebottom.png"
theme.layout_tiletop                            = configuration_dir .. "mytheme/icons/tiletop.png"
theme.layout_fairv                              = configuration_dir .. "mytheme/icons/fairv.png"
theme.layout_fairh                              = configuration_dir .. "mytheme/icons/fairh.png"
theme.layout_spiral                             = configuration_dir .. "mytheme/icons/spiral.png"
theme.layout_dwindle                            = configuration_dir .. "mytheme/icons/dwindle.png"
theme.layout_max                                = configuration_dir .. "mytheme/icons/max.png"
theme.layout_fullscreen                         = configuration_dir .. "mytheme/icons/fullscreen.png"
theme.layout_magnifier                          = configuration_dir .. "mytheme/icons/magnifier.png"
theme.layout_floating                           = configuration_dir .. "mytheme/icons/floating.png"
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
theme.submenu_icon                              = configuration_dir .. "mytheme/icons/submenu.png"
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
theme.widget_ac                                 = configuration_dir .. "mytheme/icons/ac.png"
theme.widget_battery                            = configuration_dir .. "mytheme/icons/battery.png"
theme.widget_battery_low                        = configuration_dir .. "mytheme/icons/battery_low.png"
theme.widget_battery_empty                      = configuration_dir .. "mytheme/icons/battery_empty.png"
theme.widget_mem                                = configuration_dir .. "mytheme/icons/mem.png"
theme.widget_cpu                                = configuration_dir .. "mytheme/icons/cpu.png"
theme.widget_temp                               = configuration_dir .. "mytheme/icons/temp.png"
theme.widget_net                                = configuration_dir .. "mytheme/icons/net.png"
theme.widget_hdd                                = configuration_dir .. "mytheme/icons/hdd.png"
theme.widget_music                              = configuration_dir .. "mytheme/icons/note.png"
theme.widget_music_on                           = configuration_dir .. "mytheme/icons/note_on.png"
theme.widget_vol                                = configuration_dir .. "mytheme/icons/vol.png"
theme.widget_vol_low                            = configuration_dir .. "mytheme/icons/vol_low.png"
theme.widget_vol_no                             = configuration_dir .. "mytheme/icons/vol_no.png"
theme.widget_vol_mute                           = configuration_dir .. "mytheme/icons/vol_mute.png"
theme.widget_mail                               = configuration_dir .. "mytheme/icons/mail.png"
theme.widget_mail_on                            = configuration_dir .. "mytheme/icons/mail_on.png"
-- }}}
-- {{{ Taglist
theme.taglist_squares_sel                       = configuration_dir .. "mytheme/icons/square_sel.png"
theme.taglist_squares_unsel                     = configuration_dir .. "mytheme/icons/square_unsel.png"
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

-- vim:filetype=lua:foldmethod=marker:expandtab
