theme                                           = {}

-- {{{ Directories
local copycats_themes_dir                       = os.getenv("HOME") .. "/.config/awesome/themes@copycats"
local system_awesome_dir                        = "/usr/share/awesome"
local system_themes_dir                         = system_awesome_dir .. "themes"
local serialoverflow_themes_dir                 = os.getenv("HOME") .. "/.config/awesome/themes@serialoverflow"
local mywallpapers                              = os.getenv("HOME") .. "/.config/awesome/wallpapers"
-- }}}

-- {{{ General
theme.wallpaper                                 = mywallpapers .. "/firewatch-tower.png"
theme.font                                      = "Terminus 9"
theme.menu_height                               = 15
theme.menu_width                                = 100
theme.useless_gap_width                         = 0
-- }}}

-- {{{ Colors
theme.fg_normal                                 = "#DDDDFF"
theme.fg_focus                                  = "#F0DFAF"
theme.fg_urgent                                 = "#CC9393"
theme.bg_normal                                 = "#1A1A1A"
theme.bg_focus                                  = "#313131"
theme.bg_urgent                                 = "#1A1A1A"
theme.bg_minimize                               = "#444444"
theme.bg_systray                                = theme.bg_normal
theme.border_width                              = 1
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#7F7F7F"
theme.border_marked                             = "#CC9393"
theme.titlebar_bg_focus                         = "#FFFFFF"
theme.titlebar_bg_normal                        = "#FFFFFF"
theme.taglist_fg_focus                          = "#D8D782"
theme.tasklist_bg_focus                         = "#1A1A1A"
theme.tasklist_fg_focus                         = "#D8D782"
theme.textbox_widget_margin_top                 = 1
theme.notify_fg                                 = theme.fg_normal
theme.notify_bg                                 = theme.bg_normal
theme.notify_border                             = theme.border_focus
theme.awful_widget_height                       = 14
theme.awful_widget_margin_top                   = 2
theme.mouse_finder_color                        = "#CC9393"
theme.menu_height                               = "16"
theme.menu_width                                = "140"
-- }}}

-- {{{ Layouts
theme.layout_tile                               = copycats_themes_dir .. "/powerarrow-darker/icons/tile.png"
theme.layout_tilegaps                           = copycats_themes_dir .. "/powerarrow-darker/icons/tilegaps.png"
theme.layout_tileleft                           = copycats_themes_dir .. "/powerarrow-darker/icons/tileleft.png"
theme.layout_tilebottom                         = copycats_themes_dir .. "/powerarrow-darker/icons/tilebottom.png"
theme.layout_tiletop                            = copycats_themes_dir .. "/powerarrow-darker/icons/tiletop.png"
theme.layout_fairv                              = copycats_themes_dir .. "/powerarrow-darker/icons/fairv.png"
theme.layout_fairh                              = copycats_themes_dir .. "/powerarrow-darker/icons/fairh.png"
theme.layout_spiral                             = copycats_themes_dir .. "/powerarrow-darker/icons/spiral.png"
theme.layout_dwindle                            = copycats_themes_dir .. "/powerarrow-darker/icons/dwindle.png"
theme.layout_max                                = copycats_themes_dir .. "/powerarrow-darker/icons/max.png"
theme.layout_fullscreen                         = copycats_themes_dir .. "/powerarrow-darker/icons/fullscreen.png"
theme.layout_magnifier                          = copycats_themes_dir .. "/powerarrow-darker/icons/magnifier.png"
theme.layout_floating                           = copycats_themes_dir .. "/powerarrow-darker/icons/floating.png"
theme.layout_cornernw                           = system_themes_dir .. "default/layouts/cornernww.png"
theme.layout_cornerne                           = system_themes_dir .. "default/layouts/cornernew.png"
theme.layout_cornersw                           = system_themes_dir .. "default/layouts/cornersww.png"
theme.layout_cornerse                           = system_themes_dir .. "default/layouts/cornersew.png"
-- }}}

-- {{{ Widgets
theme.widget_ac                                 = copycats_themes_dir .. "/powerarrow-darker/icons/ac.png"
theme.widget_battery                            = copycats_themes_dir .. "/powerarrow-darker/icons/battery.png"
theme.widget_battery_low                        = copycats_themes_dir .. "/powerarrow-darker/icons/battery_low.png"
theme.widget_battery_empty                      = copycats_themes_dir .. "/powerarrow-darker/icons/battery_empty.png"
theme.widget_mem                                = copycats_themes_dir .. "/powerarrow-darker/icons/mem.png"
theme.widget_cpu                                = copycats_themes_dir .. "/powerarrow-darker/icons/cpu.png"
theme.widget_temp                               = copycats_themes_dir .. "/powerarrow-darker/icons/temp.png"
theme.widget_net                                = copycats_themes_dir .. "/powerarrow-darker/icons/net.png"
theme.widget_hdd                                = copycats_themes_dir .. "/powerarrow-darker/icons/hdd.png"
theme.widget_music                              = copycats_themes_dir .. "/powerarrow-darker/icons/note.png"
theme.widget_music_on                           = copycats_themes_dir .. "/powerarrow-darker/icons/note_on.png"
theme.widget_vol                                = copycats_themes_dir .. "/powerarrow-darker/icons/vol.png"
theme.widget_vol_low                            = copycats_themes_dir .. "/powerarrow-darker/icons/vol_low.png"
theme.widget_vol_no                             = copycats_themes_dir .. "/powerarrow-darker/icons/vol_no.png"
theme.widget_vol_mute                           = copycats_themes_dir .. "/powerarrow-darker/icons/vol_mute.png"
theme.widget_mail                               = copycats_themes_dir .. "/powerarrow-darker/icons/mail.png"
theme.widget_mail_on                            = copycats_themes_dir .. "/powerarrow-darker/icons/mail_on.png"
-- }}}

-- {{{ titlebar
theme.titlebar_close_button_normal              = system_themes_dir .. "/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = system_themes_dir .. "/default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = system_themes_dir .."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = system_themes_dir .."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = system_themes_dir .. "/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = system_themes_dir .. "/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = system_themes_dir .. "/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = system_themes_dir .. "/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = system_themes_dir .. "/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = system_themes_dir .. "/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = system_themes_dir .. "/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = system_themes_dir .. "/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = system_themes_dir .. "/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = system_themes_dir .. "/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = system_themes_dir .. "/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = system_themes_dir .. "/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = system_themes_dir .. "/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = system_themes_dir .. "/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = system_themes_dir .. "/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = system_themes_dir .. "/default/titlebar/maximized_focus_active.png"
-- }}}

-- {{{ various icons
theme.submenu_icon                              = copycats_themes_dir .. "/powerarrow-darker/icons/submenu.png"
theme.taglist_squares_sel                       = copycats_themes_dir .. "/powerarrow-darker/icons/square_sel.png"
theme.taglist_squares_unsel                     = copycats_themes_dir .. "/powerarrow-darker/icons/square_unsel.png"
theme.awesome_icon                              = system_awesome_dir .. "/icons/awesome16.png"
theme.icon_theme                                = nil
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:foldmethod=marker
