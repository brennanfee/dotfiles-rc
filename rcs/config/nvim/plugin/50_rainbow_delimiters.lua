local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/HiPhish/rainbow-delimiters.nvim",
  }

  require("rainbow-delimiters.setup").setup({
    query = {
      [""] = "rainbow-delimiters",
      javascript = "rainbow-delimiters-react",
      lua = "rainbow-blocks",
      latex = "rainbow-blocks",
    },
  })
end)

