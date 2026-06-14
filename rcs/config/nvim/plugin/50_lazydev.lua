local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/folke/lazydev.nvim",
  }

  require("lazydev").setup({
    library = {
       -- See the configuration section for more details
       -- Load luvit types when the `vim.uv` word is found
       { path = "${3rd}/luv/library", words = { "vim%.uv" } },
     },
  })
end)

