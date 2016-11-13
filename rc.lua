-- standard awesome libraries
require("awful")
require("awful.autofocus")
require("awful.rules")
-- theme handling library
require("beautiful")

-- define the default modkey
modkey = "Mod4"

-- load theme
beautiful.init(awful.util.getdir("config") .. "/themes/caladan/theme.lua")

-- default terminal and editor
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- table of layouts
layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.top,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.floating
}

-- tags definition
tags = {}
-- each screen has its taglist
for s = 1, screen.count() do
	tags[s] = awful.tag({"term", "dev", "web", "im", "media", "float", 7, 8}, s, layouts[1])
end

-- time widget
textclock = awful.widget.textclock({ align = "right" })

-- wibox
wibox = {}
taglist = {}
taglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly)
)
promptbox = {}
layoutbox = {}

-- each screen has its wibox
for s = 1, screen.count() do
	-- taglist widget
	taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)
	
	-- promptbox
	promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })

	-- layoutbox
	layoutbox[s] = awful.widget.layoutbox(s) 
	-- create the wibox
	wibox[s] = awful.wibox({ position = "top", screen = s }) 
	-- add the widgets to the wibox
	wibox[s].widgets = {
		{
			taglist[s],
			layoutbox[s],
			promptbox[s],
			layout = awful.widget.layout.horizontal.leftright
		},
		textclock,
		layout = awful.widget.layout.horizontal.rightleft
	}
end

-- mouse bindings
root.buttons(
	awful.util.table.join(
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
	)
)

-- global key bindings
globalkeys = awful.util.table.join(
	-- tag navigation
	awful.key({ modkey }, "Left", awful.tag.viewprev),
	awful.key({ modkey }, "Right", awful.tag.viewnext),
	awful.key({ modkey }, "Escape", awful.tag.history.restore),

	-- hide/show the wibox
	awful.key({ modkey }, "b", function ()
		wibox[mouse.screen].visible = not wibox[mouse.screen].visible
	end),

	-- window navigation
	awful.key({ modkey }, "j", function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	end),
	awful.key({ modkey }, "k", function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end),

	-- layout manipulation
	awful.key({ modkey }, "l", function ()
		awful.tag.incmwfact(0.05)
	end),
	awful.key({ modkey }, "h", function ()
		awful.tag.incmwfact(-0.05)
	end),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey }, "Tab", function ()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end),
	awful.key({ modkey, "Shift "}, "j", function ()
		awful.client.swap.byidx(1)
	end),
	awful.key({ modkey, "Shift"}, "k", function ()
		awful.client.swap.byidx(-1)
	end),
	awful.key({ modkey, "Control"}, "j", function ()
		awful.screen.focus_relative(1)
	end),
	awful.key({ modkey, "Control"}, "k", function ()
		awful.screen.focus_relative(-1)
	end),

	-- layout switching
	awful.key({ modkey }, "space", function ()
		awful.layout.inc(layouts, 1)
	end),
	awful.key({ modkey, "Shift" }, "space", function ()
		awful.layout.inc(layouts, -1)
	end),

	-- standard program
	awful.key({ modkey }, "Return", function ()
		awful.util.spawn(terminal)
	end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	awful.key({ modkey, "Shift" }, "q", awesome.quit),

	-- prompt
	awful.key({ modkey }, "r", function ()
		promptbox[mouse.screen]:run()
	end),

	-- screen brightness
	awful.key({ }, "XF86MonBrightnessDown", function ()
		awful.util.spawn("dbri -d 5")
	end),
	awful.key({ }, "XF86MonBrightnessUp", function ()
		awful.util.spawn("dbri -i 5")
	end),

	-- volume
	awful.key({ }, "XF86AudioMute", function ()
		awful.util.spawn("dvol -t")
	end),
	awful.key({ }, "XF86AudioLowerVolume", function ()
		awful.util.spawn("dvol -d 2")
	end),
	awful.key({ }, "XF86AudioRaiseVolume", function ()
		awful.util.spawn("dvol -i 2")
	end),

	-- music
	awful.key({ }, "XF86AudioPrev", function ()
		awful.util.spawn("ncmpcpp prev")
	end),
	awful.key({ }, "XF86AudioPlay", function ()
		awful.util.spawn("ncmpcpp toggle")
	end),
	awful.key({ }, "XF86AudioNext", function ()
		awful.util.spawn("ncmpcpp next")
	end),

	-- eject
	awful.key({ }, "XF86Eject", function ()
		awful.util.spawn("eject")
	end)
)

-- bind numbers to tags
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({ modkey }, "#" .. i + 9, function ()
			local screen = mouse.screen
			if tags[screen][i] then
				awful.tag.viewonly(tags[screen][i])
			end
		end)
	)
end

-- set the global keys
root.keys(globalkeys)

-- client key bindings
clientkeys = awful.util.table.join(
	awful.key({ modkey }, "f", function (c)
		c.fullscreen = not c.fullscreen
	end),
	awful.key({ modkey }, "m", function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical = not c.maximized_vertical
	end),
	awful.key({ modkey }, "q", function (c)
		c:kill()
	end)
)

-- client mouse buttons bindings
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
	-- all clients match the basic rule for decoration, key and mouse bindings
	{
		rule = { },
		properties = {
			size_hints_honor = false,
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = true,
			keys = clientkeys,
			buttons = clientbuttons
		}
	},
	{
		rule = { class = "Firefox" },
		properties = {
			tag = tags[1][3]
		}
	}
}

-- signals
client.add_signal("manage", function (c, startup)
	-- enable sloppy focus
	c:add_signal("mouse::enter", function (c)
		if awful.client.focus.filter(c) then
			client.focus = c
		end
	end)

	-- set the window at the slave
	if not startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_overlap(c)
		awful.placement.no_offscreen(c)
	end
end)

-- signal to change border color when the client gets and loses the focus
client.add_signal("focus", function (c)
	c.border_color = beautiful.border_focus
end)
client.add_signal("unfocus", function (c)
	c.border_color = beautiful.border_normal
end)
