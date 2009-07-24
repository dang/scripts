-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- For layout stuff
--local tag = require("awful.tag")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
theme_path = "/usr/share/awesome/themes/default/theme"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/share/awesome/themes/sky/theme"

-- Actually load theme
beautiful.init(theme_path)

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
	if type(s.screen) ~= "number" then
		error("No screen")
	elseif type(s.tag) ~= "number" then
		error("No tag number")
	end

	t = tag(s.name or tostring(s.tag))
	t.screen = s.screen
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
-- Define tags table.
tags = {}
---[[ dang.ghs.com screen layout
-- Screen utility
s = 1
tags[s] = {}
-- Tag Email: evolution
t = 1
dfgtags{ screen = s, tag = t, name = "Email", mwfact = 0.33333333, layout=layouts[10] }
-- Tag Browser: 1 browser (big) 1 terminal
t = 2
dfgtags{ screen = s, tag = t, name = "Browser", mwfact = 0.66666667, layout=layouts[10] }
-- Tag IM: pidgin
t = 3
dfgtags{ screen = s, tag = t, name = "IM", mwfact = 0.8 }
-- Tag Debug1: float so debugger can do it's thing
t = 4
dfgtags{ screen = s, tag = t, name = "Debug1", mwfact = 0.8, layout=layouts[10] }
-- Tag Extra: empty
t = 5
dfgtags{ screen = s, tag = t, mwfact = 0.33333333, layout=layouts[10] }
-- Tag Extra: empty
t = 6
dfgtags{ screen = s, tag = t, mwfact = 0.33333333, layout=layouts[10] }
-- Tag  Debug2: float so debugger can do it's thing
t = 7
dfgtags{ screen = s, tag = t, name = "Debug2", mwfact = 0.8, layout=layouts[10] }
-- Tag Extra: empty
t = 8
dfgtags{ screen = s, tag = t, mwfact = 0.33333333, layout=layouts[10] }
-- Tag Extra: empty
t = 9
dfgtags{ screen = s, tag = t, mwfact = 0.33333333, layout=layouts[10] }
-- Set first tag as active
tags[s][1].selected = true
-- Screen development
s = 2
tags[s] = {}
-- Tag Utility: 3 xterms
t = 1
dfgtags{ screen = s, tag = t, name = "Utility", mwfact = 0.33333333, ncol = 3 }
-- Tag Dev1: 1 xterm 
t = 2
dfgtags{ screen = s, tag = t, name = "Dev1", mwfact = 0.6666667, layout=layouts[8] }
-- Tag Dev2: 1 xterm 
t = 3
dfgtags{ screen = s, tag = t, name = "Dev2", mwfact = 0.6666667, layout=layouts[8] }
-- Tag Dev3: 1 xterm 
t = 4
dfgtags{ screen = s, tag = t, name = "Dev3", mwfact = 0.6666667, layout=layouts[8] }
-- Tag Build1: 2 xterms, one big one small
t = 5
dfgtags{ screen = s, tag = t, name = "Build1", mwfact = 0.66666667 }
-- Tag Build2: 2 xterms, one big one small
t = 6
dfgtags{ screen = s, tag = t, name = "Build2", mwfact = 0.66666667 }
-- Tag Consoles: 1 big xterm, 4 small ones
t = 7
dfgtags{ screen = s, tag = t, name = "Consoles", layout=layouts[5] }
-- Tag Extra: empty
t = 8
dfgtags{ screen = s, tag = t, mwfact = 0.33333333 }
-- Tag Extra: empty
t = 9
dfgtags{ screen = s, tag = t, name = "Virtualization", mwfact = 0.8, layout=layouts[10] }
-- Set first tag as active
tags[s][1].selected = true
--]]
--[[ default screen layout
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag(tagnumber)
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
        awful.layout.set(layouts[1], tags[s][tagnumber])
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
--]]
-- }}}

-- {{{ Wibox
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", terminal }
                                      }
                            })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                      button({ modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
mytasklist = {}
mytasklist.buttons = { button({ }, 1, function (c)
                                          if not c:isvisible() then
                                              awful.tag.viewonly(c:tags()[1])
                                          end
                                          client.focus = c
                                          c:raise()
                                      end),
                       button({ }, 3, function () if instance then instance:hide() end instance = awful.menu.clients({ width=250 }) end),
                       button({ }, 4, function ()
                                          awful.client.focus.byidx(1)
                                          if client.focus then client.focus:raise() end
                                      end),
                       button({ }, 5, function ()
                                          awful.client.focus.byidx(-1)
                                          if client.focus then client.focus:raise() end
                                      end) }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = widget({ type = "textbox", align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
    mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                  return awful.widget.tasklist.label.currenttags(c, s)
                                              end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { mylauncher,
                           mytaglist[s],
                           mytasklist[s],
                           mypromptbox[s],
                           mytextbox,
                           mylayoutbox[s],
                           s == 1 and mysystray or nil }
    mywibox[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
root.buttons({
    button({ }, 3, function () mymainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

function northeast(screen, tagnum)
	if tagnum == 1 then
		return tagnum
	elseif tagnum == 2 then
		return tagnum
	elseif tagnum == 3 then
		return tagnum
	elseif tagnum == 4 then
		return tagnum
	elseif tagnum == 5 then
		return 1
	elseif tagnum == 6 then
		return 2
	elseif tagnum == 7 then
		return tagnum
	elseif tagnum == 8 then
		return 4
	else
		return 5
	end
end
function north(screen, tagnum)
	if tagnum == 1 then
		return tagnum
	elseif tagnum == 2 then
		return 1
	elseif tagnum == 3 then
		return 2
	elseif tagnum == 4 then
		return tagnum
	elseif tagnum == 5 then
		return 4
	elseif tagnum == 6 then
		return 5
	elseif tagnum == 7 then
		return tagnum
	elseif tagnum == 8 then
		return 7
	else
		return 8
	end
end
function northwest(screen, tagnum)
	if tagnum == 1 then
		return tagnum
	elseif tagnum == 2 then
		return 4
	elseif tagnum == 3 then
		return 5
	elseif tagnum == 4 then
		return tagnum
	elseif tagnum == 5 then
		return 7
	elseif tagnum == 6 then
		return 8
	elseif tagnum == 7 then
		return tagnum
	elseif tagnum == 8 then
		return tagnum
	else
		return tagnum
	end
end
function east(screen, tagnum)
	if tagnum == 1 then
		return tagnum
	elseif tagnum == 2 then
		return tagnum
	elseif tagnum == 3 then
		return tagnum
	elseif tagnum == 4 then
		return 1
	elseif tagnum == 5 then
		return 2
	elseif tagnum == 6 then
		return 3
	elseif tagnum == 7 then
		return 4
	elseif tagnum == 8 then
		return 5
	else
		return 6
	end
end
function west(screen, tagnum)
	if tagnum == 1 then
		return 4
	elseif tagnum == 2 then
		return 5
	elseif tagnum == 3 then
		return 6
	elseif tagnum == 4 then
		return 7
	elseif tagnum == 5 then
		return 8
	elseif tagnum == 6 then
		return 9
	elseif tagnum == 7 then
		return tagnum
	elseif tagnum == 8 then
		return tagnum
	else
		return tagnum
	end
end
function southeast(screen, tagnum)
	if tagnum == 1 then
		return tagnum
	elseif tagnum == 2 then
		return tagnum
	elseif tagnum == 3 then
		return tagnum
	elseif tagnum == 4 then
		return 2
	elseif tagnum == 5 then
		return 3
	elseif tagnum == 6 then
		return tagnum
	elseif tagnum == 7 then
		return 5
	elseif tagnum == 8 then
		return 6
	else
		return tagnum
	end
end
function south(screen, tagnum)
	if tagnum == 1 then
		return 2
	elseif tagnum == 2 then
		return 3
	elseif tagnum == 3 then
		return tagnum
	elseif tagnum == 4 then
		return 5
	elseif tagnum == 5 then
		return 6
	elseif tagnum == 6 then
		return tagnum
	elseif tagnum == 7 then
		return 8
	elseif tagnum == 8 then
		return 9
	else
		return tagnum
	end
end
function southwest(screen, tagnum)
	if tagnum == 1 then
		return 5
	elseif tagnum == 2 then
		return 6
	elseif tagnum == 3 then
		return tagnum
	elseif tagnum == 4 then
		return 8
	elseif tagnum == 5 then
		return 9
	elseif tagnum == 6 then
		return tagnum
	elseif tagnum == 7 then
		return tagnum
	elseif tagnum == 8 then
		return tagnum
	else
		return tagnum
	end
end
-- Directional desktop switching emulation
-- The 9 tags on each screen are laid out like this:
-- 1 4 7
-- 2 5 8
-- 3 6 9
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
globalkeys =
{
    key({ modkey,    }, "Escape", awful.tag.history.restore),
    key({ "Control", }, "Left", function() awful.tag.viewonly(dfg_pick_desktop("east")) end),
    key({ "Control", }, "Right", function() awful.tag.viewonly(dfg_pick_desktop("west")) end),
    key({ "Control", }, "Up", function() awful.tag.viewonly(dfg_pick_desktop("north")) end),
    key({ "Control", }, "Down", function() awful.tag.viewonly(dfg_pick_desktop("south")) end),
    key({ modkey, "Mod1", }, "h", function() awful.tag.viewonly(dfg_pick_desktop("east")) end),
    key({ modkey, "Mod1", }, "l", function() awful.tag.viewonly(dfg_pick_desktop("west")) end),
    key({ modkey, "Mod1", }, "k", function() awful.tag.viewonly(dfg_pick_desktop("north")) end),
    key({ modkey, "Mod1", }, "j", function() awful.tag.viewonly(dfg_pick_desktop("south")) end),


    key({ modkey,           }, "j",
        function ()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    key({ modkey,           }, "k",
        function ()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    key({ modkey,           }, "h",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    key({ modkey,           }, "l",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    key({ modkey, "Shift"   }, "h", function () awful.client.swap.byidx(  1) end),
    key({ modkey, "Shift"   }, "l", function () awful.client.swap.byidx( -1) end),
    key({ modkey, "Control" }, "h", function () awful.screen.focus( 1)       end),
    key({ modkey, "Control" }, "l", function () awful.screen.focus(-1)       end),
    key({ modkey,           }, "u", awful.client.urgent.jumpto),
    key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    key({ modkey,           }, "b", function () awful.util.spawn(browser) end),
    key({ modkey,           }, "e", function () awful.util.spawn(email) end),
    key({ modkey,           }, "i", function () awful.util.spawn(im) end),
    key({ modkey, "Control" }, "r", awesome.restart),
    key({ modkey, "Shift"   }, "q", awesome.quit),

    key({ modkey, "Shift"   }, "j",     function () awful.tag.incnmaster( 1)      end),
    key({ modkey, "Shift"   }, "k",     function () awful.tag.incnmaster(-1)      end),
    key({ modkey, "Control" }, "j",     function () awful.tag.incncol( 1)         end),
    key({ modkey, "Control" }, "k",     function () awful.tag.incncol(-1)         end),
    key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    key({ modkey }, "F1",
        function ()
            awful.prompt.run({ prompt = "Run: " },
            mypromptbox[mouse.screen],
            awful.util.spawn, awful.completion.bash,
            awful.util.getdir("cache") .. "/history")
        end),

    key({ modkey }, "F4",
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen],
            awful.util.eval, awful.prompt.bash,
            awful.util.getdir("cache") .. "/history_eval")
        end),
}

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys =
{
    key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    key({ modkey }, "t", awful.client.togglemarked),
    key({ modkey,}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    key({ modkey,           }, "Left",   function (c) c.maximized_horizontal = false end),
    key({ modkey,           }, "Right",   function (c) c.maximized_horizontal = true end),
    key({ modkey,           }, "Down",   function (c) c.maximized_vertical = false end),
    key({ modkey,           }, "Up",   function (c) c.maximized_vertical = true end),

}

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    table.insert(globalkeys,
        key({ modkey }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control" }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    tags[screen][i].selected = not tags[screen][i].selected
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.movetotag(tags[client.focus.screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control", "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.toggletag(tags[client.focus.screen][i])
                end
            end))
end


for i = 1, keynumber do
    table.insert(globalkeys, key({ modkey, "Shift" }, "F" .. i,
                 function ()
                     local screen = mouse.screen
                     if tags[screen][i] then
                         for k, c in pairs(awful.client.getmarked()) do
                             awful.client.movetotag(tags[screen][i], c)
                         end
                     end
                 end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end

    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] then
        awful.client.floating.set(c, floatapps[inst])
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c

    -- Set key bindings
    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.size_hints_honor = false
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Hook called every minute
awful.hooks.timer.register(60, function ()
    mytextbox.text = os.date(" %a %b %d, %H:%M ")
end)
-- }}}
