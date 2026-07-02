# Neovim Configuration

A minimal, plugin-light Neovim configuration for **Go** and **TypeScript/JavaScript** development with first-class git integration, markdown rendering, and a file explorer that feels like Vim.

> **Leader key:** `Space`

---

## Plugins

| Plugin | Purpose |
|---|---|
| `oil.nvim` | File explorer as an editable buffer |
| `telescope.nvim` | Fuzzy finder (files, grep, symbols, buffers) |
| `nvim-treesitter` | Syntax highlighting + parsing |
| `blink.cmp` | Autocompletion (LSP, paths, snippets, buffer) |
| `diffview.nvim` | Visual git diff browser |
| `vim-fugitive` | Full git client inside Neovim |
| `gitsigns.nvim` | Gutter signs + inline blame |
| `render-markdown.nvim` | Inline markdown rendering |
| `nvim-web-devicons` | File icons (requires a Nerd Font) |
| `vim-wakatime` | Coding time tracking |

## Prerequisites

| Tool | Install |
|---|---|
| Neovim 0.10+ | `brew install neovim` |
| ripgrep | `brew install ripgrep` |
| fd | `brew install fd` |
| tree-sitter CLI | `brew install tree-sitter-cli` |
| A [Nerd Font](https://www.nerdfonts.com/) | `brew install --cask font-jetbrains-mono-nerd-font` |
| gopls | `go install golang.org/x/tools/gopls@latest` |
| typescript-language-server | `npm install -g typescript typescript-language-server` |
| yaml-language-server | `npm install -g yaml-language-server` |
| vscode-json-language-server | `npm install -g vscode-langservers-extracted` |

## Install

Run from the dotfiles root:

```bash
./install.sh
```

This clones all plugins to `~/.local/share/nvim/site/pack/plugins/start/`. Treesitter parsers compile on first launch (~30s).

## Documentation

See **[USAGE.md](USAGE.md)** for a full guide to keybinds, features, and workflows.

## Troubleshooting

| Issue | Fix |
|---|---|
| Icons show as `?` boxes | Set your terminal font to a Nerd Font |
| "Spawning language server failed" | Ensure the server binary is on `$PATH` |
| `~/go/bin/gopls` not found | Add `export PATH="$HOME/go/bin:$PATH"` to your shell rc |
| Treesitter `range` errors | Run `:lua require("nvim-treesitter").install({...})` for missing parsers |
| Markdown not rendering | Press `<leader>mt` to enable (off by default) |
