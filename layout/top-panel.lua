local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local TaskList = require("widget.task-list")
local TagList = require("widget.tag-list")
local gears = require("gears")
local clickable_container = require("widget.material.clickable-container")
local mat_icon_button = require("widget.material.icon-button")
local mat_icon = require("widget.material.icon")
local dpi = require("beautiful").xresources.apply_dpi
local icons = require("theme.icons")
local theme = require("theme")
-- https://github.com/streetturtle/awesome-wm-widgets
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
local todo_widget = require("awesome-wm-widgets.todo-widget.todo")
local docker_widget = require("awesome-wm-widgets.docker-widget.docker")
local apt_widget = require("awesome-wm-widgets.apt-widget.apt-widget")
local jira_widget = require("awesome-wm-widgets.jira-widget.jira")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

local player_widget = require("widget.playerctl.playerctl")

-- Titus - Horizontal Tray
local systray = wibox.widget.systray()
systray:set_horizontal(true)
systray:set_base_size(20)
systray.forced_height = 20
--systray:set_screen()

-- Clock / Calendar 24h format
local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 9">%H:%M</span>')
-- Clock / Calendar 12AM/PM fornat
--local textclock = wibox.widget.textclock('<span font="Roboto Mono 12">%I:%M %p</span>')
-- textclock.forced_height = 36

-- Add a calendar (credits to kylekewley for the original code)
local month_calendar = awful.widget.calendar_popup.month({
	screen = s,
	start_sunday = false,
	week_numbers = false,
})
month_calendar:attach(textclock, "tc")

local clock_widget = wibox.container.margin(textclock, dpi(13), dpi(13), dpi(9), dpi(8))

local add_button = mat_icon_button(mat_icon(icons.plus, dpi(24)))
add_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
	awful.spawn(awful.screen.focused().selected_tag.defaultApp, {
		tag = _G.mouse.screen.selected_tag,
		placement = awful.placement.bottom_right,
	})
end)))

-- Create an imagebox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
local LayoutBox = function(s)
	local layoutBox = clickable_container(awful.widget.layoutbox(s))
	layoutBox:buttons(awful.util.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	return layoutBox
end

local TopPanel = function(s)
	local panel = wibox({
		ontop = false,
		screen = s,
		height = dpi(32),
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y,
		stretch = false,
		bg = beautiful.background.hue_800,
		fg = beautiful.fg_normal,
		struts = {
			top = dpi(32),
		},
	})

	panel:struts({
		top = dpi(32),
	})

	panel:setup({
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			-- Create a taglist widget
			TagList(s),
			fg = beautiful.background.hue_900,
			bg = beautiful.background.hue_900,

			-- application list
			--TaskList(s),
			--add_button,
		},
		--wibox.container.place(nil, "center", "center", false, false, false, false, nil, nil, 0, false),
		{
			clock_widget,
			valign = "center",
			halign = "center",
			layout = wibox.container.place,
            --layout = wibox.layout.fixed.horizontal
		},
		{
			layout = wibox.layout.fixed.horizontal,
			player_widget{
    play_icon = '/usr/share/icons/Arc/actions/24/player_play.png',
    pause_icon = '/usr/share/icons/Arc/actions/24/player_pause.png',
    dim_when_paused = true,
    font = "Ubuntu Mono 9",
    dim_opacity = 0.5,
    max_length = -1,
    show_tooltip = true,
    bg = ""
      },
			-- spotify
			-- spotify_widget({
			-- 	font = "Ubuntu Mono 9",
			-- 	dim_when_paused = true,
			-- 	dim_opacity = 0.5,
			-- 	max_length = -1,
			-- 	show_tooltip = true,
			-- }),
			wibox.container.margin(systray, dpi(3), dpi(3), dpi(6), dpi(3)),
			-- List of updates
			--apt_widget(),
			-- jira widget
			jira_widget({
				host = "https://televic-healthcare.atlassian.net",
        -- Old jira.televic.com query
				-- query = 'jql=project=GENERAL AND sprint in openSprints() AND resolution = Unresolved AND ( assignee in (currentUser()) OR ( "reviewers" in (currentUser()))  ) ORDER BY updated DESC',
        -- New atlassian.net query
        query = 'jql=sprint in openSprints() AND ( assignee in (currentUser()) OR ( "reviewers" in (currentUser()))  ) AND status != Closed AND status != Done ORDER BY updated DESC'
				--query = 'jql=project=THCS_GENERAL'
			}),
			-- docker widget
			docker_widget(),
			cpu_widget(),
			-- todo widget
			todo_widget(),
			-- Volume widget
			volume_widget(),
			-- Battery widget
			battery_widget(),
			-- Layout box
			LayoutBox(s),
			-- Clock
		},
	})

	return panel
end

return TopPanel
