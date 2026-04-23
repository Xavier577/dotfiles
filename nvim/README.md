# Neovim Setup Guide

A minimal, plugin-light Neovim configuration for **Go** and **TypeScript/JavaScript** development with first-class git integration and markdown rendering.

> **Leader key:** `Space`

---

## 🧠 LSP (Language Server Protocol)

Built-in Neovim LSP — no `nvim-lspconfig` needed. Servers attach automatically when you open a `.go` or `.ts/.tsx/.js/.jsx` file.

### Servers configured

| Language | Server | Install command |
|---|---|---|
| Go | `gopls` | `go install golang.org/x/tools/gopls@latest` |
| TypeScript / JavaScript | `ts_ls` | `npm install -g typescript typescript-language-server` |

### Keybinds

| Key | Action |
|---|---|
| `K` | Hover docs (function signature, types, doc comment) |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find references |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>f` | Format buffer |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>d` | Show diagnostic in floating window |
| `<C-x><C-o>` (insert mode) | Trigger omni-completion |

### Verify LSP is working

```vim
:checkhealth vim.lsp
```

---

## 🔭 Telescope — Fuzzy Finder

Project-wide search for files, text, symbols, references, and more.

**Required CLI tools:** `ripgrep`, `fd` (installed via `brew install ripgrep fd`)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | **Live grep** across the entire project |
| `<leader>fb` | Switch between open buffers |
| `<leader>fh` | Search Neovim help docs |
| `<leader>fs` | LSP workspace symbols (functions, classes) |
| `<leader>fr` | LSP references for symbol under cursor |
| `<leader>fd` | All diagnostics across project |

### Inside the Telescope window

- Type to fuzzy-filter
- `<C-j>` / `<C-k>` to navigate
- `<CR>` to open
- `<C-x>` horizontal split, `<C-v>` vertical split, `<C-t>` new tab
- `<Esc>` to close

---

## 🌳 Treesitter

Powers syntax highlighting and is required by `render-markdown`. Installed parsers: `markdown`, `markdown_inline`, `go`, `typescript`, `tsx`, `javascript`.

**Requires the `tree-sitter` CLI** (`brew install tree-sitter`). Parsers compile on first launch (~30s).

To add more parsers:

```vim
:lua require("nvim-treesitter").install({ "rust", "python", "lua" })
```

---

## 📝 Markdown Rendering

Renders headings, code blocks, lists, tables, and checkboxes inline in the editor.

**Default mode: OFF** (manual). Toggle on when you want to read, off when you want to edit.

| Key | Action |
|---|---|
| `<leader>mt` | Toggle markdown rendering on/off |

Or use commands directly: `:RenderMarkdown enable` / `:RenderMarkdown disable` / `:RenderMarkdown toggle`.

---

## 🔀 Git: Diffview — Visual Diff Browser

A side-by-side diff viewer with a file list panel. Best for **reviewing** changes.

| Key | Action |
|---|---|
| `<leader>gd` | Open diff view (working tree vs HEAD) |
| `<leader>gh` | File history for current file |
| `<leader>gq` | Close diff view |

### Inside the file list panel

| Key | Action |
|---|---|
| `<CR>` / `o` | Open file's diff |
| `j` / `k` | Move between files |
| `s` | Stage / unstage file |
| `S` | Stage all |
| `U` | Unstage all |
| `X` | Discard file changes (destructive) |
| `<Tab>` | Next file |
| `R` | Refresh |

### Useful commands

```vim
:DiffviewOpen HEAD~3        " compare against 3 commits ago
:DiffviewOpen main..feature " compare branches
:DiffviewOpen --staged      " show staged changes only
:DiffviewFileHistory        " browse all commits in repo
```

---

## 🔧 Git: Fugitive — Full Git Client

Run any git command from inside Neovim. Best for **doing** things (commit, push, blame).

| Key | Action |
|---|---|
| `<leader>gs` | Git status (interactive) |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gP` | Git pull |
| `<leader>gb` | Git blame (side panel) |
| `<leader>gl` | Git log (oneline) |

Run any other git command with `:Git <anything>` (e.g., `:Git rebase -i HEAD~3`).

### Inside `:Git` status window

| Key | Action |
|---|---|
| `s` | Stage file under cursor |
| `u` | Unstage |
| `X` | Discard changes |
| `=` | Toggle inline diff for file |
| `cc` | Commit |
| `ca` | Commit `--amend` |
| `cw` | Reword last commit |
| `dd` | Open diff in split |

**Pro tip:** Press `=` to expand the diff inline, then **visually select lines** and press `s` to stage just those lines (partial-file staging).

### Inside `:Git blame`

| Key | Action |
|---|---|
| `<CR>` | Show full diff for that commit |
| `o` | Open commit in horizontal split |
| `~` | Reblame at parent commit |
| `q` | Close blame |

---

## ✍️ Git: Gitsigns — Gutter Signs + Inline Blame

Real-time gutter signs (`+` `~` `-`) for uncommitted changes, plus per-line blame.

| Key | Action |
|---|---|
| `]c` / `[c` | Next / previous git hunk |
| `<leader>hp` | Preview hunk diff in popup |
| `<leader>hr` | Reset (discard) the current hunk |
| `<leader>tb` | Toggle inline blame for **current line** |
| `<leader>tB` | Open **full-file blame panel** |

By default, the current line shows a faint blame note at the end:
```
    fmt.Println("hi")          Tsegen, 3 days ago · Add greeting
```

---

## 🗂 Built-in File Browser (Netrw)

| Command | Action |
|---|---|
| `:Ex` / `:Explore` | Open file browser |
| `:Vex` | Open in vertical split |
| `:Lex` | Open as left sidebar |

### Inside netrw

- `<CR>` open file/dir
- `-` go up one directory
- `%` create new file
- `d` create directory
- `D` delete · `R` rename · `q` quit

---

## 🎯 Cheat Sheet by Workflow

### Write some code
1. `<leader>ff` find a file
2. Edit, get `K` hover docs / `gd` to jump around
3. `<leader>f` to format, `<leader>ca` for quick fixes
4. `<leader>fg` to search across the project

### Review changes
1. `<leader>gd` opens Diffview
2. Browse the file list, navigate hunks with `]c` / `[c`
3. Use `<leader>hp` to preview, `<leader>hr` to discard

### Commit and push
1. `<leader>gs` opens Fugitive status
2. Press `s` on each file to stage (or `=` then visually select lines)
3. `cc` to commit (or `<leader>gc`)
4. Type message, `:wq`
5. `<leader>gp` to push

### Find who broke this line
1. Cursor on the suspect line
2. `<leader>tb` for inline blame, or
3. `<leader>gb` for full blame panel — press `<CR>` on a commit to see the full diff

---

## 🩺 Troubleshooting

| Issue | Fix |
|---|---|
| "Spawning language server failed" | Make sure `gopls` / `typescript-language-server` are on `$PATH` |
| `~/go/bin/gopls` not found | Ensure `export PATH="$HOME/go/bin:$PATH"` is in your shell rc |
| Treesitter `range` errors | Run `:lua require("nvim-treesitter").install({...})` for missing parsers |
| `:LspInfo` not found | Use `:checkhealth vim.lsp` instead (we use built-in LSP, not nvim-lspconfig) |
| Markdown not rendering | Press `<leader>mt` to enable (it's off by default) |
