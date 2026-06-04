#!/usr/bin/env bash
set -e

echo "DEV SETUP BOOTSTRAP (SAFE MODE)"
echo "================================"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x "$ROOT/install/"*.sh

confirm() {
  read -p "$1 (y/n): " choice
  case "$choice" in
    y|Y ) return 0 ;;
    * ) return 1 ;;
  esac
}

echo ""
echo "SYSTEM"
if confirm "Install system tools?"; then
  bash "$ROOT/install/system.sh"
fi

echo ""
echo "PYTHON"
if confirm "Install Python?"; then
  bash "$ROOT/install/python.sh"
fi

echo ""
echo "NODE (NVM)"
if confirm "Install Node (NVM)?"; then
  bash "$ROOT/install/node.sh"
fi

echo ""
echo "CLAUDE CODE"
if confirm "Install Claude Code?"; then
  bash "$ROOT/install/claude.sh"
fi

echo ""
echo "DOTFILES"
if confirm "Link dotfiles?"; then
  bash "$ROOT/install/dotfiles.sh"
fi

echo ""
echo "CLAUDE PLUGINS"
if confirm "Install Claude Code plugins & apply settings?"; then
  bash "$ROOT/install/claude-plugins.sh"
fi

echo ""
echo "MCPs"
if confirm "Configure MCP servers (filesystem, docker, vercel, google-drive, supabase)?"; then
  bash "$ROOT/install/mcps.sh"
fi

echo ""
echo "CURSOR SKILLS"
if confirm "Install Cursor skills?"; then
  bash "$ROOT/install/skills.sh"
fi

echo ""
echo "CURSOR SETTINGS"
if confirm "Sync Cursor settings to Windows?"; then
  bash "$ROOT/install/cursor-settings.sh"
fi

echo ""
echo "CURSOR EXTENSIONS"
if confirm "Install Cursor extensions?"; then
  bash "$ROOT/install/cursor.sh"
fi

echo ""
echo "DOCKER (INFO ONLY)"
if confirm "Show Docker setup info?"; then
  bash "$ROOT/install/docker.sh"
fi

echo ""
echo "DONE"
echo "Restart terminal or run: source ~/.bashrc"
echo ""
echo "NEXT STEPS:"
echo "  1. Copy .env.example → ~/.env.secrets and fill in tokens"
echo "  2. Add to ~/.bashrc: [ -f ~/.env.secrets ] && source ~/.env.secrets"
echo "  3. Restart Claude Code to pick up MCP servers"
