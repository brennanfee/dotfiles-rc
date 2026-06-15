local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  }

  local lsps = require("tool_lists").mason_to_install

  require("mason").setup({
    pip = {
      upgrade_pip = true,
    },
    ui = {
      border = "rounded",
      -- TODO: Switch to icons array or Mini.icons
      icons = {
        package_pending = " ",
        package_installed = "󰄳 ",
        package_uninstalled = " 󰚌",
      },
    }
  })

  require("mason-lspconfig").setup()
  require("mason-tool-installer").setup({
    ensure_installed = lsps,
    run_on_start = true,
    auto_update = true,
    -- auto_update = false,
    integrations = {
      ["mason-lspconfig"] = true,
      ["mason-null-ls"] = false,
      ["mason-nvim-dap"] = false,
    },
  })

  vim.api.nvim_create_user_command("DoMasonUpdate", function()
    vim.cmd("MasonToolsUpdateSync")
    vim.cmd("MasonUpdate")
    vim.cmd("MasonToolsClean")
  end, {})
end)
