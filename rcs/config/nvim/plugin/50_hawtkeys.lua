local now_if_args = Config.now_if_args

now_if_args(function()
  -- Description: hawtkeys.nvim is a nvim plugin for finding and suggesting memorable and easy-to-press keys for your
  -- nvim shortcuts. It takes into consideration keyboard layout, easy-to-press combinations and memorable phrases, and
  -- excludes already mapped combinations to provide you with suggested keys for your commands.
  -- Commands -> :Hawtkeys, :HawtkeysAll, :HawtkeysDupes

  vim.pack.add {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/tris203/hawtkeys.nvim",
  }

  require("hawtkeys").setup({})

  -- Key Mappings
  vim.keymap.set("n", "<leader>?a", "<cmd>HawtkeysAll<cr>", { desc = "Show All Keymaps" })
  vim.keymap.set("n", "<leader>?s", "<cmd>Hawtkeys<cr>", { desc = "Search Keymaps" })
  vim.keymap.set("n", "<leader>?d", "<cmd>HawtkeysDupes<cr>", { desc = "Check For Duplicate Keymaps" })
end)

