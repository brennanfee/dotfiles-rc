-- I put both Conform and Vim-Lint together because they are serving an overlapping purpose (with LSP).
local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add({
    "https://github.com/stevearc/conform.nvim.git",
    "https://codeberg.org/mfussenegger/nvim-lint.git",
  })

  -- Conform

  require("conform").setup({
    formatters_by_ft = {
      -- markdown = { "flowmark" },
      markdown = { "rumdl" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    notify_no_formatters = true,
    -- formatters = {
    --   flowmark = {
    --     command = "flowmark-rs",
    --     args = { "-" },
    --     stdin = true,
    --   },
    -- },
  })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  -- Now, vim-lint
  require("lint").linters.cvslint = {
    cmd = "cvslint",
    stdin = false,
    append_fname = true,
    stream = "both",
    ignore_exitcode = true,
    parser = require("lint.parser").from_pattern(
      -- Matches: Record #12 has error: wrong number of fields
      [[Record #(%d+) has error: (.*)]],
      {
        lnum = 1, -- Group 1 is the line number
        col = 1, -- Default column to 1 since "csvlint" only gives the row number
        message = 2, -- Group 2 is the error message
      },
      nil,
      {
        ["source"] = "csvlint",
        ["severity"] = vim.diagnostic.severity.ERROR,
      }
    ),
  }

  require("lint").linters_by_ft = {
    csv = { "csvlint" },
    gitcommit = { "gitlint" },
    -- markdown = { "markdownlint-cli2" },
    markdown = { "rumdl" },
    ["*"] = { "codespell" },
  }

  local try_lint = function()
    require("lint").try_lint()
  end
  Config.new_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, nil, try_lint, "Linting")
end)
