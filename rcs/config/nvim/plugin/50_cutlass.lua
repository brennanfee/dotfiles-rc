local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/gbprod/cutlass.nvim",
  }

  require("cutlass").setup({
    cut_key = "m",
    exclude = { "ns", "nS" },
    registers = {
      select = "s",
      delete = "d",
      change = "c",
    },
  })

end)
