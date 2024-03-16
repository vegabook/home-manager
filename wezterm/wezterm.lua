local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'Iosevka Nerd Font'
config.font_size = 17.0 

config.enable_tab_bar = false
config.color_scheme = 'Github'
config.window_close_confirmation = 'NeverPrompt'
-- Define the list of colors
local colors = {
    "AliceBlue", "AntiqueWhite", "Aqua", "Aquamarine", "Azure", "Beige", "Bisque", "Black", "BlanchedAlmond", "Blue", "BlueViolet",
    "Brown", "BurlyWood", "CadetBlue", "Chartreuse", "Chocolate", "Coral", "CornflowerBlue", "Cornsilk", "Crimson", "Cyan",
    "DarkBlue", "DarkCyan", "DarkGoldenrod", "DarkGray", "DarkGreen", "DarkGrey", "DarkKhaki", "DarkMagenta", "DarkOliveGreen",
    "DarkOrange", "DarkOrchid", "DarkRed", "DarkSalmon", "DarkSeaGreen", "DarkSlateBlue", "DarkSlateGray", "DarkSlateGrey",
    "DarkTurquoise", "DarkViolet", "DeepPink", "DeepSkyBlue", "DimGray", "DodgerBlue", "FireBrick", "FloralWhite", "ForestGreen",
    "Fuchsia", "Gainsboro", "GhostWhite", "Gold", "Goldenrod", "Gray", "Green", "GreenYellow", "Grey", "Honeydew", "HotPink",
    "IndianRed", "Indigo", "Ivory", "Khaki", "Lavender", "LavenderBlush", "LawnGreen", "LemonChiffon", "LightBlue", "LightCoral",
    "LightCyan", "LightGoldenrodYellow", "LightGray", "LightGreen", "LightGrey", "LightPink", "LightSalmon", "LightSeaGreen",
    "LightSkyBlue", "LightSlateGray", "LightSlateGrey", "LightSteelBlue", "LightYellow", "Lime", "LimeGreen", "Linen", "Magenta",
    "Maroon", "MediumAquamarine", "MediumBlue", "MediumOrchid", "MediumPurple", "MediumSeaGreen", "MediumSlateBlue",
    "MediumSpringGreen", "MediumTurquoise", "MediumVioletRed", "MidnightBlue", "MintCream", "MistyRose", "Moccasin", "NavajoWhite",
    "Navy", "OldLace", "Olive", "OliveDrab", "Orange", "OrangeRed", "Orchid", "PaleGoldenrod", "PaleGreen", "PaleTurquoise",
    "PaleVioletRed", "PapayaWhip", "PeachPuff", "Peru", "Pink", "Plum", "PowderBlue", "Purple", "Rebeccapurple", "Red", "RosyBrown",
    "RoyalBlue", "SaddleBrown", "Salmon", "SandyBrown", "SeaGreen", "Seashell", "Sienna", "Silver", "SkyBlue", "SlateBlue",
    "SlateGray", "SlateGrey", "Snow", "SpringGreen", "SteelBlue", "Tan", "Teal", "Thistle", "Tomato", "Turquoise", "Violet", "Wheat",
    "White", "WhiteSmoke", "Yellow", "YellowGreen"
}

-- Seed the random number generator
math.randomseed(os.time())

-- Function to select two unique random colors from the list
function chooseTwoColors()
    local index1 = math.random(#colors)
    local index2 = math.random(#colors)
    -- Ensure that index2 is different from index1
    while index2 == index1 do
        index2 = math.random(#colors)
    end
    return colors[index1], colors[index2]
end

-- Call the function and store the results
color1, color2 = chooseTwoColors()

config.window_background_gradient = {


  colors = { color1, color2 },
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
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT', 
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT', 
    action = wezterm.action.DisableDefaultAssignment,
  },

}

return config

