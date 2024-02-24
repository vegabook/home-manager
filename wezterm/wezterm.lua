local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'Iosevka Nerd Font'
config.font_size = 17.0 

config.enable_tab_bar = false
config.color_scheme = 'Github'
config.window_close_confirmation = 'NeverPrompt'
config.window_background_gradient = {
  colors = { 'hotpink', 'gold' },
  orientation = {
    Radial = {
      -- Specifies the x coordinate of the center of the circle,
      -- in the range 0.0 through 1.0.  The default is 0.5 which
      -- is centered in the X dimension.
      cx = 0.75,

      -- Specifies the y coordinate of the center of the circle,
      -- in the range 0.0 through 1.0.  The default is 0.5 which
      -- is centered in the Y dimension.
      cy = 0.75,

      -- Specifies the radius of the notional circle.
      -- The default is 0.5, which combined with the default cx
      -- and cy values places the circle in the center of the
      -- window, with the edges touching the window edges.
      -- Values larger than 1 are possible.
      radius = 1.25,
    },
  },
}

-- more examples here for communicating with wezterm to change in place
-- https://wezfurlong.org/wezterm/config/lua/window/set_config_overrides.html
-- https://wezfurlong.org/wezterm/recipes/passing-data.html#user-vars

wezterm.on('toggle-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.5
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

config.keys = {
  {
    key = 'B',
    mods = 'CTRL',
    action = wezterm.action.EmitEvent 'toggle-opacity',
  },
}

return config

