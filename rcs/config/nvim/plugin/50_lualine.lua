local now = Config.now

now(function()
  vim.pack.add {
    "https://github.com/nvim-lualine/lualine.nvim",
  }

  -- Mode indicators with Nerd Font icons
  -- TODO: Convert to use mini.icons
  local function mode_icon()
    local mode = vim.fn.mode()
    local modes = {
      n = " \u{f121} NORMAL",
      i = " \u{f11c} INSERT",
      v = " \u{f0168} VISUAL",
      V = " \u{f0168} V-LINE",
      ["\22"] = " \u{f0168} V-BLOCK",
      c = " \u{f120} COMMAND",
      s = " \u{f0c5} SELECT",
      S = " \u{f0c5} S-LINE",
      ["\19"] = " \u{f0c5} S-BLOCK",
      R = " \u{f044} REPLACE",
      r = " \u{f044} REPLACE",
      ["!"] = " \u{f489} SHELL",
      t = " \u{f120} TERMINAL",
    }

    return modes[mode] or (" \u{f059} " .. mode)
  end

  require("lualine").setup({
    options = {
      -- component_separators = { left = '', right = ''},
      -- section_separators = { left = '', right = ''},
      -- component_separators = { left = '', right = '' },
      -- section_separators = { left = '', right = '' },
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
      ignore_focus = { "snacks_picker_list" },
      -- always_show_tabline = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = { { mode_icon }, },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { { "filename", path = 4, }, },
      lualine_x = { "filesize", { "encoding", show_bomb = true }, "fileformat", "filetype" },
      lualine_y = { { "lsp_status", ignore_lsp = { "efm", "harper_ls", "typos_lsp" }, }, },
      lualine_z = { "progress", "location" },
    },
    -- tabline = {
    --   lualine_a = { { 'buffers', mode = 4, use_mode_colors = true, }, },
    -- },
    extensions = { "quickfix", "man", "nvim-tree", "oil", "mason" },
  })

end)
