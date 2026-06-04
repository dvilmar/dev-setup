#!/usr/bin/env bash
set -e

echo "Linking dotfiles..."

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link() {
  local src="$DOTFILES/$1"
  local dest="$HOME/$2"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "  Backup $dest"
  fi

  ln -sfn "$src" "$dest"
  echo "  $dest"
}

link ".bashrc" ".bashrc"
link ".gitconfig" ".gitconfig"
link ".gitignore_global" ".gitignore_global"

mkdir -p "$HOME/.claude"
link "config/claude/CLAUDE.md" ".claude/CLAUDE.md"

# .wslconfig va al home de Windows, no de WSL
WIN_USER=$(ls /mnt/c/Users/ 2>/dev/null | grep -vE "^(All Users|Default|Default User|Public|desktop\.ini)$" | head -1)
if [ -n "$WIN_USER" ]; then
  cp "$DOTFILES/.wslconfig" "/mnt/c/Users/$WIN_USER/.wslconfig"
  echo "  /mnt/c/Users/$WIN_USER/.wslconfig"
fi

mkdir -p ~/code ~/scripts ~/.cursor/skills-cursor

echo "Dotfiles linked"
