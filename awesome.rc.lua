-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- For layout stuff
--local tag = require("awful.tag")
--For CPU widget
--require("obvious.cpu")


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
beautiful.init("/opt/home/dang/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "gnome-terminal"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"
email = "evolution"
im = "pidgin"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.fair,
    awful.layout.suit.magnifier,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    -- by instance
    ["mocp"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    -- ["Firefox"] = { screen = 1, tag = 2 },
    -- ["mocp"] = { screen = 2, tag = 4 },
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

function dfgtags(s)
	local t
	local name
	if type(s.screen) ~= "number" then
		error("No screen")
	elseif type(s.tag) ~= "number" then
		error("No tag number")
	end

	name = s.name or tostrin(s.tag)
	t = awful.tag({ name }, s.screen, s.layout or layouts[1])
        awful.layout.set(s.layout or layouts[1], t)
	if type(s.mwfact) == "number" then
		awful.tag.setmwfact(s.mwfact, t)
	end
	if type(s.ncol) == "number" then
		awful.tag.setncol(s.ncol, t)
	end
	tags[s.screen][s.tag] = t
end

-- {{{ Tags
-- This fucking sucks.  But it's not doable in a sane manor anymore.
names = {}
names[1] = { "Email", "Browser", "IM", 4, "Debug1", 6, 7, 8, "Debug2", 10, 11, 12, 13, 14, 15, 16 }
names[2] = { "Utility", "Dev1", "Dev1", "Dev3", "Dev4", "Build1", "Build2", "Build3", "Consoles", "Config", 11, 12, "Virtualization1", "Virtualization2", 15, 16 }
-- Define tags table.
tags = {}
---[[ dang.ghs.com screen layout
-- Screen utility
s = 1
tags[s] = awful.tag(names[1], s, layouts[10])
-- Fix tags with non-default layout
t = 3
awful.layout.set(layouts[1], tags[s][t])
awful.tag.setmwfact(0.8, tags[s][t])

-- Screen development
s = 2
tags[s] = awful.tag(names[2], s, layouts[10])
-- Fix tags with non-default layout
t = 1
awful.layout.set(layouts[1], tags[s][t])
awful.tag.setmwfact(0.3333333, tags[s][t])
awful.tag.setncol(3, tags[s][t])
t = 2
awful.layout.set(layouts[8], tags[s][t])
t = 3
awful.layout.set(layouts[8], tags[s][t])
t = 4
awful.layout.set(layouts[8], tags[s][t])
t = 5
awful.layout.set(layouts[8], tags[s][t])
t = 6
awful.layout.set(layouts[1], tags[s][t])
awful.tag.setmwfact(0.66666667, tags[s][t])
t = 7
awful.layout.set(layouts[1], tags[s][t])
awful.tag.setmwfact(0.66666667, tags[s][t])
t = 8
awful.layout.set(layouts[1], tags[s][t])
awful.tag.setmwfact(0.66666667, tags[s][t])
t = 9
awful.layout.set(layouts[5], tags[s][t])
t = 10
awful.layout.set(layouts[5], tags[s][t])
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

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
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

function northeast(screen, tagnum)
	if tagnum == 1 then
		return 1
	elseif tagnum == 2 then
		return 5
	elseif tagnum == 3 then
		return 6
	elseif tagnum == 4 then
		return 7
	elseif tagnum == 5 then
		return 5
	elseif tagnum == 6 then
		return 9
	elseif tagnum == 7 then
		return 10
	elseif tagnum == 8 then
		return 11
	elseif tagnum == 9 then
		return 9
	elseif tagnum == 10 then
		return 13
	elseif tagnum == 11 then
		return 14
	elseif tagnum == 12 then
		return 15
	elseif tagnum == 13 then
		return 13
	elseif tagnum == 14 then
		return 14
	elseif tagnum == 15 then
		return 15
	else
		return 16
	end
end
function north(screen, tagnum)
	if tagnum == 1 then
		return 1
	elseif tagnum == 2 then
		return 1
	elseif tagnum == 3 then
		return 2
	elseif tagnum == 4 then
		return 3
	elseif tagnum == 5 then
		return 5
	elseif tagnum == 6 then
		return 5
	elseif tagnum == 7 then
		return 6
	elseif tagnum == 8 then
		return 7
	elseif tagnum == 9 then
		return 9
	elseif tagnum == 10 then
		return 9
	elseif tagnum == 11 then
		return 10
	elseif tagnum == 12 then
		return 11
	elseif tagnum == 13 then
		return 13
	elseif tagnum == 14 then
		return 13
	elseif tagnum == 15 then
		return 14
	else
		return 15
	end
end
function northwest(screen, tagnum)
	if tagnum == 1 then
		return 1
	elseif tagnum == 2 then
		return 2
	elseif tagnum == 3 then
		return 3
	elseif tagnum == 4 then
		return 4
	elseif tagnum == 5 then
		return 5
	elseif tagnum == 6 then
		return 1
	elseif tagnum == 7 then
		return 2
	elseif tagnum == 8 then
		return 3
	elseif tagnum == 9 then
		return 9
	elseif tagnum == 10 then
		return 5
	elseif tagnum == 11 then
		return 7
	elseif tagnum == 12 then
		return 8
	elseif tagnum == 13 then
		return 13
	elseif tagnum == 14 then
		return 9
	elseif tagnum == 15 then
		return 10
	else
		return 11
	end
end
function east(screen, tagnum)
	if tagnum == 1 then
		return 5
	elseif tagnum == 2 then
		return 6
	elseif tagnum == 3 then
		return 7
	elseif tagnum == 4 then
		return 8
	elseif tagnum == 5 then
		return 9
	elseif tagnum == 6 then
		return 10
	elseif tagnum == 7 then
		return 11
	elseif tagnum == 8 then
		return 12
	elseif tagnum == 9 then
		return 13
	elseif tagnum == 10 then
		return 14
	elseif tagnum == 11 then
		return 15
	elseif tagnum == 12 then
		return 16
	elseif tagnum == 13 then
		return 13
	elseif tagnum == 14 then
		return 14
	elseif tagnum == 15 then
		return 15
	else
		return 16
	end
end
function west(screen, tagnum)
	if tagnum == 1 then
		return 1
	elseif tagnum == 2 then
		return 2
	elseif tagnum == 3 then
		return 3
	elseif tagnum == 4 then
		return 4
	elseif tagnum == 5 then
		return 1
	elseif tagnum == 6 then
		return 2
	elseif tagnum == 7 then
		return 3
	elseif tagnum == 8 then
		return 4
	elseif tagnum == 9 then
		return 5
	elseif tagnum == 10 then
		return 6
	elseif tagnum == 11 then
		return 7
	elseif tagnum == 12 then
		return 8
	elseif tagnum == 13 then
		return 9
	elseif tagnum == 14 then
		return 10
	elseif tagnum == 15 then
		return 11
	else
		return 12
	end
end
function southeast(screen, tagnum)
	if tagnum == 1 then
		return 6
	elseif tagnum == 2 then
		return 7
	elseif tagnum == 3 then
		return 8
	elseif tagnum == 4 then
		return 4
	elseif tagnum == 5 then
		return 10
	elseif tagnum == 6 then
		return 11
	elseif tagnum == 7 then
		return 12
	elseif tagnum == 8 then
		return 8
	elseif tagnum == 9 then
		return 14
	elseif tagnum == 10 then
		return 15
	elseif tagnum == 11 then
		return 16
	elseif tagnum == 12 then
		return 12
	elseif tagnum == 13 then
		return 13
	elseif tagnum == 14 then
		return 14
	elseif tagnum == 15 then
		return 15
	else
		return 16
	end
end
function south(screen, tagnum)
	if tagnum == 1 then
		return 2
	elseif tagnum == 2 then
		return 3
	elseif tagnum == 3 then
		return 4
	elseif tagnum == 4 then
		return 4
	elseif tagnum == 5 then
		return 6
	elseif tagnum == 6 then
		return 7
	elseif tagnum == 7 then
		return 8
	elseif tagnum == 8 then
		return 8
	elseif tagnum == 9 then
		return 10
	elseif tagnum == 10 then
		return 11
	elseif tagnum == 11 then
		return 12
	elseif tagnum == 12 then
		return 12
	elseif tagnum == 13 then
		return 14
	elseif tagnum == 14 then
		return 15
	elseif tagnum == 15 then
		return 16
	else
		return 16
	end
end
function southwest(screen, tagnum)
	if tagnum == 1 then
		return 1
	elseif tagnum == 2 then
		return 2
	elseif tagnum == 3 then
		return 3
	elseif tagnum == 4 then
		return 4
	elseif tagnum == 5 then
		return 2
	elseif tagnum == 6 then
		return 3
	elseif tagnum == 7 then
		return 4
	elseif tagnum == 8 then
		return 8
	elseif tagnum == 9 then
		return 6
	elseif tagnum == 10 then
		return 7
	elseif tagnum == 11 then
		return 8
	elseif tagnum == 12 then
		return 12
	elseif tagnum == 13 then
		return 10
	elseif tagnum == 14 then
		return 11
	elseif tagnum == 15 then
		return 12
	else
		return 16
	end
end
-- Directional desktop switching emulation
-- The 16 tags on each screen are laid out like this:
-- 1 5 9  13
-- 2 6 10 14
-- 3 7 11 15
-- 4 8 12 16
-- So, if you're on 5 and you go right, you get to 8.
function dfg_pick_desktop(direction)
	local screen = mouse.screen
	local tag = awful.tag.selected(screen)
	local found = 0
	for i, t in pairs(tags[screen]) do
		if tag == t then
			found = i
			break
		end
	end
	if found == 0 then
		-- Can't figure it out; stay here
		return tag
	end
	
	-- Now pick new direction
	if direction == "northeast" then
		return tags[screen][northeast(screen, found)]
	elseif direction == "north" then
		return tags[screen][north(screen, found)]
	elseif direction == "northwest" then
		return tags[screen][northwest(screen, found)]
	elseif direction == "east" then
		return tags[screen][east(screen, found)]
	elseif direction == "west" then
		return tags[screen][west(screen, found)]
	elseif direction == "southeast" then
		return tags[screen][southeast(screen, found)]
	elseif direction == "south" then
		return tags[screen][south(screen, found)]
	elseif direction == "southwest" then
		return tags[screen][southwest(screen, found)]
	else
		-- Don't understand the direction
		return tag
	end
end

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,    }, "Escape", awful.tag.history.restore),
    awful.key({ "Control", }, "Left", function() awful.tag.viewonly(dfg_pick_desktop("west")) end),
    awful.key({ "Control", }, "Right", function() awful.tag.viewonly(dfg_pick_desktop("east")) end),
    awful.key({ "Control", }, "Up", function() awful.tag.viewonly(dfg_pick_desktop("north")) end),
    awful.key({ "Control", }, "Down", function() awful.tag.viewonly(dfg_pick_desktop("south")) end),
    awful.key({ modkey, "Mod1", }, "h", function() awful.tag.viewonly(dfg_pick_desktop("west")) end),
    awful.key({ modkey, "Mod1", }, "l", function() awful.tag.viewonly(dfg_pick_desktop("east")) end),
    awful.key({ modkey, "Mod1", }, "k", function() awful.tag.viewonly(dfg_pick_desktop("north")) end),
    awful.key({ modkey, "Mod1", }, "j", function() awful.tag.viewonly(dfg_pick_desktop("south")) end),


    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "h",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "l",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Control" }, "h", function () awful.screen.focus_relative( 1)       end),
    awful.key({ modkey, "Control" }, "l", function () awful.screen.focus_relative(-1)       end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "b", function () awful.util.spawn(browser) end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn(email) end),
    awful.key({ modkey,           }, "i", function () awful.util.spawn(im) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey, "Shift"   }, "j",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "k",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "j",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "k",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "Left",   function (c) c.maximized_horizontal = false end),
    awful.key({ modkey,           }, "Right",   function (c) c.maximized_horizontal = true end),
    awful.key({ modkey,           }, "Down",   function (c) c.maximized_vertical = false end),
    awful.key({ modkey,           }, "Up",   function (c) c.maximized_vertical = true end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
