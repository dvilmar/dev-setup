#!/usr/bin/env bash
set -e

echo "Cursor settings sync..."

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURSOR_SRC="$ROOT/config/cursor/settings.json"

# Detect Windows username from /mnt/c/Users
WIN_USER=$(ls /mnt/c/Users/ 2>/dev/null | grep -vE "^(All Users|Default|Default User|Public|desktop\.ini)$" | head -1)

if [ -z "$WIN_USER" ]; then
  echo "Could not detect Windows user — skipping Cursor settings sync"
  exit 0
fi

WIN_CURSOR_DIR="/mnt/c/Users/$WIN_USER/AppData/Roaming/Cursor/User"
WIN_SETTINGS="$WIN_CURSOR_DIR/settings.json"

if [ ! -d "$WIN_CURSOR_DIR" ]; then
  echo "Cursor not installed on Windows — skipping"
  exit 0
fi

if [ -f "$WIN_SETTINGS" ] && [ ! -L "$WIN_SETTINGS" ]; then
  cp "$WIN_SETTINGS" "$WIN_SETTINGS.bak"
  echo "  Backed up existing settings to settings.json.bak"
fi

cp "$CURSOR_SRC" "$WIN_SETTINGS"
echo "  settings.json → $WIN_SETTINGS"
echo "Cursor settings synced"
