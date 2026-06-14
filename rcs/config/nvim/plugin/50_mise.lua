local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://plugins.ejri.dev/mise.nvim",
  }

  require("mise").setup({
    args = "env --json --quiet",
    initial_path = vim.env.PATH_SYSTEM_AUGMENTED,
  })
end)

