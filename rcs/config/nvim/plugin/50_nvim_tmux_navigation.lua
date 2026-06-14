local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/alexghergh/nvim-tmux-navigation",
  }

  require("nvim-tmux-navigation").setup({
    disable_when_zoomed = true,
    keybindings = {
      left = "<C-h>",
      down = "<C-j>",
      up = "<C-k>",
      right = "<C-l>",
      last_active = "<C-\\>",
      next = "<C-n>",
    },
  })
end)
