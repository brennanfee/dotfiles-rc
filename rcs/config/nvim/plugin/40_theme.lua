---- Catppuccin
vim.pack.add {
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" }
}

require("catppuccin").setup({
  flavour = "mocha",
  background = {
    light = "latte",
    dark = "mocha",
  },
  term_colors = true,
  -- integrations
  default_integrations = false,
  integrations = {
    blink_cmp = {
      style = 'bordered',
    },
    cmp = false,
    gitsigns = true,
    mason = true,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    notify = false,
    rainbow_delimiters = true,
    snacks = {
      enabled = true,
      indent_scope_color = "",
    },
    which_key = false,
  },
})

---- Kanagawa
vim.pack.add {
  "https://github.com/rebelot/kanagawa.nvim",
}

require("kanagawa").setup({
  theme = "dragon",
  background = {
    dark = "dragon",
    light = "lotus",
  },
})

---- OneDarkPro
vim.pack.add {
  "https://github.com/olimorris/onedarkpro.nvim",
}

require("onedarkpro").setup({
  options = {
    cursorline = true,
  },
  styles = {
    comments = "italic",
    keywords = "bold,italic",
    constants = "underline",
  },
})

---- OnceDark
vim.pack.add {
  "https://github.com/brennanfee/oncedark.nvim",
}

require("oncedark").setup({
  options = {
    cursorline = true,
  },
  styles = {
    comments = "italic",
    keywords = "bold,italic",
    constants = "underline",
  },
})

---- Theme Selection
vim.o.background = "dark"
vim.cmd.colorscheme "catppuccin-nvim"
-- vim.cmd.colorscheme "kanagawa"
-- vim.cmd.colorscheme "oncedarkpro"
-- vim.cmd.colorscheme "oncedark"

