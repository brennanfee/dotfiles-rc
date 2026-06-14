-- restore cursor to file position in previous editing session
local bufPos = function(args)
  local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
  local line_count = vim.api.nvim_buf_line_count(args.buf)
  if mark[1] > 0 and mark[1] <= line_count then
    vim.api.nvim_win_set_cursor(0, mark)
    -- defer centering slightly so it's applied after render
    vim.schedule(function()
      vim.cmd("normal! zz")
    end)
  end
end
Config.new_autocmd("BufReadPost", nil, bufPos, "Restore cursor position")

-- Don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
local f = function() vim.cmd("setlocal formatoptions-=o") end
Config.new_autocmd("FileType", nil, f, "Proper 'formatoptions'")

-- auto resize splits when the terminal's window is resized
local r = function() vim.cmd("wincmd =") end
Config.new_autocmd("VimResized", nil, r, "Resize splits on window resize")

-- syntax highlighting for dotenv files
local dotEnv = function()
  vim.bo.filetype = "dosini"
end
Config.new_autocmd("BufRead", { ".env", ".env.*" }, dotEnv, "Syntax highlighting for dotenv files")

local cursorEnable = function()
  vim.opt_local.cursorline = true
end
local cursorDisable = function()
  vim.opt_local.cursorline = false
end
Config.new_autocmd({ "WinEnter", "BufEnter" }, nil, cursorEnable, "Enable cursorline for active windows.")
Config.new_autocmd({ "WinLeave", "BufLeave" }, nil, cursorDisable, "Disable cursorline for inactive windows.")

