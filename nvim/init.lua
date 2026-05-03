-- Basic settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.termguicolors = true

-- Save with <leader>s
vim.keymap.set("n", "<leader>s", "<cmd>write<cr>", { desc = "Save file" })

-- Diagnostics: show errors inline at the end of the line
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- LSP keymaps (set when a server attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    -- Built-in omni completion via <C-x><C-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})

-- Go LSP (gopls)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.lsp.start({
      name = "gopls",
      cmd = { "gopls" },
      root_dir = vim.fs.root(0, { "go.mod", "go.work", ".git" }),
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    })
  end,
})

-- TypeScript / JavaScript LSP
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  callback = function()
    vim.lsp.start({
      name = "ts_ls",
      cmd = { "typescript-language-server", "--stdio" },
      root_dir = vim.fs.root(0, { "tsconfig.json", "jsconfig.json", "package.json", ".git" }),
    })
  end,
})

-- YAML LSP (with SchemaStore for k8s, github actions, docker-compose, etc.)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "yml" },
  callback = function()
    vim.lsp.start({
      name = "yamlls",
      cmd = { "yaml-language-server", "--stdio" },
      root_dir = vim.fs.root(0, { ".git" }) or vim.fn.getcwd(),
      settings = {
        yaml = {
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
          validate = true,
          hover = true,
          completion = true,
        },
      },
    })
  end,
})

-- JSON LSP (with SchemaStore for package.json, tsconfig.json, etc.)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.lsp.start({
      name = "jsonls",
      cmd = { "vscode-json-language-server", "--stdio" },
      root_dir = vim.fs.root(0, { ".git" }) or vim.fn.getcwd(),
      init_options = {
        provideFormatter = true,
      },
      settings = {
        json = {
          validate = { enable = true },
          schemas = {
            { fileMatch = { "package.json" },           url = "https://json.schemastore.org/package.json" },
            { fileMatch = { "tsconfig*.json" },         url = "https://json.schemastore.org/tsconfig.json" },
            { fileMatch = { ".eslintrc", ".eslintrc.json" }, url = "https://json.schemastore.org/eslintrc.json" },
            { fileMatch = { ".prettierrc", ".prettierrc.json" }, url = "https://json.schemastore.org/prettierrc.json" },
          },
        },
      },
    })
  end,
})

-- Treesitter: install parsers and enable highlighting
require("nvim-treesitter").install({ "markdown", "markdown_inline", "go", "typescript", "tsx", "javascript" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "go", "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Render markdown inline in the editor (manual mode — toggle with <leader>mt)
require("render-markdown").setup({
  enabled = false,
  completions = { lsp = { enabled = true } },
})

vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown render" })

-- Telescope: fuzzy finder for files, text, symbols
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files,  { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep,   { desc = "Live grep (project)" })
vim.keymap.set("n", "<leader>fb", builtin.buffers,     { desc = "Open buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags,   { desc = "Help tags" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols (LSP)" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "References (LSP)" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })

-- Diffview (git diff file browser)
require("diffview").setup()

vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open diff view" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "File history" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })

-- Fugitive (full git client)
vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>",         { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>",  { desc = "Git commit" })
vim.keymap.set("n", "<leader>gp", "<cmd>Git push<cr>",    { desc = "Git push" })
vim.keymap.set("n", "<leader>gP", "<cmd>Git pull<cr>",    { desc = "Git pull" })
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>",   { desc = "Git blame" })
vim.keymap.set("n", "<leader>gl", "<cmd>Git log --oneline<cr>", { desc = "Git log" })

-- Gitsigns: gutter signs + inline blame
require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 300,
  },
  current_line_blame_formatter = "<author>, <author_time:%R> · <summary>",
})

vim.keymap.set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle inline blame (line)" })
vim.keymap.set("n", "<leader>tB", "<cmd>Gitsigns blame<cr>", { desc = "Full file blame panel" })
vim.keymap.set("n", "]c", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })
vim.keymap.set("n", "[c", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
