#!/usr/bin/env bash
set -e

echo "MCP setup..."

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MCPS_CONFIG="$ROOT/config/claude/mcps.json"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

if ! command -v jq &>/dev/null; then
  echo "jq required — run install/system.sh first"
  exit 1
fi

# Pull docker/mcp-server image if docker is available
if command -v docker &>/dev/null; then
  echo "Pulling docker/mcp-server..."
  docker pull docker/mcp-server 2>/dev/null || echo "  (skipped — Docker not running)"
fi

# Merge mcpServers into ~/.claude/settings.json
if [ -f "$CLAUDE_SETTINGS" ]; then
  echo "Merging MCP config into $CLAUDE_SETTINGS..."
  tmp=$(mktemp)
  jq -s '.[0] * {"mcpServers": .[1].mcpServers}' "$CLAUDE_SETTINGS" "$MCPS_CONFIG" > "$tmp"
  mv "$tmp" "$CLAUDE_SETTINGS"
  echo "  MCPs merged"
else
  echo "  $CLAUDE_SETTINGS not found — creating from MCP config"
  mkdir -p "$HOME/.claude"
  cp "$MCPS_CONFIG" "$CLAUDE_SETTINGS"
fi

# Warn about required secrets
echo ""
echo "Required env vars (add to ~/.env.secrets):"
echo "  VERCEL_TOKEN     — https://vercel.com/account/tokens"
echo "  SUPABASE_URL     — Supabase project URL"
echo "  SUPABASE_SERVICE_KEY — Supabase service role key"
echo ""
echo "MCPs configured: filesystem, docker, vercel, google-drive, supabase"
