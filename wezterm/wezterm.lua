local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'Iosevka NF'


config.font_size = 17.0 

config.enable_tab_bar = false
config.color_scheme = 'Github'
config.window_close_confirmation = 'NeverPrompt'
config.front_end = 'WebGpu'
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


-- The set of schemes that we like and want to put in our rotation
local schemes = {}
for name, scheme in pairs(wezterm.color.get_builtin_schemes()) do
  table.insert(schemes, name)
end


-- Seed the random number generator
math.randomseed(os.time())


-- more examples here for communicating with wezterm to change in place
-- https://wezfurlong.org/wezterm/config/lua/window/set_config_overrides.html
-- https://wezfurlong.org/wezterm/recipes/passing-data.html#user-vars

function chooseThreeColors()
    local index1 = math.random(#colors)
    local index2 = math.random(#colors)
    local index3 = math.random(#colors)
    -- Ensure that index2 is different from index1
    while index2 == index1 do
        index2 = math.random(#colors)
    end
    return colors[index1], colors[index2], colors[index3]
end


wezterm.on('change-radial-background', function(window, pane)
  local color1, color2, color3 = chooseThreeColors()
  local scheme = schemes[math.random(#schemes)]
  window:set_config_overrides {
    window_background_gradient = {
      colors = { color1, color2, color3 },
      orientation = {
        Radial = {
          cx = 0.75,
          cy = 0.75,
          radius = 1.1,
        },
      },
    },
    color_scheme = scheme,
  }
end)


config.keys = {
  {
    key = 'B',
    mods = 'CTRL',
    action = wezterm.action.EmitEvent 'change-radial-background',
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

