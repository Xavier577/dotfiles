# dotfiles

My personal dev environment config — Neovim, zsh, tmux.

## Stack

- **Terminal:** [iTerm2](https://iterm2.com/)
- **Shell:** zsh + [oh-my-zsh](https://ohmyz.sh/) with the [ultima](https://github.com/egorlem/ultima.zsh-theme) theme
- **Multiplexer:** tmux
- **Editor:** Neovim (built-in LSP, no plugin manager — plugins managed via `pack/`)

## What's in here

| File / dir | Symlinks to |
|---|---|
| `nvim/` | `~/.config/nvim` |
| `zshrc` | `~/.zshrc` |
| `tmux.conf` | `~/.tmux.conf` |

## Zsh theme: ultima

This setup uses the **[ultima](https://github.com/egorlem/ultima.zsh-theme)** theme by [@egorlem](https://github.com/egorlem) — a clean, minimal multi-line prompt with git status info.

The `zshrc` has `ZSH_THEME="ultima"` baked in, so the theme **must be installed** or zsh will fall back to the default and complain on startup.

### Install ultima manually (if not using `install.sh`)

```bash
curl -fsSL https://raw.githubusercontent.com/egorlem/ultima.zsh-theme/master/ultima.zsh-theme \
  -o ~/.oh-my-zsh/themes/ultima.zsh-theme
```

Then start a new shell. The installer script does this automatically.

### Want to use a different theme?

Edit `zshrc` and change `ZSH_THEME="ultima"` to any theme name from the [oh-my-zsh themes list](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes), e.g. `ZSH_THEME="agnoster"` or `ZSH_THEME="robbyrussell"`.

## Install on a fresh machine

```bash
git clone <this-repo-url> ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh
```

The installer will:

1. Install Homebrew if missing
2. Install **oh-my-zsh** + the **ultima** theme
3. Symlink the configs into `$HOME` (existing files backed up to `*.backup`)
4. Install CLI deps: `neovim tmux ripgrep fd tree-sitter node go`
5. Install **iTerm2** (terminal emulator)
6. Install language servers: `gopls`, `typescript-language-server`
7. Clone all Neovim plugins to `~/.local/share/nvim/site/pack/plugins/start/`

After install, open a new terminal and launch `nvim`. Treesitter parsers compile on first run (~30s).

## Neovim plugins

See **[nvim/README.md](nvim/README.md)** for a full guide to keybinds, features, and workflows.

| Plugin | Purpose |
|---|---|
| `diffview.nvim` | Visual git diff browser |
| `vim-fugitive` | Full git client inside Neovim |
| `gitsigns.nvim` | Gutter signs + inline blame |
| `vim-wakatime` | WakaTime time-tracking integration |
| `telescope.nvim` | Fuzzy finder (files, grep, symbols) |
| `nvim-treesitter` | Better syntax highlighting + parsing |
| `render-markdown.nvim` | Inline markdown rendering |
| `nvim-web-devicons` | File icons |

## Personal/local overrides

The committed `zshrc` uses **placeholder-friendly defaults** so the repo is shareable. Anything machine-specific (PATH entries, secrets, work configs) should go in an untracked override file that `zshrc` sources automatically:

| Override file | Used for |
|---|---|
| `~/.zshrc.local` | Machine-specific PATH, aliases, secrets |

After running `install.sh`, create it as needed:

```bash
touch ~/.zshrc.local
# add your PATH entries, aliases, secrets, etc.
```

## Updating configs

The configs are symlinked, so just edit the files in `$HOME` as usual — changes are tracked here automatically.

```bash
cd ~/Developer/dotfiles
git add -A
git commit -m "tweak nvim config"
git push
```
