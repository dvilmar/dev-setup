#!/usr/bin/env bash
set -e

echo "Cursor settings sync..."

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURSOR_SRC="$ROOT/config/cursor/settings.json"

WIN_USER=$(ls /mnt/c/Users/ 2>/dev/null | grep -vE "^(All Users|Default|Default User|Public|desktop\.ini)$" | head -1)

if [ -z "$WIN_USER" ]; then
  echo "Could not detect Windows user — skipping"
  exit 0
fi

WIN_CURSOR_DIR="/mnt/c/Users/$WIN_USER/AppData/Roaming/Cursor/User"
WIN_SETTINGS="$WIN_CURSOR_DIR/settings.json"

if [ ! -d "$WIN_CURSOR_DIR" ]; then
  echo "Cursor not installed on Windows — skipping"
  exit 0
fi

if ! command -v jq &>/dev/null; then
  echo "jq required — run install/system.sh first"
  exit 1
fi

if [ -f "$WIN_SETTINGS" ]; then
  # Merge: settings existentes del usuario + settings del repo (repo tiene prioridad)
  cp "$WIN_SETTINGS" "$WIN_SETTINGS.bak"
  tmp=$(mktemp)
  jq -s '.[0] * .[1]' "$WIN_SETTINGS" "$CURSOR_SRC" > "$tmp"
  cp "$tmp" "$WIN_SETTINGS"
  echo "  Merged settings (backup → settings.json.bak)"
else
  cp "$CURSOR_SRC" "$WIN_SETTINGS"
  echo "  settings.json created"
fi

echo "  → $WIN_SETTINGS"
echo "Cursor settings synced"
