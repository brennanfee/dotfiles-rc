local M = {
  "smoka7/hop.nvim",
  version = "*", -- optional but strongly recommended
  event = "VeryLazy",
}

function M.config()
  require("hop").setup()

  local hop = require("hop")
  local directions = require("hop.hint").HintDirection
  local positions = require("hop.hint").HintPosition

  -- Better f and t
  vim.keymap.set("n", "f", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
  end, { desc = "Search [F]or Letter In Line" })

  vim.keymap.set("n", "F", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
  end, { desc = "Search [F]or Letter In Line (Backwards)" })

  vim.keymap.set("n", "t", function()
    hop.hint_char1({
      direction = directions.AFTER_CURSOR,
      current_line_only = true,
      hint_offset = -1,
    })
  end, { desc = "Search Up [T]o Letter In Line" })

  vim.keymap.set("n", "T", function()
    hop.hint_char1({
      direction = directions.BEFORE_CURSOR,
      current_line_only = true,
      hint_offset = -1,
    })
  end, { desc = "Search Up [T]o Letter In Line (Backwards)" })

  -- Hop mappings
  vim.keymap.set("n", "gj", function()
    hop.hint_char2()
  end, { desc = "[G]o To [C]haracter Combination" })

  -- Mappings
  local wk = require("which-key")
  wk.add({
    { "<leader>h", group = "Hop" },
  })

  vim.keymap.set("n", "<leader>hc", function()
    hop.hint_char2()
  end, { desc = "[H]op To [C]haracter Combination" })

  vim.keymap.set("n", "<leader>hl", function()
    hop.hint_lines_skip_whitespace()
  end, { desc = "[H]op To [L]ine" }) -- codespell:ignore ine

  vim.keymap.set("n", "<leader>hs", function()
    hop.hint_lines()
  end, { desc = "[H]op To [L]ine [S]tart" }) -- codespell:ignore ine

  vim.keymap.set("n", "<leader>hp", function()
    hop.hint_patterns()
  end, { desc = "[H]op To [P]attern" })

  vim.keymap.set("n", "<leader>hw", function()
    hop.hint_words()
  end, { desc = "[H]op To [W]ord" })

  vim.keymap.set("n", "<leader>hj", function()
    hop.hint_words({ current_line_only = true })
  end, { desc = "[J]ump To Word In Line" })

  vim.keymap.set("n", "<leader>hk", function()
    hop.hint_words({ current_line_only = true, hint_position = positions.END })
  end, { desc = "[J]ump To Word In Line (End Of Word)" })
end

return M
