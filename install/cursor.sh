#!/usr/bin/env bash
set -e

echo "CURSOR EXTENSIONS"

FILE="$HOME/dev-setup/config/cursor/extensions.txt"

if [ ! -f "$FILE" ]; then
  echo "No extensions file found: $FILE"
  exit 0
fi

# Cursor tiene su propio CLI; code es el fallback si solo está VS Code
if command -v cursor &>/dev/null; then
  CLI="cursor"
elif command -v code &>/dev/null; then
  CLI="code"
else
  echo "Neither 'cursor' nor 'code' CLI found — install Cursor and enable shell command"
  echo "  Cursor → Command Palette → 'Shell Command: Install cursor command in PATH'"
  exit 1
fi

echo "Using CLI: $CLI"

while IFS= read -r ext; do
  [ -z "$ext" ] && continue
  echo "  Installing: $ext"
  "$CLI" --install-extension "$ext" --force 2>/dev/null || echo "    (failed: $ext)"
done < "$FILE"

echo "Cursor extensions installed"
