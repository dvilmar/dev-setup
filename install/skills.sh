#!/usr/bin/env bash
set -e

echo "Installing Cursor skills..."

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$ROOT/config/cursor/skills"
SKILLS_DEST="$HOME/.cursor/skills-cursor"

mkdir -p "$SKILLS_DEST"

if [ ! -d "$SKILLS_SRC" ]; then
  echo "No skills found at $SKILLS_SRC"
  exit 0
fi

for skill_dir in "$SKILLS_SRC"/*/; do
  skill_name=$(basename "$skill_dir")
  dest="$SKILLS_DEST/$skill_name"
  mkdir -p "$dest"
  cp "$skill_dir/SKILL.md" "$dest/SKILL.md"
  echo "  $skill_name"
done

echo "Skills installed"
