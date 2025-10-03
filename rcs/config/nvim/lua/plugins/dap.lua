local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",

    -- Installs the debug adapters for you
    -- "williamboman/mason.nvim",
    -- "jay-babu/mason-nvim-dap.nvim",

    -- Show debug values in virtual text
    "theHamsta/nvim-dap-virtual-text",

    -- Add other debuggers here
    -- "leoluz/nvim-dap-go",
    -- "mfussenegger/nvim-dap-python",
  },
  event = "VeryLazy",
}

function M.config()
  local dap = require("dap")
  local dapui = require("dapui")
  local tool_lists = require("data.tool-lists")

  -- require("mason-nvim-dap").setup({
  --   ensure_installed = tool_lists.mason_debug_adapters,

  --   automatic_installation = false,

  --   -- Makes a best effort to setup the various debuggers with
  --   -- reasonable debug configurations
  --   automatic_setup = true,

  --   -- You can provide additional configuration to the handlers,
  --   -- see mason-nvim-dap README for more information
  --   handlers = {},
  -- })

  -- Mappings
  local wk = require("which-key")
  wk.add({
    { "<leader>d", group = "Debug" },
    { "<F5>", "<cmd>require('dap').step_into<CR>", desc = "Step Into" },
    { "<F6>", "<cmd>require('dap').step_over<CR>", desc = "Step Over" },
    { "<F7>", "<cmd>require('dap').step_out<CR>", desc = "Step Out" },
    { "<F8>", "<cmd>require('dap').continue<CR>", desc = "Continue" },
    { "<leader>di", "<cmd>require('dap').step_into<CR>", desc = "Step Into" },
    { "<leader>do", "<cmd>require('dap').step_over<CR>", desc = "Step Over" },
    { "<leader>dt", "<cmd>require('dap').step_out<CR>", desc = "Step Out" },
    { "<leader>dc", "<cmd>require('dap').continue<CR>", desc = "Continue" },
    { "<leader>db", "<cmd>require('dap').toggle_breakpoint<CR>", desc = "Toggle Breakpoint" },
    {
      "<leader>dB",
      "<cmd>require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      desc = "Breakpoint (with condition)",
    },
  })

  -- Dap UI setup
  -- For more information, see |:help nvim-dap-ui|
  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
    controls = {
      icons = {
        pause = "⏸",
        play = "▶",
        step_into = "⏎",
        step_over = "⏭",
        step_out = "⏮",
        step_back = "b",
        run_last = "▶▶",
        terminate = "⏹",
      },
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = dapui.open
  dap.listeners.before.event_terminated["dapui_config"] = dapui.close
  dap.listeners.before.event_exited["dapui_config"] = dapui.close

  require("nvim-dap-virtual-text").setup()
  -- Install golang specific config
  -- require("dap-go").setup()

  -- require("dap-python").setup(vim.fn.stdpath("data") .. "mason/bin")
  -- require("dap-python").test_runner = "pytest"
end

return M
