local utils = require("utils")

local M = {}

M.treesitter_languages = {
  "angular",
  "asm",
  "awk",
  "bash",
  "beancount",
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
  "dot",
  "dtd",
  "ecma",
  "editorconfig",
  "erlang",
  "fish",
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
  "haskell",
  "hcl",
  "helm",
  "hjson",
  "html",
  "html_tags",
  "htmldjango",
  "http",
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
  "jsx",
  "julia",
  "just",
  "kitty",
  "kotlin",
  "latex",
  "ledger",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "matlab",
  "mermaid",
  "nasm",
  "nginx",
  "ninja",
  "nix",
  "objc",
  "ocaml",
  "ocaml_interface",
  "ocamllex",
  "pascal",
  "passwd",
  "pem",
  "perl",
  "php",
  "phpdoc",
  "po",
  "powershell",
  "printf",
  "prolog",
  "properties",
  "python",
  "query",
  "r",
  "readline",
  "regex",
  "requirements",
  "robots_txt",
  "rst",
  "ruby",
  "rust",
  "scala",
  "scheme",
  "scss",
  "sql",
  "ssh_config",
  "svelte",
  "swift",
  "systemverilog",
  "tcl",
  "templ",
  "terraform",
  "tmux",
  "todotxt",
  "toml",
  "tsv",
  "tsx",
  "typescript",
  "typespec",
  "typst",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "xresources",
  "yaml",
  "zig",
  "zsh",
}

-- Language servers to enable and/or install.  If mason_name is filled in, Mason will install
-- and manage the language server.  If the mason_name is blank, the language server or tool must
-- be installed somewhere else (usually using Mise).
M.lsp_servers = {
  { lsp_name = "ansiblels", mason_name = "ansible-language-server" },
  { lsp_name = "bashls", mason_name = "bash-language-server" },
  { lsp_name = "biome", mason_name = "" }, -- Javascript, Typescript, JSX, Json, CSS, GraphQL
  { lsp_name = "clangd", mason_name = "clangd" },
  { lsp_name = "dockerls", mason_name = "docker-language-server" },
  { lsp_name = "efm", mason_name = "efm" },
  { lsp_name = "gopls", mason_name = "gopls" },
  { lsp_name = "harper_ls", mason_name = "harper-ls" },
  { lsp_name = "jdtls", mason_name = "jdtls" }, -- Java
  { lsp_name = "jinja_lsp", mason_name = "jinja-lsp" },
  { lsp_name = "just", mason_name = "just-lsp" },
  { lsp_name = "kotlin_language_server", mason_name = "kotlin-language-server" },
  { lsp_name = "lemminx", mason_name = "lemminx" }, -- Xml
  { lsp_name = "lua_ls", mason_name = "lua-language-server" },
  { lsp_name = "marksman", mason_name = "marksman" }, -- Markdown
  { lsp_name = "neocmake", mason_name = "neocmakelsp" }, -- CMake
  { lsp_name = "nginx_language_server", mason_name = "nginx-language-server" },
  { lsp_name = "nil_ls", mason_name = "nil" }, -- Nix
  { lsp_name = "postgres_lsp", mason_name = "postgres-language-server" },
  { lsp_name = "powershell_es", mason_name = "powershell-editor-services" },
  { lsp_name = "ruby-lsp", mason_name = "ruby-lsp" },
  { lsp_name = "rust_analyzer", mason_name = "" },
  { lsp_name = "snyk", mason_name = "snyk-ls" }, -- Security focused, multiple languages
  { lsp_name = "superhtml", mason_name = "superhtml" }, -- Html
  { lsp_name = "svelte", mason_name = "svelte-language-server" },
  { lsp_name = "systemd_lsp", mason_name = "systemd-lsp" },
  { lsp_name = "taplo", mason_name = "" }, -- Toml
  { lsp_name = "terraformls", mason_name = "terraform-ls" },
  { lsp_name = "tinymist", mason_name = "tinymist" }, -- Typst
  { lsp_name = "tofu_ls", mason_name = "tofu-ls" }, -- OpenTofu (Terraform)
  { lsp_name = "ty", mason_name = "" }, -- Python (from Astral)
  { lsp_name = "typos_lsp", mason_name = "typos-lsp" },
  { lsp_name = "vue_ls", mason_name = "vue-language-server" },
  { lsp_name = "yamlls", mason_name = "yaml-language-server" },
  { lsp_name = "zls", mason_name = "zls" }, -- Zig
}

-- M.lsp_servers_rarely_used = {
--   { lsp_name = "awk_ls", mason_name = "awk-language-server" },
--   { lsp_name = "beancount", mason_name = "beaqncount-language-server" },
--   { lsp_name = "csharp_ls", mason_name = "csharp-language-server" },
--   { lsp_name = "cobol", mason_name = "cobol-language-server" },
--   { lsp_name = "cucumber_language_server", mason_name = "cucumber-language-server" },
--   { lsp_name = "djls", mason_name = "django-language-server" },
--   { lsp_name = "dotls", mason_name = "dot-language-server" },
--   { lsp_name = "fortran", mason_name = "fortls" },
--   { lsp_name = "gradle_ls", mason_name = "gradle-language-server" },
--   { lsp_name = "groovyls", mason_name = "groovy-language-server" },
--   { lsp_name = "hls", mason_name = "haskell-language-server" },
--   { lsp_name = "helm_ls", mason_name = "helm-ls" },
--   { lsp_name = "jqls", mason_name = "jq-ls" },
--   { lsp_name = "julials", mason_name = "julia-lsp" },
--   { lsp_name = "laravel_ls", mason_name = "laravel-ls" },
--   { lsp_name = "markdown_oxide", mason_name = "markdown-oxide" },
--   { lsp_name = "ocamllsp", mason_name = "ocaml-lsp" },
--   { lsp_name = "perlnavigator", mason_name = "perlnavigator" },
--   { lsp_name = "phpactor", mason_name = "phpactor" },
--   { lsp_name = "r_langauge_server", mason_name = "r-languageserver" },
--   { lsp_name = "salt-lsp", mason_name = "salt-lsp" },
--   { lsp_name = "tclsp", mason_name = "tclint" }, -- Tcl
--   { lsp_name = "texlab", mason_name = "texlab" },
--   { lsp_name = "vimls", mason_name = "vim-language-server" },
-- }

-- M.lsp_servers_alternates = {
--   { lsp_name = "basedpyright", mason_name = "basedpyright" },
--   { lsp_name = "cmake", mason_name = "cmake-language-server" },
--   { lsp_name = "cssls", mason_name = "css-lsp" },
--   { lsp_name = "css_variables", mason_name = "css-variables-language-server" },
--   { lsp_name = "cssmodules_ls", mason_name = "cssmodules-language-server" },
--   { lsp_name = "djlsp", mason_name = "django-template-lsp" },
--   { lsp_name = "html", mason_name = "html-lsp" },
--   { lsp_name = "htmx", mason_name = "htmx-lsp" },
--   { lsp_name = "intelephense", mason_name = "intelephense" }, -- PHP
--   { lsp_name = "java_language_server", mason_name = "java-language-server" },
--   { lsp_name = "jsonls", mason_name = "json-lsp" },
--   { lsp_name = "ltex", mason_name = "ltex-ls" },
--   { lsp_name = "ltex_plus", mason_name = "ltex-ls-plus" },
--   { lsp_name = "pylsp", mason_name = "python-lsp-server" },
--   { lsp_name = "rumdl", mason_name = "rumdl" }, -- Markdown
--   { lsp_name = "sqlls", mason_name = "sqlls" },
--   { lsp_name = "tailwindcss", mason_name = "tailwindcss-language-server" },
--   { lsp_name = "ts_ls", mason_name = "typescript-language-server" },
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

-- M.all_mason_tools = {}

-- for _, lsp in pairs(M.lsp_servers) do
--   if utils.isNotEmpty(lsp.mason_name) then
--     table.insert(M.all_mason_tools, lsp.mason_name)
--   end
-- end

-- for _, linter in pairs(M.linters) do
--   if utils.isNotEmpty(linter.mason_name) then
--     table.insert(M.all_mason_tools, linter.mason_name)
--   end
-- end

-- for _, formatter in pairs(M.formatters) do
--   if utils.isNotEmpty(formatter.mason_name) then
--     table.insert(M.all_mason_tools, formatter.mason_name)
--   end
-- end

-- for _, adapter in pairs(M.debug_adapters) do
--   if utils.isNotEmpty(adapter.mason_name) then
--     table.insert(M.all_mason_tools, adapter.mason_name)
--   end
-- end

-- utils.tableAppendList(M.all_mason_tools, M.misc_tools)

M.mason_to_install = {}

for _, lsp in pairs(M.lsp_servers) do
  if utils.isNotEmpty(lsp.mason_name) then
    table.insert(M.mason_to_install, lsp.mason_name)
  end
end

return M
