local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/b0o/schemastore.nvim",
  }

  local schemastore = require("schemastore")

  -- json
  vim.lsp.config("jsonls", {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  })

  -- yaml
  vim.lsp.config("yamlls", {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = schemastore.yaml.schemas(),
    },
  })
end)

