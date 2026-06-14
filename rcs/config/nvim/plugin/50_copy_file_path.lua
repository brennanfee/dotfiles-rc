local now_if_args = Config.now_if_args

now_if_args(function()
  vim.pack.add {
    "https://github.com/h3pei/copy-file-path.nvim",
  }

  vim.api.nvim_create_user_command("CopyDirectoryPath", function()
    -- Get the path
    local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.:h")
    -- Copy it to the clipboard
    vim.fn.setreg("+", path)
    -- Print out that we copied it
    vim.api.nvim_echo({ { "Copied: " .. path } }, false, {})
  end, { nargs = 0, force = true, desc = "Copy relative path without filename to the clipboard" })

  vim.api.nvim_create_user_command("CopyDirectoryPathWithSeparator", function()
    local path_separator = "/"
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
    if is_windows == true then
      path_separator = "\\"
    end

    -- Get the path
    local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.:h") .. path_separator
    -- Copy it to the clipboard
    vim.fn.setreg("+", path)
    -- Print out that we copied it
    vim.api.nvim_echo({ { "Copied: " .. path } }, false, {})
  end, {
    nargs = 0,
    force = true,
    desc = "Copy relative path without filename to the clipboard, includes the trailing path separator",
  })

  vim.api.nvim_create_user_command("CopyAbsoluteDirectoryPath", function()
    -- Get the path
    local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")
    -- Copy it to the clipboard
    vim.fn.setreg("+", path)
    -- Print out that we copied it
    vim.api.nvim_echo({ { "Copied: " .. path } }, false, {})
  end, { nargs = 0, force = true, desc = "Copy absolute path without filename to the clipboard" })

  vim.api.nvim_create_user_command("CopyAbsoluteDirectoryPathWithSeparator", function()
    local path_separator = "/"
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
    if is_windows == true then
      path_separator = "\\"
    end

    -- Get the path
    local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h") .. path_separator
    -- Copy it to the clipboard
    vim.fn.setreg("+", path)
    -- Print out that we copied it
    vim.api.nvim_echo({ { "Copied: " .. path } }, false, {})
  end, {
    nargs = 0,
    force = true,
    desc = "Copy absolute path without filename to the clipboard, includes the trailing path separator",
  })
end)

