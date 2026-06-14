-- TODO: Improve by having the color just be values hanging off this object, but initialize those colors
-- from the current colorscheme.  Need to make generic so it can be used with any color scheme.
local M = {}

M.theme = function()
  local scheme = vim.g.colorscheme
  -- vim.fn.system("notify-send color: " .. scheme)
  local themeColors
  if scheme == "catppuccin" then
    themeColors = require("catppuccin.palettes").get_palette("mocha")
  elseif scheme == "oncedark" then
    themeColors = require("oncedark.helpers").get_colors()
  elseif scheme == "onedark" then
    themeColors = require("onedark.colors")
  elseif scheme == "onedarkpro" then
    themeColors = require("onedarkpro.helpers").get_colors()
  else
    -- These should match the default Neovim theme
    themeColors = {
      black = "#0e1013",
      bg0 = "#1f2329",
      bg1 = "#282c34",
      bg2 = "#30363f",
      bg3 = "#323641",
      bg_d = "#181b20",
      bg_blue = "#61afef",
      bg_yellow = "#e8c88c",
      fg = "#a0a8b7",
      purple = "#bf68d9",
      green = "#8ebd6b",
      orange = "#cc9057",
      blue = "#4fa6ed",
      yellow = "#e2b86b",
      cyan = "#48b0bd",
      red = "#e55561",
      grey = "#535965",
      light_grey = "#7a818e",
      dark_cyan = "#266269",
      dark_red = "#8b3434",
      dark_yellow = "#835d1a",
      dark_purple = "#7e3992",
      diff_add = "#272e23",
      diff_delete = "#2d2223",
      diff_change = "#172a3a",
      diff_text = "#274964",
    }
  end

  return themeColors
end

return M
