---------------------------
-- Default awesome theme --
---------------------------

local awful = require("awful")
confdir = awful.util.get_configuration_dir()
theme = {}

theme.font          = "Roboto Bold 10"
theme.taglist_font  = "Roboto Condensed BOLD 9.5"

theme.bg_normal     = "#303030"
theme.bg_focus      = "#303030"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- Define the image to load
theme.titlebar_close_button_normal = confdir .. "/icons/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = confdir .. "/icons/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = confdir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = confdir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = confdir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = confdir .. "/icons/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = confdir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = confdir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = confdir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = confdir .. "/icons/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = confdir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = confdir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = confdir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = confdir .. "/icons/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = confdir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = confdir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = confdir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = confdir .. "/icons/titlebar/maximized_focus_active.png"

theme.clock = confdir .. "/icons/clock.png"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "awsetbg /home/remy/images/wallpapers/rescape_starstrooper.jpg" }

-- You can use your own layout icons like this:
theme.layout_fairh = "/usr/share/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv = "/usr/share/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating  = "/usr/share/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max = "/usr/share/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "/usr/share/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft   = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile = "/usr/share/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral  = "/usr/share/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle = "/usr/share/awesome/themes/default/layouts/dwindlew.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

return theme
