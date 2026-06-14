local now = Config.now

now(function()
  vim.pack.add {
    "https://github.com/folke/snacks.nvim",
  }

  ------- Start: Indent Settings

  --TODO: Switch to Mini.icons
  local icons = require("icons")

  -- Rainbow delimiters integration
  local highlightGroups = { "SnacksIndent" }
  local rainbowInstalled, _ = pcall(require, "rainbow-delimiters")
  if rainbowInstalled then
    highlightGroups = {
      "RainbowDelimiterRed",
      "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
    }
  end

  local indent_settings = {
    enabled = true,
    indent = {
      char = icons.ui.LineMiddle,
      hl = highlightGroups,
      only_scope = true,
      only_current = true,
    },
    animate = {
      enabled = true,
    },
    scope = {
      char = icons.ui.LineMiddle,
      hl = highlightGroups,
      only_current = true,
    },
  }

  ------- End: Indent Settings

  require("snacks").setup({
    animate = { enabled = true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = { enabled = false },
    debug = { enabled = false },
    explorer = { enabled = true },
    image = { enabled = true },
    -- indent = { enabled = false },
    indent = indent_settings,
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = {
      enabled = true,
      folds = {
        open = true,
      },
    },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        diagnostics = false,
        line_number = true,
        relative_number = true,
        signcolumn = "no",
        indent = false,
      },
    },
  })

  -- vim.keymap.set(
  vim.keymap.set("n", "<leader>ee", function()
    require("snacks").explorer()
  end, { desc = "Toggle Explorer" })
end)
