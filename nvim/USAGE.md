# Neovim Usage Guide

Full reference for keybinds, features, and workflows.

> **Leader key:** `Space`

---

## File Explorer (Oil)

Oil opens directories as editable buffers. Navigate the file tree like editing text — rename files by changing text, delete by removing lines, create by typing new names. Save the buffer to apply changes.

| Key | Action |
|---|---|
| `-` | Open parent directory |
| `<CR>` | Open file / enter directory |
| `-` (inside Oil) | Go up one directory |

### Editing the filesystem

Inside an Oil buffer, the file list is just text. To manipulate files:

- **Rename:** edit the filename text, then `:w`
- **Delete:** delete the line, then `:w`
- **Create file:** type a new filename on a blank line, then `:w`
- **Create directory:** type a name ending in `/`, then `:w`
- **Move:** cut a line, paste it in another Oil buffer, then `:w` both

Oil shows hidden files by default (dotfiles).

---

## Telescope — Fuzzy Finder

Project-wide search for files, text, symbols, references, and more.

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep across the entire project |
| `<leader>fb` | Switch between open buffers |
| `<leader>fh` | Search Neovim help docs |
| `<leader>fs` | LSP workspace symbols (functions, classes) |
| `<leader>fr` | LSP references for symbol under cursor |
| `<leader>fd` | All diagnostics across project |

### Inside the Telescope window

| Key | Action |
|---|---|
| Type | Fuzzy-filter results |
| `<C-j>` / `<C-k>` | Navigate up/down |
| `<CR>` | Open selected |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<Esc>` | Close |

### Buffer picker extras

| Key | Action |
|---|---|
| `<C-d>` | Delete (close) the highlighted buffer |

---

## Terminals (ToggleTerm)

Toggleable terminal instances that persist in the background. Each terminal keeps its shell session running when hidden — ideal for long-running servers.

### Basic usage

| Key | Action |
|---|---|
| `<leader>tt` | Toggle terminal #1 |
| `<leader>t2` | Toggle terminal #2 |
| `<leader>t3` | Toggle terminal #3 |
| `<leader>t4` | Toggle terminal #4 |
| `<leader>ts` | Select terminal from a list |
| `<Esc>` (in terminal) | Exit terminal mode (back to normal mode) |

Each number is a separate, persistent terminal. Use them to run different servers:
- `<leader>tt` — frontend dev server
- `<leader>t2` — backend API
- `<leader>t3` — database / docker

### Navigating from a terminal

While inside a terminal, you can move to other splits:

| Key | Action |
|---|---|
| `<C-h>` | Move to left split |
| `<C-j>` | Move to below split |
| `<C-k>` | Move to above split |
| `<C-l>` | Move to right split |

### Commands

| Command | Action |
|---|---|
| `:ToggleTerm` | Toggle default terminal |
| `:ToggleTerm direction=vertical` | Open as vertical split |
| `:ToggleTerm direction=float` | Open as floating window |
| `:ToggleTermToggleAll` | Hide/show all open terminals |
| `:TermSelect` | Pick a terminal from a list |

---

## Window Management

### Toggle zoom

| Key | Action |
|---|---|
| `<leader>z` | Zoom current split to full screen (opens in a new tab) |
| `<leader>z` (again) | Unzoom — closes the tab, restoring original split layout |

Buffers stay open the entire time. The split layout is preserved exactly as it was.

### Built-in split navigation

| Key | Action |
|---|---|
| `<C-w>v` | Vertical split |
| `<C-w>s` | Horizontal split |
| `<C-w>h/j/k/l` | Move between splits |
| `<C-w>=` | Equalize split sizes |
| `<C-w>>` / `<C-w><` | Resize width |
| `<C-w>+` / `<C-w>-` | Resize height |

---

## Named Tabs

Label tabs for organized workflows (e.g. one tab for code, another for terminals).

| Command | Action |
|---|---|
| `:TabName code` | Label the current tab "code" |
| `:TabName terminals` | Label it "terminals" |
| `:TabName` (no arg) | Clear the name (falls back to buffer filename) |

### Tab navigation

| Key | Action |
|---|---|
| `gt` | Next tab |
| `gT` | Previous tab |
| `:tabnew` | Create a new tab |
| `:tabclose` | Close current tab |

---

## LSP (Language Server Protocol)

Built-in Neovim LSP — no `nvim-lspconfig` needed. Servers attach automatically when you open a supported file.

### Servers configured

| Language | Server |
|---|---|
| Go | `gopls` |
| TypeScript / JavaScript | `ts_ls` |
| YAML | `yaml-language-server` |
| JSON | `vscode-json-language-server` |

YAML and JSON include **SchemaStore** integration — Kubernetes manifests, GitHub Actions, `docker-compose.yml`, `package.json`, `tsconfig.json`, etc. get full intellisense automatically.

### Keybinds

| Key | Action |
|---|---|
| `K` | Hover docs |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find references |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>f` | Format buffer |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>d` | Show diagnostic in floating window |

### Code actions (`<leader>ca`)

Context-aware quick fixes and refactors. Examples:

**Go:** Add/remove imports, extract to function/variable, fill struct, generate interface stubs, add error handling.

**TypeScript/JS:** Add/organize imports, extract to function/constant, add type assertion, implement interface.

### Verify LSP is working

```vim
:checkhealth vim.lsp
```

---

## Completion (blink.cmp)

Autocompletion from LSP, paths, snippets, and buffer words — appears as you type.

| Key (insert mode) | Action |
|---|---|
| `<C-space>` | Open completion menu |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<C-y>` | Accept selected |
| `<C-e>` | Dismiss menu |
| `<C-k>` | Toggle signature help |

Sources (priority order): LSP > Path > Snippets > Buffer.

Auto-imports work in Go, TypeScript, and JavaScript — accepting a completion from another package adds the import automatically.

---

## Treesitter

Syntax highlighting for: `markdown`, `markdown_inline`, `go`, `typescript`, `tsx`, `javascript`.

To add more parsers:

```vim
:lua require("nvim-treesitter").install({ "rust", "python", "lua" })
```

---

## Markdown Rendering

Renders headings, code blocks, lists, tables, and checkboxes inline.

| Key | Action |
|---|---|
| `<leader>mt` | Toggle markdown rendering on/off |

Default: **OFF**. Toggle on when reading, off when editing.

---

## Git: Diffview

Side-by-side diff viewer with a file list panel. Best for **reviewing** changes.

| Key | Action |
|---|---|
| `<leader>gd` | Open diff view (working tree vs HEAD) |
| `<leader>gh` | File history for current file |
| `<leader>gq` | Close diff view |

### Inside the file list panel

| Key | Action |
|---|---|
| `<CR>` / `o` | Open file's diff |
| `s` | Stage / unstage file |
| `S` | Stage all |
| `X` | Discard file changes |
| `<Tab>` | Next file |

### Useful commands

```vim
:DiffviewOpen HEAD~3        " compare against 3 commits ago
:DiffviewOpen main..feature " compare branches
:DiffviewOpen --staged      " show staged changes only
:DiffviewFileHistory        " browse all commits in repo
```

---

## Git: Fugitive

Full git client inside Neovim. Best for **doing** things (commit, push, blame).

| Key | Action |
|---|---|
| `<leader>gs` | Git status (interactive) |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gP` | Git pull |
| `<leader>gb` | Git blame (side panel) |
| `<leader>gl` | Git log (oneline) |

Run any git command: `:Git rebase -i HEAD~3`, `:Git stash`, etc.

### Inside `:Git` status window

| Key | Action |
|---|---|
| `s` | Stage file |
| `u` | Unstage |
| `X` | Discard changes |
| `=` | Toggle inline diff |
| `cc` | Commit |
| `ca` | Commit --amend |
| `dd` | Open diff in split |

**Partial staging:** Press `=` to expand diff, visually select lines, press `s`.

---

## Git: Gitsigns

Real-time gutter signs and per-line blame.

| Key | Action |
|---|---|
| `]c` / `[c` | Next / previous git hunk |
| `<leader>hp` | Preview hunk diff in popup |
| `<leader>hr` | Reset (discard) the current hunk |
| `<leader>tb` | Toggle inline blame for current line |
| `<leader>tB` | Open full-file blame panel |

---

## General

| Key | Action |
|---|---|
| `<leader>s` | Save file |
| `<leader>R` | Reload nvim config |

---

## Working Directory

Neovim's working directory (`cwd`) determines where git commands (Diffview, Fugitive) and project-wide searches (Telescope grep) operate.

### Auto-cd to git root

When you open a file inside a git repo, `cwd` automatically changes to that repo's root. Diffview, Fugitive, and Telescope just work against the correct repo — no manual action needed.

### Manual override

| Command | Action |
|---|---|
| `:Cd ~/path/to/dir` | Change `cwd` to any directory (tab-completes) |

Useful for non-git directories, monorepos where you want to target a subdirectory, or overriding the auto behavior.

---

## Workflow: Write Code

1. `-` to browse files, or `<leader>ff` to fuzzy-find
2. Edit — completions appear as you type (`<C-y>` to accept)
3. `K` for hover docs, `gd` to jump to definitions
4. `<leader>f` to format, `<leader>ca` for quick fixes
5. `<leader>fg` to grep across the project

## Workflow: Review Changes

1. `<leader>gd` opens Diffview
2. Browse files, navigate hunks with `]c` / `[c`
3. `<leader>hp` to preview, `<leader>hr` to discard

## Workflow: Commit and Push

1. `<leader>gs` opens Fugitive status
2. `s` to stage files (or `=` then visual-select + `s` for partial)
3. `cc` to commit, type message, `:wq`
4. `<leader>gp` to push

## Workflow: Named Tab Workspaces

1. `:tabnew` — create a tab for terminals
2. `:TabName terminals` — label it
3. Open terminal splits with `:terminal`
4. `gT` to switch back to your code tab
5. `:TabName code` — label that one too

## Workflow: Running Multiple Servers

1. `<leader>tt` — open terminal #1, run your frontend server
2. `<leader>tt` — toggle it away (server keeps running)
3. `<leader>t2` — open terminal #2, run your backend
4. `<leader>t2` — toggle it away
5. `<leader>t3` — open terminal #3 for ad-hoc commands
6. Toggle any of them back at any time with their keybind

## Workflow: Focus on One Split

1. Working in a multi-split layout
2. `<leader>z` — zoom the current split to full screen
3. Do focused work
4. `<leader>z` — restore original split layout

---

## WakaTime

Tracks coding time silently. On first launch, enter your API key from [wakatime.com/settings/api-key](https://wakatime.com/settings/api-key). Check stats at [wakatime.com/dashboard](https://wakatime.com/dashboard).
