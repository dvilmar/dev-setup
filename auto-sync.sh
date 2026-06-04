#!/usr/bin/env bash
# Auto-sync no-interactivo: copia configs actuales → repo → git push
# Ejecutado por cron cada 24h

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$HOME/.claude/auto-sync.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

log() { echo "[$DATE] $1" | tee -a "$LOG"; }

log "=== auto-sync start ==="

# ── Claude settings ───────────────────────────────────────────────────────────
if [ -f "$HOME/.claude/settings.json" ]; then
  cp "$HOME/.claude/settings.json" "$ROOT/config/claude/settings.json"
  log "settings.json synced"
fi

# CLAUDE.md es symlink al repo → ya está en sync, no hay que copiar

# ── Cursor settings (Windows → repo) ─────────────────────────────────────────
WIN_USER=$(ls /mnt/c/Users/ 2>/dev/null | grep -vE "^(All Users|Default|Default User|Public|desktop\.ini)$" | head -1)
WIN_SETTINGS="/mnt/c/Users/$WIN_USER/AppData/Roaming/Cursor/User/settings.json"
if [ -f "$WIN_SETTINGS" ]; then
  cp "$WIN_SETTINGS" "$ROOT/config/cursor/settings.json"
  log "Cursor settings.json synced"
fi

# ── Cursor skills ─────────────────────────────────────────────────────────────
SKILLS_SRC="$HOME/.cursor/skills-cursor"
SKILLS_DEST="$ROOT/config/cursor/skills"
if [ -d "$SKILLS_SRC" ]; then
  mkdir -p "$SKILLS_DEST"
  for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -f "$skill_dir/SKILL.md" ]; then
      mkdir -p "$SKILLS_DEST/$skill_name"
      cp "$skill_dir/SKILL.md" "$SKILLS_DEST/$skill_name/SKILL.md"
    fi
  done
  log "Cursor skills synced"
fi

# ── Cursor extensions ─────────────────────────────────────────────────────────
for CLI in cursor code; do
  if command -v "$CLI" &>/dev/null; then
    "$CLI" --list-extensions > "$ROOT/config/cursor/extensions.txt" 2>/dev/null && \
      log "Cursor extensions synced ($(wc -l < "$ROOT/config/cursor/extensions.txt") extensions)"
    break
  fi
done

# ── Git: commit y push solo si hay cambios ────────────────────────────────────
cd "$ROOT"

if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "auto-sync: $(date '+%Y-%m-%d %H:%M')"
  git push
  log "git push OK"
else
  log "nothing to commit"
fi

log "=== auto-sync done ==="
