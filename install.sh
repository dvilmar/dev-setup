#!/usr/bin/env bash
# install.sh — Setup dotfiles on a new machine
# Usage: bash install.sh

set -e
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "📦 Installing dotfiles from $DOTFILES"

# ── Helper ────────────────────────────────────────────────────────────────────
link() {
  local src="$DOTFILES/$1"
  local dest="$HOME/$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "  ⚠️  Backup: $dest → $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "  ✅ $dest"
}

# ── Symlinks ──────────────────────────────────────────────────────────────────
echo ""
echo "🔗 Creating symlinks..."
link ".bashrc"           ".bashrc"
link ".gitconfig"        ".gitconfig"
link ".gitignore_global" ".gitignore_global"
link "claude/CLAUDE.md"  ".claude/CLAUDE.md"

# .wslconfig va en Windows, no en WSL
WSLCONFIG="/mnt/c/Users/Daniel/.wslconfig"
if [ -d "/mnt/c/Users/Daniel" ]; then
  cp "$DOTFILES/.wslconfig" "$WSLCONFIG"
  echo "  ✅ $WSLCONFIG (copiado, no symlink)"
fi

# ── Directorios ───────────────────────────────────────────────────────────────
echo ""
echo "📁 Creating project directories..."
mkdir -p ~/code ~/scripts
echo "  ✅ ~/code"
echo "  ✅ ~/scripts"

# ── Claude Code ───────────────────────────────────────────────────────────────
echo ""
echo "🤖 Checking Claude Code..."
mkdir -p ~/.claude
if ! command -v claude &>/dev/null; then
  echo "  ⚡ Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
else
  echo "  ✅ Claude Code already installed: $(claude --version 2>/dev/null || echo 'ok')"
fi

# ── Node.js ───────────────────────────────────────────────────────────────────
echo ""
echo "🟢 Checking Node.js..."
if ! command -v node &>/dev/null; then
  echo "  ⚡ Installing Node.js 20..."
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo "  ✅ Node.js: $(node --version)"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "✅ Done! Run: source ~/.bashrc"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.gitconfig → add your real email"
echo "  2. Edit ~/.claude/CLAUDE.md → fill in your current project"
echo "  3. Push this repo to GitHub: git remote add origin <url>"
