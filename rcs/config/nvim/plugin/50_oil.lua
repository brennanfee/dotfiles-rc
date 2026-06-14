local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/stevearc/oil.nvim",
  }

  require("oil").setup()

  vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
end)

