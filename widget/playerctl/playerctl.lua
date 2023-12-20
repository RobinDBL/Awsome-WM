local wibox = require("wibox")
local awful = require("awful")
local watch = require("awful.widget.watch")

local playerctl_widget_text_artist = wibox.widget.textbox()
local playerctl_widget_text_title = wibox.widget.textbox()
local playerctl_widget_play_icon = wibox.widget.imagebox()
local play_icon = "/usr/share/icons/Arc/actions/24/player_play.png"
local pause_icon = "/usr/share/icons/Arc/actions/24/player_pause.png"

local playerctl_widget = wibox.widget({
	wibox.widget({
		widget = playerctl_widget_text_artist,
		wibox.widget({
			widget = playerctl_widget_play_icon,
		}),
	}),
	playerctl_widget_text_title,
})

PLAYING = false

local update_metadata = function()
	-- Create a widget for music playerplayer
	awful.spawn.with_line_callback("playerctl --follow metadata --format ' {{artist}} <{{status}}> {{title}}'", {
		stdout = function(line)
			if string.match(line, "<Playing>") then
				PLAYING = true
			end
			playerctl_widget_text_artist:set_text(line:gsub("<Playing>", "<>"):gsub("<.+>", "<>"))
			local i, j = string.find(line, "<>")
			playerctl_widget_text_artist:set_text(string.sub(line, i, j))
			playerctl_widget_text_title:set_text(string.sub(line, j))
			playerctl_widget_play_icon:set_image(play_icon or pause_icon)
		end,
	})
end

update_metadata()

playerctl_widget:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn("playerctl play-pause", false) -- left click
	elseif button == 4 then
		awful.spawn("playerctl next", false) -- scroll up
	elseif button == 5 then
		awful.spawn("playerctl previous", false) -- scroll down
	end
end)

return playerctl_widget
