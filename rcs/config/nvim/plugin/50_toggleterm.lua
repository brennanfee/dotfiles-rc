local now_if_args = Config.now_if_args

now_if_args(function()
  -- Consider looking at https://github.com/nvzone/floatterm as a lighter weight alternative
  vim.pack.add {
    "https://github.com/akinsho/toggleterm.nvim",
  }

  local execs = {
    { nil, "<M-1>", "Horizontal Terminal", "horizontal", 0.3 },
    { nil, "<M-2>", "Vertical Terminal", "vertical", 0.4 },
    { nil, "<M-3>", "Float Terminal", "float", nil },
  }

  local function get_buf_size()
    local cbuf = vim.api.nvim_get_current_buf()
    local cwin = vim.api.nvim_get_current_win()
    local bufinfo = vim.tbl_filter(function(buf)
      return buf.bufnr == cbuf
    end, vim.fn.getwininfo(cwin))[1]
    if bufinfo == nil then
      return { width = -1, height = -1 }
    end
    return { width = bufinfo.width, height = bufinfo.height }
  end

  local function get_dynamic_terminal_size(direction, size)
    size = size
    if direction ~= "float" and tostring(size):find(".", 1, true) then
      size = math.min(size, 1.0)
      local buf_sizes = get_buf_size()
      local buf_size = direction == "horizontal" and buf_sizes.height or buf_sizes.width
      return buf_size * size
    else
      return size
    end
  end

  local exec_toggle = function(opts)
    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new({ cmd = opts.cmd, count = opts.count, direction = opts.direction })
    term:toggle(opts.size, opts.direction)
  end

  local add_exec = function(opts)
    local binary = opts.cmd:match("(%S+)")
    if vim.fn.executable(binary) ~= 1 then
      vim.notify("Skipping configuring executable " .. binary .. ". Please make sure it is installed properly.")
      return
    end

    vim.keymap.set({ "n", "t" }, opts.keymap, function()
      exec_toggle({
        cmd = opts.cmd,
        count = opts.count,
        direction = opts.direction,
        size = opts.size(),
      })
    end, { desc = opts.label, noremap = true, silent = true })
  end

  for i, exec in pairs(execs) do
    local direction = exec[4]

    local opts = {
      cmd = exec[1] or vim.o.shell,
      keymap = exec[2],
      label = exec[3],
      count = i + 100,
      direction = direction,
      size = function()
        return get_dynamic_terminal_size(direction, exec[5])
      end,
    }

    add_exec(opts)
  end

  require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    -- the degree by which to darken to terminal color,
    -- default: 1 for dark backgrounds, 3 for light
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = false,
    direction = "float",
    close_on_exit = true, -- close the terminal window when the process exits
    shell = nil, -- change the default shell
    float_opts = {
      border = "rounded",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
    winbar = {
      enabled = true,
      name_formatter = function(term) --  term: Terminal
        return term.count
      end,
    },
  })

  local opts = { noremap = true, silent = true }
  _G.set_terminal_keymaps = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<buffer><LeftRelease>", "<LeftRelease>i", opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-;>", [[<C-\\><C-n>]], opts)
    -- Better "window" navigation
    vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
  end

  Config.new_autocmd("TermOpen", nil, function()
    _G.set_terminal_keymaps()
  end, "Setup buffer keymaps for terminal")

  Config.new_autocmd("TermEnter", nil, function()
      _G.set_terminal_keymaps()
      vim.cmd("startinsert")
    end,
    "Open Terminal In Insert Mode"
  )
end)
