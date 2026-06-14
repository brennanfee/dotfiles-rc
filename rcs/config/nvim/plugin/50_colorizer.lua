local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/catgoose/nvim-colorizer.lua",
  }

  require("colorizer").setup({
    options = {
      parsers = {
        css = true,
        hwb = true,
        lab = true,
        lch = true,
        tailwind = {
          enable = true,
          lsp = {
            enable = true,
          },
        },
        sass = {
          enable = true,
        },
        xterm = { enable = true },
        xcolor = { enable = true },
        hsluv = { enable = true },
        css_var_rgb = { enable = true },
      },
      display = {
        mode = "virtualtext",
      },
    },
  })
end)
