local awful = require('awful')
require('awful.autofocus')
local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey

local clientKeys =
  awful.util.table.join(
  awful.key(
    {modkey},
    'f',
    function(c)
      -- c.fullscreen = not c.fullscreen -- Fullscreen will cover the wibar on top
      c.maximized = not c.maximized -- maximized will not cover the wibar on top
      c:raise()
    end,
    {description = 'toggle maximized screen', group = 'client'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'f',
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = 'toggle fullscreen', group = 'client'}
  ),
  awful.key(
    {modkey},
    'q',
    function(c)
      c:kill()
    end,
    {description = 'close', group = 'client'}
  )
)

return clientKeys
