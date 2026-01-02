-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Fonts
config.font = wezterm.font_with_fallback({
  {
    family = "JetBrains Mono",
    weight = "Regular",
    assume_emoji_presentation = false,
  },
  { family = "Symbols Nerd Font" },
  { family = "Noto Color Emoji" },
})
config.font_size = 18.0
config.warn_about_missing_glyphs = false
config.adjust_window_size_when_changing_font_size = false
config.freetype_interpreter_version = 40
config.freetype_load_target = "Light"

config.bold_brightens_ansi_colors = "No"
config.use_cap_height_to_scale_fallback_fonts = true
config.strikethrough_position = "125%"
config.underline_thickness = "2px"

config.font_rules = {
  {
    intensity = "Bold",
    italic = false,
    font = wezterm.font_with_fallback({
      { family = "JetBrains Mono", weight = "ExtraBold", italic = false },
      { family = "Symbols Nerd Font" },
      { family = "Noto Color Emoji" },
    }),
  },
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font_with_fallback({
      { family = "JetBrains Mono", weight = "ExtraBold", italic = true },
      { family = "Symbols Nerd Font" },
      { family = "Noto Color Emoji" },
    }),
  },
  {
    intensity = "Half",
    italic = false,
    font = wezterm.font_with_fallback({
      { family = "JetBrains Mono", weight = "Thin", italic = false },
      { family = "Symbols Nerd Font" },
      { family = "Noto Color Emoji" },
    }),
  },
  {
    intensity = "Half",
    italic = true,
    font = wezterm.font_with_fallback({
      { family = "JetBrains Mono", weight = "Thin", italic = true },
      { family = "Symbols Nerd Font" },
      { family = "Noto Color Emoji" },
    }),
  },
}

-- Color Scheme And Appearance
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 1.0
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
config.initial_rows = 36 -- Leaves a few lines of screen space above/below the window
config.initial_cols = 140 -- Wide enough for 100 Neovim columns plus 30 for tree view
-- config.default_prog = { wezterm.home_dir .. "/.dotfiles-rc/bash/assets/init-tmux.bash" }

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
