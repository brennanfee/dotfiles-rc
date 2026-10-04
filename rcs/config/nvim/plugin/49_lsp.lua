local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/creativenull/efmls-configs-nvim",
  })

  -- Configure Lua_ls
  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = {
            "?.lua",
            "?/init.lua",
          },
        },
        format = {
          enable = false, -- Disable built-in lua_ls formatting, using stylua instead
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            "$VIMRUNTIME",
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
  })

  local utils = require("utils")
  local lsps = require("tool_lists").lsp_servers
  local lsps_to_enable = {}

  for _, lsp in pairs(lsps) do
    if utils.isNotEmpty(lsp.lsp_name) then
      table.insert(lsps_to_enable, lsp.lsp_name)
    end
  end

  -- Enable from that list
  vim.lsp.enable(lsps_to_enable)
end)
