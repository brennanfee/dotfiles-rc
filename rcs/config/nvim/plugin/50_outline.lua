local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add({
    "https://github.com/hedyhli/outline.nvim",
  })

  require("outline").setup({})
end)
