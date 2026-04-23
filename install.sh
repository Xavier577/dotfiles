#!/usr/bin/env bash
# Dotfiles installer — symlinks configs and installs all required tools/plugins.
# Run from the dotfiles repo root: ./install.sh

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📂 Dotfiles dir: $DOTFILES"

# ---------- helpers ----------
backup_and_link() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "  📦 Backing up existing $dest -> $dest.backup"
    mv "$dest" "$dest.backup"
  elif [ -L "$dest" ]; then
    rm "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "  🔗 $dest -> $src"
}

clone_if_missing() {
  local repo="$1" dest="$2"
  if [ -d "$dest" ]; then
    echo "  ✓ $(basename "$dest") already installed"
  else
    echo "  ⬇  Cloning $(basename "$dest")"
    git clone --depth 1 "$repo" "$dest" >/dev/null 2>&1
  fi
}

# ---------- 1. Symlink dotfiles ----------
echo ""
echo "🔗 Linking dotfiles..."
backup_and_link "$DOTFILES/nvim"        "$HOME/.config/nvim"
backup_and_link "$DOTFILES/zshrc"       "$HOME/.zshrc"
backup_and_link "$DOTFILES/tmux.conf"   "$HOME/.tmux.conf"
backup_and_link "$DOTFILES/gitconfig"   "$HOME/.gitconfig"

# ---------- 2. Install Homebrew if missing ----------
if ! command -v brew >/dev/null 2>&1; then
  echo ""
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ---------- 3. Install CLI tools ----------
echo ""
echo "📦 Installing CLI tools via Homebrew..."
for pkg in neovim tmux ripgrep fd tree-sitter node go; do
  if brew list "$pkg" >/dev/null 2>&1; then
    echo "  ✓ $pkg"
  else
    echo "  ⬇  $pkg"
    brew install "$pkg" >/dev/null
  fi
done

# ---------- 4. Install LSP servers ----------
echo ""
echo "🧠 Installing language servers..."

# gopls (Go)
if ! [ -x "$HOME/go/bin/gopls" ]; then
  echo "  ⬇  gopls"
  go install golang.org/x/tools/gopls@latest
else
  echo "  ✓ gopls"
fi

# typescript-language-server
if ! command -v typescript-language-server >/dev/null 2>&1; then
  echo "  ⬇  typescript-language-server"
  npm install -g typescript typescript-language-server >/dev/null
else
  echo "  ✓ typescript-language-server"
fi

# ---------- 5. Install Neovim plugins ----------
echo ""
echo "🔌 Installing Neovim plugins..."
PLUGIN_DIR="$HOME/.local/share/nvim/site/pack/plugins/start"
mkdir -p "$PLUGIN_DIR"

clone_if_missing https://github.com/sindrets/diffview.nvim                 "$PLUGIN_DIR/diffview.nvim"
clone_if_missing https://github.com/MeanderingProgrammer/render-markdown.nvim "$PLUGIN_DIR/render-markdown.nvim"
clone_if_missing https://github.com/nvim-treesitter/nvim-treesitter        "$PLUGIN_DIR/nvim-treesitter"
clone_if_missing https://github.com/nvim-tree/nvim-web-devicons            "$PLUGIN_DIR/nvim-web-devicons"
clone_if_missing https://github.com/nvim-telescope/telescope.nvim          "$PLUGIN_DIR/telescope.nvim"
clone_if_missing https://github.com/nvim-lua/plenary.nvim                  "$PLUGIN_DIR/plenary.nvim"
clone_if_missing https://github.com/tpope/vim-fugitive                     "$PLUGIN_DIR/vim-fugitive"
clone_if_missing https://github.com/lewis6991/gitsigns.nvim                "$PLUGIN_DIR/gitsigns.nvim"

# nvim-treesitter needs the `main` branch for Neovim 0.10+
(cd "$PLUGIN_DIR/nvim-treesitter" && git fetch --quiet origin main && git checkout --quiet main >/dev/null 2>&1 || true)

echo ""
echo "✅ All done!"
echo ""
echo "Next steps:"
echo "  1. Open a new terminal (so PATH picks up ~/go/bin)"
echo "  2. Launch nvim — treesitter parsers will compile on first run (~30s)"
echo "  3. Open a .go or .ts file to verify LSP attaches"
