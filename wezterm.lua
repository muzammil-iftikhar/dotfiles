-- Place this file at C:\Users\muzam\.config\wezterm
local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Dracula+' --tlh (terminal.sexy), NightLion v1, Nocturnal Winter, One Dark (Gogh), Orangish (terminal.sexy), Darcula (base16), Dark Ocean (terminal.sexy), Dark Violet (base16), Dark Pastel, Shaman, SleepyHollow, Synth Midnight Terminal Dark (base16)
config.font = wezterm.font ('DankMono Nerd Font Mono',{weight='Regular'}) --FiraCode Nerd Font, UbuntuMono Nerd Font, SauceCodePro Nerd Font
config.font_size = 11
config.line_height = 0.9
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.audible_bell = 'Disabled'
config.cursor_blink_rate = 500
config.default_domain = 'WSL:Ubuntu-22.04'
-- config.enable_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "TITLE | RESIZE"
config.window_close_confirmation = 'NeverPrompt'
config.use_fancy_tab_bar = true
config.force_reverse_video_cursor = true
-- config.window_background_image="C:\\Users\\muzam\\Downloads\\pic1.jpg"
-- config.window_background_image_hsb = {
--     -- Darken the background image by reducing it to 1/3rd
--     brightness = 0.1,
--     -- You can adjust the hue by scaling its value.
--     -- a multiplier of 1.0 leaves the value unchanged.
--     hue = 0.1,
--     -- You can adjust the saturation also.
--     saturation = 0.9,
-- }

return config