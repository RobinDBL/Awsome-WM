local awful = require('awful')
local gears = require('gears')
local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen,
      floating = false,
      maximized = false,
      above = false,
      below = false,
      ontop = false,
      sticky = false,
      maximized_horizontal = false,
      maximized_vertical = false
    }
  },
  {
    rule_any = {name = {'QuakeTerminal'}},
    properties = {skip_decoration = true}
  },
  -- Titlebars
  {
    rule_any = {type = {'dialog'}, class = {'Wicd-client.py', 'calendar.google.com'}},
    properties = {
      placement = awful.placement.centered,
      ontop = true,
      floating = true,
      drawBackdrop = true,
      shape = function()
        return function(cr, w, h)
          gears.shape.rounded_rect(cr, w, h, 8)
        end
      end,
      skip_decoration = true
    }
  },
  -- Set rules to open certain apps on certain screens and certain workspaces
  {
    rule = { class = "firefox" },
    properties = { tag = "1", screen = function()
      if screen.count() == 3 then
        return 3
      else if screen.count() == 2 then
        return 2
      else
        return 1
      end
      end
    end }
  },
  {
    rule ={ instance = "code" },
    properties = { tag = "2", screen = 1}
  },
  {
    rule = { class = "konsole" },
    properties = { tag = "3" }
  },
  {
    rule = { instance = "teams" },
    properties = { tag = "4", screen = 1},
  },
  {
    rule = { name = "Mail - Robin Deblauwe - Outlook" },
    properties = { tag = "4", screen = function()
    if screen.count() == 3 then
      return 2
    else if screen.count() == 2 then
      return 2
    else
      return 1
    end
    end
  end
  },
  },
  {
    rule = { name = "Rambox" },
    properties = { tag = "4", screen = function()
      if screen.count() == 3 then
        return 3
      else if screen.count() == 2 then
        return 2
      else
        return 1
      end
      end
    end},
  },
  {
    rule = { instance = "Nautilus" },
    properties = { tag = "5" }
  },
  {
    rule = { instance = "spotify" },
    properties = { tag = "6"},
  },
  {
    rule = { name = "Variety Preferences" },
    properties = { minimized = true, tag = "7" },
  },
  {	
    id = "teams_notification",
    rule_any = {
       name = { "Microsoft Teams Notification" },
     },	
    properties = {
       titlebars_enabled = false,
       floating = true,	
       focus = false,
       draw_backdrop = false,
       skip_decoration = true,
       skip_taskbar = true,
       ontop = true,
       sticky = true
    }
  },
}
