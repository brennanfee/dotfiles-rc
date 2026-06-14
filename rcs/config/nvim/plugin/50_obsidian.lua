local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/epwalsh/obsidian.nvim",
  }

  require("obsidian").setup({
    workspaces = {
      {
        name = "personal",
        path = "~/profile/cloud/files/notes/brain",
        overrides = {
          notes_subsdir = "2-notes",
          daily_notes = {
            folder = "3-timeline/daily-notes",
            date_format = "%Y-%m-%d",
          },
          templates = {
            subdir = "4-resources/templates",
            date_format = "%Y-%m-%d",
            time_format = "%I:%M:%S %p",
          },
        },
      },
    },
    completion = {
      nvim_cmp = false,
    },
    follow_url_function = function(url)
      -- Open the URL in the default web browser
      vim.fn.jobstart({ "xdg-open", url })
    end,
  })
end)

