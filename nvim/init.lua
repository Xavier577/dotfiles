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

-- Reload config
vim.keymap.set("n", "<leader>R", "<cmd>source $MYVIMRC<cr>", { desc = "Reload nvim config" })

-- Toggle zoom: maximize current split or restore previous layout
local zoom_tab = nil

vim.keymap.set("n", "<leader>z", function()
  if zoom_tab then
    vim.cmd("tab close")
    zoom_tab = nil
  else
    if vim.fn.winnr("$") > 1 then
      zoom_tab = true
      vim.cmd("tab split")
    end
  end
end, { desc = "Toggle zoom split" })

-- Named tabs: :TabName <name> to label, :TabName (no arg) to clear
vim.api.nvim_create_user_command("TabName", function(opts)
  local name = opts.args ~= "" and opts.args or nil
  vim.t.tab_name = name
  vim.cmd("redrawtabline")
end, { nargs = "?" })

vim.o.tabline = "%!v:lua._custom_tabline()"

function _G._custom_tabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local hl = (i == vim.fn.tabpagenr()) and "%#TabLineSel#" or "%#TabLine#"
    s = s .. hl .. " "
    local name = vim.fn.gettabvar(i, "tab_name")
    if name ~= "" then
      s = s .. name
    else
      local bufnr = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
      local fname = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
      s = s .. (fname ~= "" and fname or "[No Name]")
    end
    s = s .. " "
  end
  s = s .. "%#TabLineFill#"
  return s
end

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

-- Completion: blink.cmp
require("blink.cmp").setup({
  keymap = { preset = "default" },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = { auto_show = true },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = { implementation = "prefer_rust" },
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
      capabilities = require("blink.cmp").get_lsp_capabilities(),
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
      capabilities = require("blink.cmp").get_lsp_capabilities(),
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
      capabilities = require("blink.cmp").get_lsp_capabilities(),
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
      capabilities = require("blink.cmp").get_lsp_capabilities(),
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

-- Oil: file explorer as a buffer (replaces :Ex)
require("oil").setup({
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory (Oil)" })

-- Telescope: fuzzy finder for files, text, symbols
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").setup({
  pickers = {
    buffers = {
      mappings = {
        i = { ["<C-d>"] = actions.delete_buffer },
        n = { ["<C-d>"] = actions.delete_buffer },
      },
    },
  },
})

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

-- Toggleterm: toggleable terminal instances
require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then return 15
    elseif term.direction == "vertical" then return vim.o.columns * 0.4
    end
  end,
  open_mapping = false,
  direction = "horizontal",
  shade_terminals = true,
  start_in_insert = true,
  persist_size = true,
  close_on_exit = true,
})

-- Terminal mode: escape back to normal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Terminal: move to left split" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Terminal: move to below split" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Terminal: move to above split" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Terminal: move to right split" })

-- Toggle terminals by number: <leader>tt, <leader>t2, <leader>t3, etc.
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal #1" })
vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<cr>", { desc = "Toggle terminal #2" })
vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<cr>", { desc = "Toggle terminal #3" })
vim.keymap.set("n", "<leader>t4", "<cmd>4ToggleTerm<cr>", { desc = "Toggle terminal #4" })
vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<cr>", { desc = "Select terminal" })
