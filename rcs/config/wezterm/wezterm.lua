-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Fonts
local function get_font_size()
  local handle = assert(io.popen("hostnamectl chassis", "r"))
  local output = assert(handle:read("*a"))
  handle:close()
  output = output:gsub("[\r\n]+$", "")

  if output == "laptop" then
    return 16.0
  else
    return 12.0
  end
end

config.font = wezterm.font("JetBrains Mono")
config.font_size = get_font_size()
config.warn_about_missing_glyphs = false
config.adjust_window_size_when_changing_font_size = false
config.freetype_interpreter_version = 40
config.freetype_load_target = "Normal"

config.bold_brightens_ansi_colors = false
config.use_cap_height_to_scale_fallback_fonts = true
config.strikethrough_position = "125%"
config.underline_thickness = "1px"

-- Color Scheme And Appearance
local fix_mocha_brights = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
fix_mocha_brights.brights = {
  -- "#45475a",
  "#585b70",
  "#eba0ac",
  "#94e2d5",
  "#fab387",
  "#89dceb",
  "#b4befe",
  "#cba6f7",
  "#f5e0dc",
  -- "#a6adc8",
}

local fix_latte_brights = wezterm.color.get_builtin_schemes()["Catppuccin Latte"]
fix_latte_brights.brights = {
  -- "#6c6f85",
  "#6c6f85",
  "#eba0ac",
  "#94e2d5",
  "#fab387",
  "#89dceb",
  "#b4befe",
  "#cba6f7",
  "#bcc0cc",
  -- "#bcc0cc",
}

config.color_schemes = {
  ["Catppuccin Mocha-Extended"] = fix_mocha_brights,
  ["Catppuccin Latte-Extended"] = fix_latte_brights,
}

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha-Extended"
  else
    return "Catppuccin Latte-Extended"
  end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.force_reverse_video_cursor = true
config.window_padding = { left = 10, right = 10, top = 10, bottom = 5 }

-- Bell
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 150,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 150,
}

-- Initial state
config.initial_rows = 42 -- Leaves a few lines of screen space above/below the window
config.initial_cols = 160 -- Wide enough for 100 Neovim columns plus "extra" for tree view
config.default_prog = { "/bin/bash" }

-- Turn off the tab bar, as I use tmux
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- Updates
config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400 -- Every 24 hours

-- Mouse Settings
config.swallow_mouse_click_on_pane_focus = true
config.swallow_mouse_click_on_window_focus = true

-- Don't prompt when closing the window
config.window_close_confirmation = "NeverPrompt"

-- finally, return the configuration to wezterm
return config
