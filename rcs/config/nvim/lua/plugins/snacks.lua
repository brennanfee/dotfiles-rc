local M = {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
}

function M.config()
  local icons = require("data.icons")

  -- Rainbow delimiters integration
  local highlightGroups = { "SnacksIndent" }
  local rainbowInstalled, _ = pcall(require, "rainbow-delimiters")
  if rainbowInstalled then
    highlightGroups = {
      "RainbowDelimiterRed",
      "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
    }
  end

  -- get a fortune
  -- NOTE: requires the fortune-mod package to work
  local handle = io.popen("fortune -n 240 -s")
  local fortune
  if handle ~= nil then
    fortune = handle:read("*a")
    handle:close()
  else
    fortune = "You need to install the 'fortune-mod' package for this message to change."
  end

  -- get a text art banner
  handle = io.popen("colorscripts neovim random")
  local banner
  if handle ~= nil then
    banner = handle:read("*a")
    handle:close()
  else
    banner = "Unable to load colorscripts, check it is on the path."
  end

  local dashboard_settings = {
    enabled = true,
    sections = {
      {
        row = 1,
        { section = "header" },
      },
      {
        row = 2,
        { section = "keys", padding = 1, gap = 1 },
        {
          pane = 2,
          {
            section = "terminal",
            cmd = "echo -e '" .. banner .. "'",
            height = 10,
            padding = 1,
          },
          { section = "startup", padding = 1 },
          { section = "projects", icon = " ", title = "Projects", padding = 1 },
        },
      },
      {
        row = 3,
        { title = "Quote", padding = 1 },
        { text = fortune, indent = 1, padding = 1 },
      },
    },
    preset = {
      pick = nil,
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
      -- Used by the `header` section
      header = [[

███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
    ]],
    },
  }

  local indent_settings = {
    enabled = true,
    indent = {
      char = icons.ui.LineMiddle,
      hl = highlightGroups,
      only_scope = true,
      only_current = true,
    },
    animate = {
      enabled = true,
    },
    scope = {
      char = icons.ui.LineMiddle,
      hl = highlightGroups,
      only_current = true,
    },
  }

  require("snacks").setup({
    animate = { enabeld = true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = dashboard_settings,
    debug = { enabled = false },
    explorer = { enabled = true },
    image = { enabled = true },
    indent = indent_settings,
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = {
      enabled = true,
      folds = {
        open = true,
      },
    },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        diagnostics = false,
        line_number = true,
        relative_number = true,
        signcolumn = "no",
        indent = false,
      },
    },
  })

  -- TODO: Make pcall
  local wk = require("which-key")
  wk.add({
    -- Scratch Buffer
    { "<leader>n", "<cmd>lua Snacks.scratch()<CR>", desc = "Scratch Notepad" },
    -- Navigation
    { "<leader>e", "<cmd>lua Snacks.explorer()<CR>", desc = "Explorer" },
    -- Buffers
    { "<leader>bd", "<cmd>lua Snacks.bufdelete()<cr>", desc = "Buffer delete" },
    {
      "<leader>ba", -- spellchecker:disable-line
      "<cmd>lua Snacks.bufdelete.all()<cr>",
      desc = "Buffer delete all",
    },
    { "<leader>bo", "<cmd>lua Snacks.bufdelete.other()<cr>", desc = "Buffer delete other" },
    { "<leader>bz", "<cmd>lua Snacks.zen()<cr>", desc = "Buffer toggle zen mode" },
    -- Diagnostics
    { "<leader>x", group = "Diagnostics" },
    { "<leader>xn", "<cmd>lua Snacks.notifier.show_history()<cr>", desc = "Notification Messages" },
    -- LazyGit
    { "<leader>gg", "<cmd>lua Snacks.lazygit()<cr>", desc = "Open LazyGit" },
  })

  -- LSP Progress notification
  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
      if not client or type(value) ~= "table" then
        return
      end
      local p = progress[client.id]

      for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
          p[i] = {
            token = ev.data.params.token,
            msg = ("[%3d%%] %s%s"):format(
              value.kind == "end" and 100 or value.percentage or 100,
              value.title or "",
              value.message and (" **%s**"):format(value.message) or ""
            ),
            done = value.kind == "end",
          }
          break
        end
      end

      local msg = {} ---@type string[]
      progress[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
      end, p)

      local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
          notif.icon = #progress[client.id] == 0 and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
    end,
  })
end

return M
