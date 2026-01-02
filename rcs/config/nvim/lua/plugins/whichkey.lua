local M = {
  "folke/which-key.nvim",
  dependencies = {
    {
      { "echasnovski/mini.nvim", version = false }, -- needs mini.icon
    },
  },
}

function M.config()
  require("mini.icons").setup()
  local wk = require("which-key")

  wk.setup({
    preset = "modern",
    notify = true,
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    show_help = true,
    show_keys = true,
    disable = {
      bt = {},
      ft = { "TelescopePrompt" },
    },
    win = {
      no_overlap = false,
      wo = {
        winblend = 25,
      },
    },
    debug = false,
  })

  -- Mappings
  wk.add({
    -- Direct Mappings
    { "<leader>q", "<cmd>confirm q<CR>", desc = "Quit" },
    { "<leader>v", "<cmd>vsplit<CR>", desc = "Split" },
    { "<leader>;", "<cmd>tabnew | terminal<CR>", desc = "Term" },
    -- Tab section
    { "<leader>a", group = "Tab" },
    { "<leader>aN", "<cmd>tabnew %<cr>", desc = "New Tab" },
    { "<leader>ah", "<cmd>-tabmove<cr>", desc = "Move Left" },
    { "<leader>al", "<cmd>+tabmove<cr>", desc = "Move Right" },
    { "<leader>an", "<cmd>$tabnew<cr>", desc = "New Empty Tab" },
    { "<leader>ao", "<cmd>tabonly<cr>", desc = "Only" },
    -- Buffer Section
    {
      "<leader>b",
      group = "Buffers",
      expand = function()
        return require("which-key.extras").expand.buf()
      end,
    },
    -- Key Mappings
    { "<leader>?", group = "Key Mappings" },
    {
      "<leader>?b",
      function()
        require("which-key").show({ global = false, loop = true })
      end,
      desc = "Buffer Local Keymaps",
    },
    {
      "<leader>?g",
      function()
        require("which-key").show({ global = true, loop = true })
      end,
      desc = "Global Keymaps",
    },
    -- Find Section
    { "<leader>f", group = "Find/File/Search" },
    { "<leader>fn", "<cmd>enew<cr>", desc = "New File" }, -- spellchecker:disable-line -- codespell:ignore enew
  })
end

return M
