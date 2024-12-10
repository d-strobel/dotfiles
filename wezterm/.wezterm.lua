-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Wayland
config.enable_wayland = true

-- Font
config.font = wezterm.font 'DroidSansM Nerd Font'

-- Color scheme
-- config.color_scheme = 'catppuccin-mocha'

-- Keymaps
config.disable_default_key_bindings = true
config.keys = {
  {
    key = '+',
    mods = 'CTRL',
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = '-',
    mods = 'CTRL',
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = '0',
    mods = 'CTRL',
    action = wezterm.action.ResetFontSize,
  },
  {
    key = 'c',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CopyTo('Clipboard'),
  },
  {
    key = 'v',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.PasteFrom('Clipboard'),
  },
}

-- Window decorations
config.enable_tab_bar = false
config.window_decorations = 'RESIZE'

-- Window padding
config.window_padding = {
  left = 10,
  right = 10,
  top = 5,
  bottom = 1,
}

-- Window opacity
config.window_background_opacity = 0.99

-- Color gradient black and grey
config.window_background_gradient = {
  orientation = 'Vertical',
  colors = {
    '#000000',
    '#191719',
  },
  interpolation = 'Linear',
  blend = 'Rgb',
}

-- Return the configuration to wezterm
return config
