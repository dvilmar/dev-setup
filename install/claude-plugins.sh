#!/usr/bin/env bash
set -e

echo "Claude Code plugins setup..."

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
SETTINGS_CONFIG="$ROOT/config/claude/settings.json"

if ! command -v jq &>/dev/null; then
  echo "jq required — run install/system.sh first"
  exit 1
fi

# Merge settings (tema, effortLevel, permisos, plugins) sobre los existentes
if [ -f "$CLAUDE_SETTINGS" ]; then
  echo "Applying Claude settings..."
  tmp=$(mktemp)
  jq -s '.[0] * .[1]' "$CLAUDE_SETTINGS" "$SETTINGS_CONFIG" > "$tmp"
  mv "$tmp" "$CLAUDE_SETTINGS"
  echo "  Settings applied"
else
  mkdir -p "$HOME/.claude"
  cp "$SETTINGS_CONFIG" "$CLAUDE_SETTINGS"
  echo "  Settings created"
fi

echo ""
echo "Plugin Vercel: install manually from Claude Code UI"
echo "  1. Open Claude Code"
echo "  2. /marketplace → search 'vercel' → Install"
echo "  Or: claude.ai/claude-code → Plugins"
echo ""
echo "Plugins configured"
