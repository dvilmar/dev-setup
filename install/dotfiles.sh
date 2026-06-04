#!/usr/bin/env bash
set -e

echo "Linking dotfiles..."

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link() {
  local src="$DOTFILES/$1"
  local dest="$HOME/$2"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "  ackup $dest"
  fi

  ln -sfn "$src" "$dest"
  echo "  $dest"
}

link ".bashrc" ".bashrc"
link ".gitconfig" ".gitconfig"
link ".gitignore_global" ".gitignore_global"
link "config/claude/CLAUDE.md" ".claude/CLAUDE.md"

mkdir -p ~/code ~/scripts ~/.cursor/skills-cursor

echo "Dotfiles linked"
