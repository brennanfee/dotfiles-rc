local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/smjonas/inc-rename.nvim",
  }

  require("inc_rename").setup()

  vim.keymap.set("n", "<leader>rn", ":IncRename ")
end)

