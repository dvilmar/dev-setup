#!/usr/bin/env bash

echo "DEV SETUP CHECK"
echo "==============="

fail=0

ok()   { echo "  OK   $1"; }
warn() { echo "  WARN $1"; }
fail() { echo "  FAIL $1"; fail=1; }

check_cmd() {
  local cmd="$1"
  local label="${2:-$1}"
  if command -v "$cmd" &>/dev/null; then
    ok "$label: $($cmd --version 2>/dev/null | head -n 1)"
  else
    fail "$label not found"
  fi
}

# ── System tools ──────────────────────────────────────────────────────────────
echo ""
echo "SYSTEM TOOLS"
check_cmd git
check_cmd curl
check_cmd wget
check_cmd jq
check_cmd fzf
check_cmd rg "ripgrep"

# ── Languages ─────────────────────────────────────────────────────────────────
echo ""
echo "LANGUAGES"
check_cmd python3
check_cmd node
check_cmd npm

# ── Global tools ──────────────────────────────────────────────────────────────
echo ""
echo "GLOBAL TOOLS"
check_cmd claude "Claude Code"
if command -v cursor &>/dev/null; then
  ok "cursor CLI"
elif command -v code &>/dev/null; then
  warn "cursor CLI not found, 'code' available (run: Shell Command: Install cursor command in PATH)"
else
  fail "cursor/code CLI not found"
fi

# ── Dotfiles ──────────────────────────────────────────────────────────────────
echo ""
echo "DOTFILES"
[ -L "$HOME/.bashrc" ]            && ok ".bashrc (symlink)"     || { [ -f "$HOME/.bashrc" ] && warn ".bashrc (not a symlink)" || fail ".bashrc missing"; }
[ -L "$HOME/.gitconfig" ]         && ok ".gitconfig (symlink)"  || { [ -f "$HOME/.gitconfig" ] && warn ".gitconfig (not a symlink)" || fail ".gitconfig missing"; }
[ -L "$HOME/.claude/CLAUDE.md" ]  && ok "CLAUDE.md (symlink)"   || { [ -f "$HOME/.claude/CLAUDE.md" ] && warn "CLAUDE.md (not a symlink)" || fail "CLAUDE.md missing"; }
[ -f "/mnt/c/Users/$(ls /mnt/c/Users 2>/dev/null | grep -vE '^(All Users|Default|Default User|Public|desktop\.ini)$' | head -1)/.wslconfig" ] \
  && ok ".wslconfig (Windows)" || warn ".wslconfig not found in Windows home"

# ── MCPs ──────────────────────────────────────────────────────────────────────
echo ""
echo "MCP SERVERS"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if [ -f "$CLAUDE_SETTINGS" ]; then
  for mcp in filesystem docker vercel google-drive supabase; do
    if jq -e ".mcpServers.\"$mcp\"" "$CLAUDE_SETTINGS" &>/dev/null; then
      ok "$mcp configured"
    else
      warn "$mcp not in settings.json (run install/mcps.sh)"
    fi
  done
else
  fail "~/.claude/settings.json not found"
fi

# ── Secrets ───────────────────────────────────────────────────────────────────
echo ""
echo "SECRETS"
[ -f "$HOME/.env.secrets" ] && ok ".env.secrets exists" || warn ".env.secrets missing (copy from .env.example)"
[ -n "$VERCEL_TOKEN" ]          && ok "VERCEL_TOKEN set"         || warn "VERCEL_TOKEN not set"
[ -n "$SUPABASE_URL" ]          && ok "SUPABASE_URL set"          || warn "SUPABASE_URL not set"
[ -n "$SUPABASE_SERVICE_KEY" ]  && ok "SUPABASE_SERVICE_KEY set"  || warn "SUPABASE_SERVICE_KEY not set"

# ── Skills ────────────────────────────────────────────────────────────────────
echo ""
echo "CURSOR SKILLS"
SKILLS_DIR="$HOME/.cursor/skills-cursor"
expected="babysit canvas create-hook create-rule create-skill create-subagent loop migrate-to-skills sdk shell split-to-prs statusline update-cli-config update-cursor-settings"
for skill in $expected; do
  [ -f "$SKILLS_DIR/$skill/SKILL.md" ] && ok "$skill" || warn "$skill missing (run install/skills.sh)"
done

# ── Result ────────────────────────────────────────────────────────────────────
echo ""
if [ $fail -eq 0 ]; then
  echo "ALL GOOD"
else
  echo "FAILURES DETECTED — check output above"
fi

exit $fail
