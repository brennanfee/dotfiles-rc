local utils = require("utils")
vim.loader.enable()

-- Turn off the Perl, Ruby, and Node providers, we'll never use them
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

local python_path = utils.getSystemExe("python3")
if utils.isNotEmpty(python_path) then
  vim.g.python3_host_prog = python_path
  -- vim.g.loaded_python3_provider = 1
else
  -- Fall back to system python, which should always be there
  vim.g.python3_host_prog = "/usr/bin/python3"
  -- vim.g.loaded_python3_provider = 1
end
