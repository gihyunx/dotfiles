local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = { "/bin/fish" }

config.enable_wayland = false
config.enable_tab_bar = false

config.font = wezterm.font("Iosevka")
config.font_size = 16

config.default_cursor_style = "SteadyBlock"

config.disable_default_key_bindings = true

config.window_background_opacity = 0.95
config.window_decorations = "NONE"
config.window_close_confirmation = "NeverPrompt"
config.scrollback_lines = 3500
config.enable_scroll_bar = false
config.max_fps = 120
config.audible_bell = "Disabled"

config.colors = {
	foreground = "#c6c2c6",
	background = "#1a1111",
	cursor_bg = "#c6c2c6",
	cursor_fg = "#1a1111",
	cursor_border = "#c6c2c6",

	selection_fg = "#151414",
	selection_bg = "#7D8092",

	ansi = {
		"#1d0c1d", -- black
		"#f38ba8", -- red
		"#7dc3ae", -- green
		"#7D8092", -- yellow
		"#8F8898", -- blue
		"#AB9BA4", -- magenta
		"#ffb3b2", -- cyan
		"#c6c2c6", -- white
	},

	brights = {
		"#705c70", -- bright black
		"#f38ba8", -- bright red
		"#887C8D", -- bright green
		"#7D8092", -- bright yellow
		"#8F8898", -- bright blue
		"#AB9BA4", -- bright magenta
		"#ffb3b2", -- bright cyan
		"#c6c2c6", -- bright white
	},
}

return config
