#!/usr/bin/env bash
set -e

# Sincroniza el estado actual de la máquina → repo (flujo inverso a bootstrap.sh)
# Ejecutar antes de git push para capturar cambios locales.

echo "DEV SETUP SYNC (machine → repo)"
echo "================================"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

confirm() {
  read -p "$1 (y/n): " choice
  case "$choice" in y|Y) return 0 ;; *) return 1 ;; esac
}

# ── Cursor skills ─────────────────────────────────────────────────────────────
echo ""
echo "CURSOR SKILLS"
if confirm "Sync skills from ~/.cursor/skills-cursor/ → config/cursor/skills/?"; then
  SKILLS_SRC="$HOME/.cursor/skills-cursor"
  SKILLS_DEST="$ROOT/config/cursor/skills"
  mkdir -p "$SKILLS_DEST"
  for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -f "$skill_dir/SKILL.md" ]; then
      mkdir -p "$SKILLS_DEST/$skill_name"
      cp "$skill_dir/SKILL.md" "$SKILLS_DEST/$skill_name/SKILL.md"
      echo "  $skill_name"
    fi
  done
  echo "  Skills synced"
fi

# ── Cursor settings (Windows → repo) ─────────────────────────────────────────
echo ""
echo "CURSOR SETTINGS"
WIN_USER=$(ls /mnt/c/Users/ 2>/dev/null | grep -vE "^(All Users|Default|Default User|Public|desktop\.ini)$" | head -1)
WIN_SETTINGS="/mnt/c/Users/$WIN_USER/AppData/Roaming/Cursor/User/settings.json"
if [ -f "$WIN_SETTINGS" ]; then
  if confirm "Sync Cursor settings from Windows → config/cursor/settings.json?"; then
    cp "$WIN_SETTINGS" "$ROOT/config/cursor/settings.json"
    echo "  settings.json synced"
  fi
else
  echo "  Cursor settings not found — skipping"
fi

# ── Cursor extensions ─────────────────────────────────────────────────────────
echo ""
echo "CURSOR EXTENSIONS"
if confirm "Sync installed extensions → config/cursor/extensions.txt?"; then
  if command -v cursor &>/dev/null; then
    CLI="cursor"
  elif command -v code &>/dev/null; then
    CLI="code"
  else
    echo "  cursor/code CLI not found — skipping"
    CLI=""
  fi
  if [ -n "$CLI" ]; then
    "$CLI" --list-extensions > "$ROOT/config/cursor/extensions.txt"
    echo "  extensions.txt updated ($(wc -l < "$ROOT/config/cursor/extensions.txt") extensions)"
  fi
fi

# ── Claude CLAUDE.md ──────────────────────────────────────────────────────────
echo ""
echo "CLAUDE.md"
if confirm "Sync ~/.claude/CLAUDE.md → config/claude/CLAUDE.md?"; then
  if [ -L "$HOME/.claude/CLAUDE.md" ]; then
    echo "  CLAUDE.md is a symlink to repo — already in sync"
  elif [ -f "$HOME/.claude/CLAUDE.md" ]; then
    cp "$HOME/.claude/CLAUDE.md" "$ROOT/config/claude/CLAUDE.md"
    echo "  CLAUDE.md synced"
  else
    echo "  ~/.claude/CLAUDE.md not found — skipping"
  fi
fi

# ── Git status ────────────────────────────────────────────────────────────────
echo ""
echo "GIT STATUS"
git -C "$ROOT" status --short

echo ""
echo "Done. Review changes above and run: git add -p && git commit && git push"
