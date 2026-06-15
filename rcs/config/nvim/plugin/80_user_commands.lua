-- These are custom user commands that can be called from command mode

vim.api.nvim_create_user_command("DoPackSync", function()
  vim.pack.update(nil, { target = 'lockfile' })
end, {})

vim.api.nvim_create_user_command("DoPackUpdate", function()
  vim.pack.update(nil, { force = true })
end, {})

vim.api.nvim_create_user_command("DoPackClean", function()
  for _, p in ipairs(vim.pack.get()) do
    if not p.active then
      vim.pack.del({ p.name })
    end
  end
end, {})
