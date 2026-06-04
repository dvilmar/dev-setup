#!/usr/bin/env bash
set -e

echo "CURSOR SYNC"

FILE="$HOME/dev-setup/config/cursor/extensions.txt"

if [ ! -f "$FILE" ]; then
  echo "No extensions file found: $FILE"
  exit 0
fi

if ! command -v code &>/dev/null; then
  echo "VS Code/Cursor CLI not found (code command missing)"
  exit 0
fi

while read -r ext; do
  echo "Installing: $ext"
  code --install-extension "$ext"
done < "$FILE"

echo "Cursor extensions installed"
