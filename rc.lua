-- standard awesome library
local awful = require("awful")
local gears = require("gears")
require("awful.autofocus")
confdir = awful.util.get_configuration_dir()
-- widget library
local wibox = require("wibox")
-- theme handling library
local beautiful = require("beautiful")
-- notification library
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- define the default modifier keys
altkey = "Mod1"
modkey = "Mod4"

-- default terminal and editor
terminal = "kitty"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- theme definition
beautiful.init(confdir .. "/themes/caladan/theme.lua")

-- table of layouts
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.top,
  awful.layout.suit.max,
  awful.layout.suit.floating
}

-- time widget
local textclock = wibox.widget.textclock("%H:%M")
local clock_icon = wibox.widget.imagebox(beautiful.clock)
local clock_background = wibox.container.background(textclock, beautiful.bg_focus, gears.shape.rectangle)
clock_background.fg = beautiful.fg_focus
local clock_widget = wibox.container.margin(clock_background, 0, 10, 5, 5)

-- calendar widget
local calendar = wibox.widget.textclock("%d %b")
local calendar_icon = wibox.widget.imagebox(beautiful.calendar)
local calendar_background = wibox.container.background(calendar, beautiful.bg_focus, gears.shape.rectangle)
calendar_background.fg = beautiful.fg_focus
local calendar_widget = wibox.container.margin(calendar_background, 0, 10, 5, 5)

-- handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err) })
    in_error = false
  end)
end

-- bindings for the taglist
local taglist_buttons = awful.util.table.join(
  awful.button({ }, 1, function (tag) tag:view_only() end),
  awful.button({ modkey }, 1, function (tag)
    if client.focus then
      client.focus:move_to_tag(tag)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function (tag)
    if client.focus then
      client.focus:toggle_tag(tag)
    end
  end),
  awful.button({ }, 4, function (tag) awful.tag.viewnext(tag.screen) end),
  awful.button({ }, 5, function (tag) awful.tag.viewprev(tag.screen) end)
)

local function set_wallpaper(screen)
  -- wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(screen)
    end
    gears.wallpaper.maximized(wallpaper, screen, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- create a wibox for each screen
awful.screen.connect_for_each_screen(function(screen)
  -- wallpaper
  set_wallpaper(screen)

  -- taglist definition
  awful.tag({ "TERM", "DEV", "WEB", "IM", "MEDIA", "FLOAT", 7, 8, 9 }, screen, awful.layout.layouts[1])

  -- promptbox
  screen.promptbox = awful.widget.prompt()

  -- layoutbox
  screen.layoutbox = awful.widget.layoutbox(screen)
  screen.layoutbox:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end))
  )

  -- create the taglist widget
  screen.taglist = awful.widget.taglist(screen, awful.widget.taglist.filter.all, taglist_buttons)

  -- create the wibox
  screen.wibox = awful.wibar({ position = "top", screen = screen, height = 32 })

  -- add widgets to the wibox
  screen.wibox:setup {
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      screen.taglist,
      screen.layoutbox,
      screen.promptbox,
    },
    nil,
    {
      layout = wibox.layout.fixed.horizontal,
      calendar_icon,
      calendar_widget,
      clock_icon,
      clock_widget,
    }
  }
end)

-- mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))

-- key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey }, "s", hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }),
  awful.key({ modkey }, "Left", awful.tag.viewprev,
    { description = "view previous", group = "tag" }),
  awful.key({ modkey }, "Right", awful.tag.viewnext,
    { description = "view next", group = "tag" }),
  awful.key({ modkey }, "Escape", awful.tag.history.restore,
    { description = "go back", group = "tag" }),
  awful.key({ modkey }, "j", function () awful.client.focus.byidx(1) end,
    { description = "focus next by index", group = "client" }),
  awful.key({ modkey }, "k", function () awful.client.focus.byidx(-1) end,
    { description = "focus previous by index", group = "client" }),

  -- layout manipulation
  awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end,
    { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx( -1) end,
    { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
    { description = "focus the previous screen", group = "screen" }),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    { description = "go back", group = "client" }),

  -- standard programs
  awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
    { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }),
  awful.key({ modkey }, "l", function () awful.tag.incmwfact( 0.05) end,
    { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1, nil, true) end,
    { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey }, "space", function () awful.layout.inc(1) end,
    { description = "select next", group = "layout" }),
  awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end,
    { description = "select previous", group = "layout" }),

  -- prompt
  awful.key({ modkey }, "r", function () awful.screen.focused().promptbox:run() end),

  -- screen brightness
  awful.key({ }, "XF86MonBrightnessDown", function () awful.spawn("dbri -d 5") end),
  awful.key({ }, "XF86MonBrightnessUp", function () awful.spawn("dbri -i 5") end),

  -- volume
  awful.key({ }, "XF86AudioMute", function () awful.spawn("dvol -t") end),
  awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn("dvol -d 2") end),
  awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn("dvol -i 2") end),

  -- music
  awful.key({ }, "XF86AudioPrev", function () awful.spawn("ncmpcpp prev") end),
  awful.key({ }, "XF86AudioPlay", function () awful.spawn("ncmpcpp toggle") end),
  awful.key({ }, "XF86AudioNext", function () awful.spawn("ncmpcpp next") end),

  -- eject
  awful.key({ }, "XF86Eject", function () awful.spawn("eject") end)
)

clientkeys = awful.util.table.join(
  awful.key({ modkey }, "f",
  function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client" }),
  awful.key({ modkey }, "q", function (client) client:kill() end,
    { description = "close", group = "client" }),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
    { description = "toggle floating", group = "client" }),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    { description = "move to master", group = "client" }),
  awful.key({ modkey }, "o", function (client) client:move_to_screen() end,
    { description = "move to screen", group = "client" }),
  awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client" })
)

-- bind all key numbers to tags
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    -- view tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #"..i, group = "tag" }),
    -- toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag" }),
    -- move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" }),
    -- toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- set keys
root.keys(globalkeys)

-- client key bindings
clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
    client.focus = c
    c:raise()
  end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- client rules
awful.rules.rules = {
  -- all clients will match the basic rule for decoration, key and mouse bindings
  {
    rule = { },
    properties = {
      size_hints_honor = false,
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
  {
    rule = { class = "Firefox" },
    properties = {
      screen = 1,
      tag = "WEB"
    }
  }
}

-- signal function to execute when a new client appears
client.connect_signal("manage", function (client)
  if awesome.startup and not client.size_hints.user_position and not client.size_hints.program_position then
    awful.placement.no_offscreen(client)
  end
end)

-- enable sloppy focus, so that focus follows mouse
client.connect_signal("mouse::enter", function(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
    client.focus = c
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
