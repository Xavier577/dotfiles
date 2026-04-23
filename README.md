# dotfiles

My personal dev environment config — Neovim, zsh, tmux, git.

## What's in here

| File / dir | Symlinks to |
|---|---|
| `nvim/` | `~/.config/nvim` |
| `zshrc` | `~/.zshrc` |
| `tmux.conf` | `~/.tmux.conf` |
| `gitconfig` | `~/.gitconfig` |

## Install on a fresh machine

```bash
git clone <this-repo-url> ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh
```

The installer will:

1. Symlink the configs into `$HOME` (existing files backed up to `*.backup`)
2. Install Homebrew if missing
3. Install CLI deps: `neovim tmux ripgrep fd tree-sitter node go`
4. Install language servers: `gopls`, `typescript-language-server`
5. Clone all Neovim plugins to `~/.local/share/nvim/site/pack/plugins/start/`

After install, open a new terminal and launch `nvim`. Treesitter parsers compile on first run (~30s).

## Neovim plugins

| Plugin | Purpose |
|---|---|
| `diffview.nvim` | Visual git diff browser |
| `vim-fugitive` | Full git client inside Neovim |
| `gitsigns.nvim` | Gutter signs + inline blame |
| `telescope.nvim` | Fuzzy finder (files, grep, symbols) |
| `nvim-treesitter` | Better syntax highlighting + parsing |
| `render-markdown.nvim` | Inline markdown rendering |
| `nvim-web-devicons` | File icons |

## Updating configs

The configs are symlinked, so just edit the files in `$HOME` as usual — changes are tracked here automatically.

```bash
cd ~/Developer/dotfiles
git add -A
git commit -m "tweak nvim config"
git push
```
