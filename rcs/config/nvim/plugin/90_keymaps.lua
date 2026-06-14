-- These are the global key mappings. Any plugin specific key mappings
-- should be found in the plugins setup scripts. This way those mappings
-- turn off when the plugin is disabled or removed.  These mappings also
-- run LAST and therefore override any others.

-- Helper functions
local map = function(mode, lhs, rhs, desc, opts)
  local options = { noremap = true, silent = true, desc = desc }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local map_leader = function(mode, suffix, rhs, desc, opts)
  map(mode, '<Leader>' .. suffix, rhs, desc, opts)
end

map({ "n", "x" }, "j", [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], "Move down", { expr = true }) -- Move down
map({ "n", "x" }, "k", [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], "Move up", { expr = true }) -- Move up
map({ "n", "v" }, "<Down>", [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], "Move down", { expr = true }) -- Move down
map({ "n", "v" }, "<Up>", [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], "Move up", { expr = true }) -- Move up

-- Paste linewise before/after current line
-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
map("n", "[p", '<Cmd>exe "iput! " . v:register<CR>', "Paste Above" )
map("n", "]p", '<Cmd>exe "iput "  . v:register<CR>', "Paste Below" )

-- Better movements to start and end of line
map({ "n", "o", "x" }, "<s-u>", "0", "Move to start of line")
map({ "n", "o", "x" }, "<s-h>", "^", "Move to start of line")
map({ "n", "o", "x" }, "<s-l>", "g_", "Move to end of line")

------ Normal Mode Mappings ------

-- Also resize with ctrl+shift+hjkl, respecting v:count
map('n', '<C-S-h>', '"<Cmd>vertical resize -" . v:count1 . "<CR>"', 'Decrease window width', { expr = true, replace_keycodes = false })
map('n', '<C-S-j>', '"<Cmd>resize -"          . v:count1 . "<CR>"', 'Decrease window height', { expr = true, replace_keycodes = false })
map('n', '<C-S-k>', '"<Cmd>resize +"          . v:count1 . "<CR>"', 'Increase window height', { expr = true, replace_keycodes = false })
map('n', '<C-S-l>', '"<Cmd>vertical resize +" . v:count1 . "<CR>"', 'Increase window width', { expr = true, replace_keycodes = false })

-- Keep centered while searching
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "g*", "g*zz")
map("n", "g#", "g#zz")

-- Add a space before and after the cursor
map("n", "]<Space>", "a<Space><Esc>h", "Add space after the cursor")
map("n", "[<Space>", "i<Space><Esc>l", "Add space before the cursor")

-- Spelling shortcuts
map("n", "zy", "1z=e", "Fix spelling with first word")

-- TODO: Convert to Lua
vim.cmd([[
  " :w!! to save a file as sudo when you forgot to open the file as sudo
  command WriteSudo w !sudo tee % > /dev/null
  cnoremap w!! WriteSudo
]])

-- Inspired by settings in NvChad
map("n", "<Esc>", ":noh <CR>", "Clear highlights")

map("n", "<C-c>", "<cmd> %y+ <CR>", "Copy whole file to clipboard")

------ Insert Mode Mappings ------
-- Press jk fast to exit insert mode
map("i", "jk", "<ESC>", "Quick exit insert mode")
-- (From NvChad)
-- remap C-K for Unicode "[C]haracter" entry
map("i", "<C-c>", "<C-k>", "Unicode [C]aracter")
-- Beginning and end of line, emacs like
map("i", "<C-b>", "<ESC>^i", "Go To Beginning Of Line")
map("i", "<C-e>", "<End>", "Go To End Of Line")
-- navigate within insert mode
map("i", "<C-h>", "<Left>", "Move Left")
map("i", "<C-j>", "<Right>", "Move Right")
map("i", "<C-k>", "<Down>", "Move Down")
map("i", "<C-l>", "<Up>", "Move Up")

------ Visual Mode Mappings ------
-- Stay in indent mode
map("v", "<", "<gv", "After outdent, stay in select mode")
map("v", ">", ">gv", "After indent, stay in select mode")

-- Move text up and down
map("v", "<M-j>", ":m .+1<CR>==", "Move text down")
map("v", "<M-k>", ":m .-2<CR>==", "Move test up")
map("v", "p", '"_dP',"Visual mode past")

------ Visual Block Mode Mappings ------
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<M-j>", ":move '>+1<CR>gv-gv", "Move text down")
map("x", "<M-k>", ":move '<-2<CR>gv-gv", "Move text up")
-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>') -- Don't copy replaced text

-- ### b is for 'Buffer'
local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

map_leader("n", "ba", "<Cmd>b#<CR>",                                 "Alternate")
map_leader("n", "bd", "<Cmd>lua MiniBufremove.delete()<CR>",         "Delete")
map_leader("n", "bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>",  "Delete!")
map_leader("n", "bs", new_scratch_buffer,                            "Scratch")
map_leader("n", "bw", "<Cmd>lua MiniBufremove.wipeout()<CR>",        "Wipeout")
map_leader("n", "bW", "<Cmd>lua MiniBufremove.wipeout(0, true)<CR>", "Wipeout!")

-- Add to mimic the rest of the buffer commands
map_leader("n", "bn", "<Cmd>bnext<CR>", "Next")
map_leader("n", "bp", "<Cmd>bprevious<CR>", "Previous")

-- ### c is for "copy"
-- TBD

-- ### e is for "explore/edit"
local edit_plugin_file = function(filename)
  return string.format('<Cmd>edit %s/plugin/%s<CR>', vim.fn.stdpath('config'), filename)
end
local explore_at_file = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>'
local explore_quickfix = function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and 'cclose' or 'copen')
end
local explore_locations = function()
  vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and 'lclose' or 'lopen')
end

map_leader("n", "ed", "<Cmd>lua MiniFiles.open()<CR>",          'Directory')
map_leader("n", "ef", explore_at_file,                          'File directory')
map_leader("n", "ei", "<Cmd>edit $MYVIMRC<CR>",                 'init.lua')
map_leader("n", "ek", edit_plugin_file("20_keymaps.lua"),       'Keymaps config')
map_leader("n", "em", edit_plugin_file("30_mini.lua"),          'MINI config')
map_leader("n", "en", "<Cmd>lua MiniNotify.show_history()<CR>", 'Notifications')
map_leader("n", "eo", edit_plugin_file("10_options.lua"),       'Options config')
map_leader("n", "ep", edit_plugin_file("40_plugins.lua"),       'Plugins config')
map_leader("n", "eq", explore_quickfix,                         'Quickfix list')
map_leader("n", "eQ", explore_locations,                        'Location list')

-- ### f is for "Fuzzy Find"

-- All these use 'mini.pick'. See `:h MiniPick-overview` for an overview.
local pick_added_hunks_buf = "<Cmd>Pick git_hunks path='%' scope='staged'<CR>"
local pick_workspace_symbols_live = "<Cmd>Pick lsp scope='workspace_symbol_live'<CR>"

map_leader("n", "f/", "<Cmd>Pick history scope='/'<CR>",            "'/' history")
map_leader("n", "f:", "<Cmd>Pick history scope=':'<CR>",            "':' history")
map_leader("n", "fa", "<Cmd>Pick git_hunks scope='staged'<CR>",     "Added hunks (all)")
map_leader("n", "fA", pick_added_hunks_buf,                         "Added hunks (buf)")
map_leader("n", "fb", "<Cmd>Pick buffers<CR>",                      "Buffers")
map_leader("n", "fc", "<Cmd>Pick git_commits<CR>",                  "Commits (all)")
map_leader("n", "fC", "<Cmd>Pick git_commits path='%'<CR>",         "Commits (buf)")
map_leader("n", "fd", "<Cmd>Pick diagnostic scope='all'<CR>",       "Diagnostic workspace")
map_leader("n", "fD", "<Cmd>Pick diagnostic scope='current'<CR>",   "Diagnostic buffer")
map_leader("n", "ff", "<Cmd>Pick files<CR>",                        "Files")
map_leader("n", "fg", "<Cmd>Pick grep_live<CR>",                    "Grep live")
map_leader("n", "fG", "<Cmd>Pick grep pattern='<cword>'<CR>",       "Grep current word")
map_leader("n", "fh", "<Cmd>Pick help<CR>",                         "Help tags")
map_leader("n", "fH", "<Cmd>Pick hl_groups<CR>",                    "Highlight groups")
map_leader("n", "fl", "<Cmd>Pick buf_lines scope='all'<CR>",        "Lines (all)")
map_leader("n", "fL", "<Cmd>Pick buf_lines scope='current'<CR>",    "Lines (buf)")
map_leader("n", "fm", "<Cmd>Pick git_hunks<CR>",                    "Modified hunks (all)")
map_leader("n", "fM", "<Cmd>Pick git_hunks path='%'<CR>",           "Modified hunks (buf)")
map_leader("n", "fr", "<Cmd>Pick resume<CR>",                       "Resume")
map_leader("n", "fR", "<Cmd>Pick lsp scope='references'<CR>",       "References (LSP)")
map_leader("n", "fs", pick_workspace_symbols_live,                  "Symbols workspace (live)")
map_leader("n", "fS", "<Cmd>Pick lsp scope='document_symbol'<CR>",  "Symbols document")
map_leader("n", "fv", "<Cmd>Pick visit_paths cwd=''<CR>",           "Visit paths (all)")
map_leader("n", "fV", "<Cmd>Pick visit_paths<CR>",                  "Visit paths (cwd)")

-- ### g is for "Git"
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. ' --follow -- %'

map_leader("n", "ga", "<Cmd>Git diff --cached<CR>",             "Added diff")
map_leader("n", "gA", "<Cmd>Git diff --cached -- %<CR>",        "Added diff buffer")
map_leader("n", "gc", "<Cmd>Git commit<CR>",                    "Commit")
map_leader("n", "gC", "<Cmd>Git commit --amend<CR>",            "Commit amend")
map_leader("n", "gd", "<Cmd>Git diff<CR>",                      "Diff")
map_leader("n", "gD", "<Cmd>Git diff -- %<CR>",                 "Diff buffer")
map_leader("n", "gl", "<Cmd>" .. git_log_cmd .. "<CR>",         "Log")
map_leader("n", "gL", "<Cmd>" .. git_log_buf_cmd .. "CR",     "Log buffer")
map_leader("n", "go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay")
map_leader("n", "gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>",  "Show at cursor")

map_leader("x", "gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at selection")

-- ### l is for "Language" and "LSP"
map_leader("n", "la", "<Cmd>lua vim.lsp.buf.code_action()<CR>",     "Actions")
map_leader("n", "ld", "<Cmd>lua vim.diagnostic.open_float()<CR>",   "Diagnostic popup")
map_leader("n", "lf", "<Cmd>lua require('conform').format()<CR>",   "Format")
map_leader("n", "li", "<Cmd>lua vim.lsp.buf.implementation()<CR>",  "Implementation")
map_leader("n", "lh", "<Cmd>lua vim.lsp.buf.hover()<CR>",           "Hover")
map_leader("n", "ll", "<Cmd>lua vim.lsp.codelens.run()<CR>",        "Lens")
map_leader("n", "lr", "<Cmd>lua vim.lsp.buf.rename()<CR>",          "Rename")
map_leader("n", "lR", "<Cmd>lua vim.lsp.buf.references()<CR>",      "References")
map_leader("n", "ls", "<Cmd>lua vim.lsp.buf.definition()<CR>",      "Source definition")
map_leader("n", "lt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition")

map_leader("x", "lf", "<Cmd>lua require('conform').format()<CR>", "Format selection")

-- ### "o" is for "Other"
map_leader("n", "or", "<Cmd>lua MiniMisc.resize_window()<CR>", "Resize to default width")
map_leader("n", "ot", "<Cmd>lua MiniTrailspace.trim()<CR>",    "Trim trailspace")
map_leader("n", "oz", "<Cmd>lua MiniMisc.zoom()<CR>",          "Zoom toggle")

-- ### "q" is for "Quickfix" and "Location" Lists
map_leader("n", "qq", explore_quickfix,                         'Quickfix list')
map_leader("n", "qQ", explore_locations,                        'Location list')

-- ### "s" is for "Session"
local session_new = "vim.ui.input({ prompt = 'Session name: ' }, MiniSessions.write)"

map_leader("n", "sd", "<Cmd>lua MiniSessions.select('delete')<CR>", "Delete")
map_leader("n", "sn", "<Cmd>lua " .. session_new .. "<CR>",         "New")
map_leader("n", "sr", "<Cmd>lua MiniSessions.select('read')<CR>",   "Read")
map_leader("n", "sR", "<Cmd>lua MiniSessions.restart()<CR>",        "Restart")
map_leader("n", "sw", "<Cmd>lua MiniSessions.write()<CR>",          "Write current")

-- ### "t" is for "Terminal"
local toggleTermInstalled, _ = pcall(require, "toggleterm")
if toggleTermInstalled then
  map_leader("n", "tT", "<Cmd>vertical term<CR>", "Terminal (vertical)")
  map_leader("n", "tt", "<Cmd>ToggleTerm direction=horizontal<CR>",   "Terminal (horizontal)")
  map_leader("n", "tf", "<Cmd>ToggleTerm<CR>",   "Terminal (horizontal)")
else
  map_leader("n", "tT", "<Cmd>vertical term<CR>", "Terminal (vertical)")
  map_leader("n", "tt", "<Cmd>horizontal term<CR>",   "Terminal (horizontal)")
end

-- ### "v" is for "Visits"
local make_pick_core = function(cwd, desc)
  return function()
    local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
    local local_opts = { cwd = cwd, filter = 'core', sort = sort_latest }
    MiniExtra.pickers.visit_paths(local_opts, { source = { name = desc } })
  end
end

map_leader("n", "vc", make_pick_core("",  "Core visits (all)"),       "Core visits (all)")
map_leader("n", "vC", make_pick_core(nil, "Core visits (cwd)"),       "Core visits (cwd)")
map_leader("n", "vv", "<Cmd>lua MiniVisits.add_label('core')<CR>",    "Add 'core' label")
map_leader("n", "vV", "<Cmd>lua MiniVisits.remove_label('core')<CR>", "Remove 'core' label")
map_leader("n", "vl", "<Cmd>lua MiniVisits.add_label()<CR>",          "Add label")
map_leader("n", "vL", "<Cmd>lua MiniVisits.remove_label()<CR>",       "Remove label")

-- Hop
local hopInstalled, _ = pcall(require, "hop")
if hopInstalled then
  map_leader("n", "h", "", "+Hop")
end

-- Ideas
-- =, format entire document
-- ={motion}, format move text
-- visual mode, =, format selection
-- gy, go to type definition (lsp)
-- gr, go to references (lsp)
-- gi, to to implementation (LSP)
