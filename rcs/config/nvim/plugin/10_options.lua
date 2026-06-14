-- Leader key configuration
-- Not in keymaps, as these need to be set before loading plugins
vim.keymap.set({ "n", "v" }, "<Space>", "", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.termguicolors = true

-- Enable the experimental UI2
require("vim._core.ui2").enable()

-- Directories for backup files, swaps, and undo files
vim.o.backupdir = vim.fn.stdpath("cache") .. "/backup//"
vim.o.directory = vim.fn.stdpath("cache") .. "/swap//"
vim.o.undodir = vim.fn.stdpath("cache") .. "/undo//"

vim.o.swapfile = true
vim.o.autoread = true -- Auto-reload changes if changed outside neovim
vim.o.autowrite = false -- Do not auto-save

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- Disable Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Ensure editorconfig integration is turned on
vim.g.editorconfig = true
vim.g.awk_is_gawk = 1

vim.o.clipboard = "unnamedplus" -- Allows Neovim to access the system clipboard

vim.o.switchbuf = "usetab"

vim.o.fileencodings = "utf-8,ucs-bom,default,latin1" -- Prefer UTF-8 over all others
vim.o.bomb = false -- Do not use a byte order mark
vim.o.fileformats = "unix" -- Only work in "unixy" files with <CR>
vim.o.endofline = true
vim.o.endoffile = false
vim.o.fixendofline = true
vim.o.modeline = true

vim.o.conceallevel = 0 -- So that `` is visible in markdown files
vim.o.concealcursor = "" -- Do not hide cursorline in markup

-- Tweak performance
vim.o.timeout = true
vim.o.timeoutlen = 400 -- Time to wait for a mapped sequence to complete (in milliseconds)
vim.o.ttimeoutlen = 0 -- Key code timeout
vim.o.updatetime = 200 -- Faster completion
vim.g.cursorhold_updatetime = 300 -- Faster completion
vim.o.synmaxcol = 300 -- Syntax highlighting limit
vim.o.redrawtime = 10000 -- Increase neovim redraw tolerance
vim.o.maxmempattern = 20000 -- Increase max memory
vim.opt.diffopt:append("linematch:60") -- Improve diff display

-- Line numbers
vim.o.relativenumber = true
vim.o.numberwidth = 5 -- Set number column width {default 4}
vim.o.signcolumn = "yes:2" -- Always show sign column
vim.o.cursorlineopt = "screenline,number" -- Show cursor line per screen line

vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.shiftwidth = 2 -- The number of spaces inserted for each indentation
vim.o.tabstop = 2 -- How many columns a tab counts for
vim.o.softtabstop = 2
vim.o.shiftround = true -- Round indent
vim.o.autoindent = true -- Copy indent from current line
vim.o.breakindentopt = 'list:-1'  -- Add padding for lists (if 'wrap' is set)
vim.o.virtualedit = "block" -- Allow going past end of line in blockwise mode

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.formatoptions = 'crqnl1j'-- Improve comment editing

vim.o.showcmd = false

vim.o.showtabline = 1 -- Always show tabs
vim.o.laststatus = 3

vim.o.hlsearch = true
vim.o.selection = "inclusive" -- Include last char in selection
vim.o.gdefault = true
vim.o.inccommand = "split" -- Get a preview of replacements

vim.o.scrolloff = 5 -- Minimal number of screen lines to keep above and below the cursor
vim.o.sidescrolloff = 5 -- The minimal number of columns to scroll horizontally

vim.o.hidden = true
vim.o.visualbell = true

vim.o.foldenable = false -- Disable folding; enable with 'zi'
vim.o.foldmethod = "indent"
vim.o.splitkeep = "screen" -- Reduce scroll during window split

vim.o.list = true
vim.o.fillchars = 'eob: ,fold:╌'
vim.opt.listchars = { tab = " ", trail = "~", extends = "󰄾", precedes = "󰄽", nbsp = "␣", lead = "⋅" }

vim.o.showbreak = "++ "

vim.o.colorcolumn = "-20,+0"
vim.o.showmatch = true
vim.o.shortmess = "CFOSWaco" -- Disable some built-in completion messages

vim.o.pumborder = "single" -- Use border in popup menu
vim.o.pummaxwidth = 100 -- Make popup menu not too wide

-- Allows Neovim to send the Terminal details of the current window, instead of just getting 'v'
vim.o.title = true

vim.o.grepprg = "rg --hidden --vimgrep --smart-case --"

vim.o.spelllang = "en_us,en,medical"
vim.o.spelloptions = "camel"
vim.o.spell = false -- Off by default

-- Built-in completion
vim.o.complete        = '.,w,b,kspell,t,F,o'            -- Use less sources
vim.o.completeopt     = 'menuone,noselect,fuzzy,nosort' -- Use custom behavior
vim.o.completetimeout = 100                             -- Limit sources delay

-- vim.o.wildmenu = true -- tab completion
-- vim.o.wildmode = "longest:full,full" -- Complete longest common match, full completion list, cycle through with Tab
-- vim.o.wildignorecase = true -- When set case is ignored when completing file names and directories
-- vim.o.wildignore = [[
-- .git,.hg,.svn
-- *.aux,*.out,*.toc
-- *.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
-- *.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
-- *.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
-- *.mp3,*.oga,*.ogg,*.wav,*.flac
-- *.eot,*.otf,*.ttf,*.woff
-- *.doc,*.pdf,*.cbr,*.cbz
-- *.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
-- *.swp,.lock,.DS_Store,.directory,._*
-- */tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**"
-- ]]

vim.opt.whichwrap:append("<,>,[,]") -- Wrap movement between lines in edit mode with arrows
-- vim.opt.iskeyword:remove("_")
vim.opt.iskeyword:append("-") -- Add dash to the match keywords

vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neovim has built-in support for showing diagnostic messages. This configures
-- a more conservative display while still being useful.
-- See `:h vim.diagnostic` and `:h vim.diagnostic.config()`.
local diagnostic_config = {
  -- Show signs on top of any other sign, but only for warnings and errors
  signs = {
    priority = 9999,
    -- severity = { min = 'WARN', max = 'ERROR' },
    -- TODO: Use icons from the icon lists I have (or from mini.icons or devicons)
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "»",
    },
  },

  -- Show all diagnostics as underline (for their messages type `<Leader>ld`)
  underline = { severity = { min = 'HINT', max = 'ERROR' } },

  -- Show more details immediately for errors on the current line
  virtual_lines = false,
  virtual_text = {
    current_line = true,
    severity = { min = 'ERROR', max = 'ERROR' },
  },

  -- Don't update diagnostics when typing
  update_in_insert = false,
}

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
Config.later(function() vim.diagnostic.config(diagnostic_config) end)

-- Prepend Mise Shim directory and mason bin directories, if needed (note, order is important,
-- mason should override Mise
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
-- if not string.find(vim.env.PATH, "/mise/shims", 1, true) then
--   vim.env.PATH = vim.env.XDG_DATA_HOME .. "/mise/shims" .. (is_windows and ";" or ":") .. vim.env.PATH
-- end
if not string.find(vim.env.PATH, "/mason/bin", 1, true) then
  vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH
end

