local M = {
  "folke/todo-comments.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  event = "VeryLazy",
}

function M.config()
  local colors = require("data.colors")

  require("todo-comments").setup({
    -- list of named colors where we try to extract the guifg from the
    -- list of highlight groups or use the hex color if hl not found as a fallback
    colors = {
      error = { "DiagnosticError", "ErrorMsg", colors.theme().red },
      warning = { "DiagnosticWarn", "WarningMsg", colors.theme().yellow },
      info = { "DiagnosticInfo", colors.theme().blue },
      hint = { "DiagnosticHint", colors.theme().green },
      default = { "Identifier", colors.theme().dark_purple },
      test = { "Identifier", colors.theme().purple },
    },
    search = {
      command = "rg",
      args = {
        "-L",
        "--color=never",
        "--vimgrep",
        "--smart-case",
      },
    },
  })
end

return M
