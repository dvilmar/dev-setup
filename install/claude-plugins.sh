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

# Inyectar hook de sesión con ruta real (no portable en JSON estático)
TAP_JS="$HOME/.claude/.claude-manager/session-start-tap.js"
if [ -f "$TAP_JS" ]; then
  echo "Injecting SessionStart hook..."
  NODE_BIN=$(command -v node 2>/dev/null || echo "node")
  tmp=$(mktemp)
  jq --arg cmd "$NODE_BIN \"$TAP_JS\"" '
    .hooks.SessionStart = [{"matcher": "", "hooks": [{"type": "command", "command": $cmd}]}]
  ' "$CLAUDE_SETTINGS" > "$tmp"
  mv "$tmp" "$CLAUDE_SETTINGS"
  echo "  Hook injected: $NODE_BIN $TAP_JS"
else
  echo "  session-start-tap.js not found — hook skipped (se crea al iniciar Claude Code)"
fi

echo ""
echo "Plugin Vercel: instalar manualmente desde Claude Code"
echo "  /marketplace → buscar 'vercel' → Install"
echo ""
echo "Plugins configured"
