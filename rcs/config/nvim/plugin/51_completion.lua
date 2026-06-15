local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    { src = "https://github.com/saghen/blink.cmp", version = "v1" },
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/rafamadriz/friendly-snippets",
  }

  require("luasnip.loaders.from_vscode").lazy_load()
  require("blink.cmp").setup({
    signature = { enabled = true },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      menu = {
        auto_show = true,
        draw = {
          treesitter = { "lsp" },
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
        },
      },
    },
    keymap = {
      ["<C-Space>"] = { "show", "hide" },
      ["<Tab>"] = { "accept", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-h>"] = { "snippet_forward", "fallback" },
      ["<C-l>"] = { "snippet_backward", "fallback" },
    },
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = {
        menu = {
          auto_show = false
        },
      },
    },
  })
end)

