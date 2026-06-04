#!/usr/bin/env bash
set -e

echo "Claude Code plugins setup..."

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

if ! command -v claude &>/dev/null; then
  echo "Claude Code not installed — run install/claude.sh first"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "jq required — run install/system.sh first"
  exit 1
fi

# Apply non-secret settings (theme, effortLevel, permissions, plugins)
SETTINGS_CONFIG="$ROOT/config/claude/settings.json"

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

# Install Vercel plugin via Claude Code marketplace
echo "Installing Vercel plugin..."
claude plugin install vercel 2>/dev/null || echo "  (already installed or run manually: claude plugin install vercel)"

echo "Plugins configured"
