-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
--local naughty = require("naughty")
local menubar = require("menubar")
-- For layout stuff
--local tag = require("awful.tag")
--For CPU widget
--require("obvious.cpu")

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

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
backup_terminal = "xterm"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser = "luakitsession browser"
email = "firefox"
im = "pidgin"
music = "nuvolaplayer"
ebook = "calibre"
reader = "luakitsession feeds"
pr0n = "luakitsession pr0n"
comics = "uzbl-tabbed http://www.comicagg.com/comics/read/"
bookmarks = "uzbl-tabbed file:///home/dang/bookmarks.html"

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
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- This fucking sucks.  But it's not doable in a sane manor anymore.
names = {}
names[1] = { "T", "T", "T", "V", 5, 6, 7, "Book", "IM", "T", "T", "M", "E", "B", "F", 16 }
names[2] = { "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T", "T" }
--names[1] = { "Email", "Browser", "IM", "Chrome", "VNC", "Build1", "Build2", "Logs", "Build3", "Build4", "Build5", "Build6", "Music", 14, 15, "GATT" }
--names[2] = { "Utility", "Dev1", "Dev2", "Dev3", "Dev4", "Dev5", "Dev6", "Dev7", "Consoles", "Config", "C trunk", "C 3.2", "Virtualization1", 14, "C 3.3", "C 3.1" }
-- Define tags table.
tags = {}
---[[ dang.ghs.com screen layout
s = 1
tags[s] = awful.tag(names[1], s, layouts[1])
-- Set default settings: 3 colums, floating layout
for i, t in ipairs(tags[s]) do
	awful.tag.setmwfact(0.3333333, tags[s][i])
	awful.tag.setncol(3, tags[s][i])
end
-- Fix tags with non-default layout
t = 1
awful.layout.set(layouts[1], tags[s][t])
t = 2
awful.layout.set(layouts[1], tags[s][t])
t = 3
awful.layout.set(layouts[1], tags[s][t])
t = 9
awful.layout.set(layouts[1], tags[s][t])
awful.tag.setmwfact(0.8, tags[s][t])
t = 10
awful.layout.set(layouts[1], tags[s][t])
t = 11
awful.layout.set(layouts[1], tags[s][t])
t = 13
awful.layout.set(layouts[8], tags[s][t])
t = 14
awful.layout.set(layouts[8], tags[s][t])
t = 15
awful.layout.set(layouts[8], tags[s][t])

if screen.count() == 2 then
	s = 2
	tags[s] = awful.tag(names[2], s, layouts[2])
	for i, t in ipairs(tags[s]) do
		awful.tag.setmwfact(0.3333333, tags[s][i])
		awful.tag.setncol(3, tags[s][i])
	end
end

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
                                    { "open backup terminal", backup_terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
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
                     awful.button({ }, 1, function (c)
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
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
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
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ "Control", }, "Left", function() awful.tag.viewonly(dfg_pick_desktop("west")) end),
    awful.key({ "Control", }, "Right", function() awful.tag.viewonly(dfg_pick_desktop("east")) end),
    awful.key({ "Control", }, "Up", function() awful.tag.viewonly(dfg_pick_desktop("north")) end),
    awful.key({ "Control", }, "Down", function() awful.tag.viewonly(dfg_pick_desktop("south")) end),
    awful.key({ modkey, "Control", "Shift", }, "Left", function()
    		t = dfg_pick_desktop("west")
		awful.client.movetotag(t)
		awful.tag.viewonly(t)
	end),
    awful.key({ modkey, "Control", "Shift", }, "Right", function()
   		t = dfg_pick_desktop("east")
		awful.client.movetotag(t)
		awful.tag.viewonly(t)
	end),
    awful.key({ modkey, "Control", "Shift", }, "Up", function()
    		t = dfg_pick_desktop("north")
		awful.client.movetotag(t)
		awful.tag.viewonly(t)
	end),
    awful.key({ modkey, "Control", "Shift", }, "Down", function()
    		t = dfg_pick_desktop("south")
		awful.client.movetotag(t)
		awful.tag.viewonly(t)
	end),
    awful.key({ modkey, "Control", }, "n", function() awful.tag.viewonly(dfg_pick_desktop("west")) end),
    awful.key({ modkey, "Control", }, "i", function() awful.tag.viewonly(dfg_pick_desktop("east")) end),
    awful.key({ modkey, "Control", }, "u", function() awful.tag.viewonly(dfg_pick_desktop("north")) end),
    awful.key({ modkey, "Control", }, "e", function() awful.tag.viewonly(dfg_pick_desktop("south")) end),


    awful.key({ modkey,           }, "e",
        function ()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "u",
        function ()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "n",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "i",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Mod1" }, "n", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Mod1" }, "i", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, "Shift"   }, "u", awful.client.urgent.jumpto),
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
    awful.key({ modkey, "Shift"   }, "e", function () awful.util.spawn(email) end),
    awful.key({ modkey, "Shift"   }, "i", function () awful.util.spawn(im) end),
    awful.key({ modkey,           }, "c", function () awful.util.spawn(comics) end),
    awful.key({ modkey,           }, "m", function () awful.util.spawn(music) end),
    awful.key({ modkey, "Shift"   }, "r", function () awful.util.spawn(reader) end),
    awful.key({ modkey, "Shift"   }, "p", function () awful.util.spawn(pr0n) end),
    -- awful.key({ modkey,           }, "k", function () awful.util.spawn(bookmarks) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey, "Shift"   }, "j",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "k",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "j",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "k",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Shift"   }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey, "Mod1"    }, "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "Left",   function (c) c.maximized_horizontal = false end),
    awful.key({ modkey,           }, "Right",   function (c) c.maximized_horizontal = true end),
    awful.key({ modkey,           }, "Down",   function (c) c.maximized_vertical = false end),
    awful.key({ modkey,           }, "Up",   function (c) c.maximized_vertical = true end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
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
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "pinentry-gtk-2" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
      ---- Force uzbl to be on my browser page
     --{ rule = { class = "Uzbl-tabbed" },
       --properties = { tag = tags[1][14] } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
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

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}