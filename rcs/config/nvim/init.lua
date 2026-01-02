require("bootup.providers") -- codespell:ignore bootup
require("bootup.options") -- codespell:ignore bootup
require("bootup.options-gui") -- codespell:ignore bootup

-- And now, the plugin manager and plugins
require("bootup.lazy") -- codespell:ignore bootup

require("bootup.keymaps") -- codespell:ignore bootup
require("bootup.autocmds") -- codespell:ignore bootup

vim.o.background = "dark"
vim.cmd.colorscheme("catppuccin-mocha")
