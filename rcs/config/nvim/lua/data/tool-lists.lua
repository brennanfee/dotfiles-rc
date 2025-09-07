local utils = require("utils")

local M = {}

M.treesitter_languages = {
  "bash",
  "bibtex",
  "c",
  "c_sharp",
  "caddy",
  "cmake",
  "comment",
  "commonlisp",
  "cooklang",
  "cpp",
  "css",
  "csv",
  "desktop",
  "diff",
  "dockerfile",
  "editorconfig",
  "fortran",
  "fsharp",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "gnuplot",
  "go",
  "goctl",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  "gpg",
  "graphql",
  "groovy",
  "hcl",
  "helm",
  "html",
  "ini",
  "java",
  "javadoc",
  "javascript",
  "jinja",
  "jinja_inline",
  "jq",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  "julia",
  "kotlin",
  "latex",
  "ledger",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "mermaid",
  "nginx",
  "ninja",
  "nix",
  "norg",
  "pascal",
  "passwd",
  "perl",
  "php",
  "phpdoc",
  "powershell",
  "printf",
  "properties",
  "python",
  "query",
  "r",
  "readline",
  "regex",
  "requirements",
  "robots",
  "rst",
  "ruby",
  "rust",
  "scss",
  "sql",
  "ssh_config",
  "svelte",
  "swift",
  "terraform",
  "tmux",
  "todotxt",
  "toml",
  "tsv",
  "tsx",
  "typescript",
  "typst",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "xresources",
  "yaml",
  "zig",
}

M.lsp_servers = {
  { lsp_name = "bashls", mason_name = "bash-language-server" },
  { lsp_name = "efm", mason_name = "efm" },
  { lsp_name = "lemminx", mason_name = "lemminx" },
  { lsp_name = "lua_ls", mason_name = "lua-language-server" },
  { lsp_name = "nil_ls", mason_name = "nil" },
  { lsp_name = "powershell_es", mason_name = "powershell-editor-services" },
  { lsp_name = "ruff", mason_name = "ruff" },
  { lsp_name = "tinymist", mason_name = "tinymist" },
}

-- M.lsp_servers = {
--   { name = "ansiblels", config = {} },
--   { name = "autotools_ls", config = {} },
--   { name = "awk_ls", config = {} },
--   -- { name = "bacon-ls", config = {} }, -- For Rust (not in lspconfig yet)
--   { name = "basedpyright", config = {} }, -- Pyright replacement
--   { name = "bashls", config = {} },
--   { name = "biome", config = {} },
--   { name = "clangd", config = {} },
--   { name = "cmake", config = {} },
--   { name = "cobol_ls", config = {} },
--   { name = "csharp_ls", config = {} },
--   { name = "css_variables", config = {} },
--   { name = "cssls", config = {} },
--   { name = "cssmodules_ls", config = {} },
--   { name = "cucumber_language_server", config = {} },
--   { name = "docker_compose_language_service", config = {} },
--   { name = "dockerls", config = {} },
--   -- { name = "eslint", config = {} }, -- Use Biome instead
--   { name = "fortls", config = {} },
--   { name = "gopls", config = {} },
--   { name = "graphql", config = {} },
--   -- { name = "harper_ls", config = {} },
--   { name = "html", config = {} },
--   { name = "htmx", config = {} },
--   { name = "jdtls", config = {} }, -- Java
--   { name = "jinja_lsp", config = {} },
--   { name = "jsonls", config = {} },
--   { name = "kotlin_language_server", config = {} },
--   { name = "lemminx", config = {} }, -- Xml language server
--   -- { name = "ltex", config = {} },
--   { name = "lua_ls", config = {} },
--   { name = "markdown_oxide", config = {} },
--   { name = "marksman", config = {} },
--   -- { name = "nginx_language_server", config = {} },
--   -- { name = "nil_ls", config = {} }, -- Fails to install
--   { name = "perlnavigator", config = {} },
--   { name = "phpactor", config = {} },
--   { name = "powershell_es", config = {} },
--   { name = "rubocop", config = {} },
--   { name = "ruby_lsp", config = {} },
--   { name = "ruff", config = {} }, -- Python
--   { name = "rust_analyzer", config = {} }, -- Switch to bacon_ls
--   -- { name = "salt_ls", config = {} }, -- Seems to be broken
--   -- { name = "snyk_ls", config = {} }, -- Security scanning
--   { name = "sqlls", config = {} },
--   { name = "stylelint_lsp", config = {} },
--   { name = "svelte", config = {} },
--   { name = "tailwindcss", config = {} },
--   { name = "taplo", config = {} }, -- TOML language server
--   { name = "terraformls", config = {} },
--   { name = "tflint", config = {} },
--   { name = "tinymist", config = {} }, -- Typst
--   { name = "ts_ls", config = {} },
--   { name = "typos_lsp", config = {} },
--   { name = "vacuum", config = {} }, -- OpenAPI/Swagger
--   { name = "vimls", config = {} },
--   { name = "vuels", config = {} },
--   { name = "yamlls", config = {} },
-- }

M.debug_adapters = {
  { dap_name = "bash", mason_name = "bash-debug-adapter" },
}

-- M.debug_adapters = {
--   "bash-debug-adapter",
--   -- "chrome-debug-adapter", -- doesn't seem to work
--   "cpptools",
--   "debugpy",
--   -- "delve", -- Go debugger -- part of go now
--   "firefox-debug-adapter",
--   "java-debug-adapter",
--   "js-debug-adapter",
--   "kotlin-debug-adapter",
--   "node-debug2-adapter",
--   "perl-debug-adapter",
--   "php-debug-adapter",
-- }

-- M.mason_debug_adapters = {
--   "bash",
--   --        "coreclr", -- not supported on Linux, what a joke
--   "cppdbg",
--   --        "chrome", -- this one seems to be broken
--   "delve", -- this one is for go
--   "firefox",
--   "javadbg",
--   "js",
--   "kotlin",
--   "node2",
--   "php",
--   "python",
-- }

M.linters = {
  { mason_name = "dotenv-linter" },
  { mason_name = "editorconfig-checker" },
  { mason_name = "gitlint" },
  { mason_name = "luacheck" },
  { mason_name = "markdownlint-cli2" },
  { mason_name = "shellcheck" },
  { mason_name = "ty" },
  { mason_name = "yamllint" },
}

-- M.linters = {
--   "actionlint",
--   "alex",
--   "ansible-lint",
--   "ast-grep",
--   "bacon", -- For Rust
--   "bacon-ls", -- For Rust
--   "biome",
--   "buf",
--   "cfn-lint",
--   "checkmake",
--   "checkstyle",
--   "cmakelang",
--   "cmakelint",
--   "commitlint",
--   "cpplint",
--   "curlylint",
--   "editorconfig-checker",
--   "eslint_d",
--   "flake8",
--   "gitleaks",
--   "gitlint",
--   "hadolint", -- Dockerfile linter
--   "htmlhint",
--   "jsonlint",
--   "ktlint",
--   "luacheck",
--   "markdownlint",
--   "misspell",
--   "oxlint",
--   "phpstan",
--   "proselint",
--   "pydocstyle",
--   "pylint",
--   "rubocop",
--   "ruff",
--   "salt-lint",
--   "selene", -- For Lua
--   "semgrep",
--   -- "snyk",
--   "sqlfluff",
--   "stylelint",
--   "systemdlint",
--   "textlint",
--   "tflint",
--   "tfsec",
--   "typos",
--   "vacuum",
--   "vint",
--   "vulture",
--   "woke",
--   "write-good",
--   "yamllint",
-- }

M.formatters = {
  { mason_name = "cbfmt" },
  { mason_name = "nixfmt" },
  { mason_name = "nixpkgs-fmt" },
  { mason_name = "prettier" },
  { mason_name = "stylua" },
  { mason_name = "shfmt" },
  { mason_name = "typstyle" },
  { mason_name = "xmlformatter" },
  { mason_name = "yamlfmt" },
}

-- M.formatters = {
--   "ast-grep",
--   "autoflake",
--   "biome",
--   "buf",
--   "cbfmt",
--   "clang-format",
--   "cmakelang",
--   "csharpier",
--   "docformatter",
--   "doctoc",
--   "fixjson",
--   "fprettify",
--   "gci",
--   -- "gofumpt", -- part of go now
--   -- "goimports", -- part of go now
--   "google-java-format",
--   "hclfmt",
--   "isort",
--   "ktfmt",
--   "ktlint",
--   "luaformatter",
--   "markdown-toc",
--   "markdownlint",
--   "mdformat",
--   "mdsf",
--   "nixpkgs-fmt",
--   "php-cs-fixer",
--   -- "pint", -- Temporarily disabled PHP
--   "prettier",
--   "prettierd",
--   "pretty-php",
--   "pyment",
--   "reformat-gherkin",
--   "rubocop",
--   "rubyfmt",
--   "ruff",
--   "rufo",
--   "rustywind", -- For Tailwind
--   "shfmt",
--   "sqlfmt",
--   "stylua",
--   "typstfmt",
--   "xmlformatter",
--   "yamlfmt",
-- }

-- Only mason installed
M.misc_tools = {
  "gh",
  "glow",
  "jq",
  "yq",
}

M.all_mason_tools = {}

for _, lsp in pairs(M.lsp_servers) do
  if utils.isNotEmpty(lsp.mason_name) then
    table.insert(M.all_mason_tools, lsp.mason_name)
  end
end

for _, linter in pairs(M.linters) do
  if utils.isNotEmpty(linter.mason_name) then
    table.insert(M.all_mason_tools, linter.mason_name)
  end
end

for _, formatter in pairs(M.formatters) do
  if utils.isNotEmpty(formatter.mason_name) then
    table.insert(M.all_mason_tools, formatter.mason_name)
  end
end

for _, adapter in pairs(M.debug_adapters) do
  if utils.isNotEmpty(adapter.mason_name) then
    table.insert(M.all_mason_tools, adapter.mason_name)
  end
end

utils.tableAppendList(M.all_mason_tools, M.misc_tools)

return M
