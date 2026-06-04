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

# Advertir sobre secrets faltantes
missing=0
[ -z "$VERCEL_TOKEN" ]          && echo "  WARN VERCEL_TOKEN not set"       && missing=1
[ -z "$SUPABASE_URL" ]          && echo "  WARN SUPABASE_URL not set"        && missing=1
[ -z "$SUPABASE_SERVICE_KEY" ]  && echo "  WARN SUPABASE_SERVICE_KEY not set" && missing=1
if [ $missing -eq 1 ]; then
  echo ""
  echo "  Set missing vars in ~/.env.secrets and re-run, or MCPs fallarán al arrancar."
  echo ""
fi

# Pull docker/mcp-server image si docker está disponible
if command -v docker &>/dev/null; then
  echo "Pulling docker/mcp-server..."
  docker pull docker/mcp-server 2>/dev/null || echo "  (skipped — Docker not running)"
fi

# Merge SOLO los mcpServers nuevos sobre los existentes (no sobreescribe todo)
if [ -f "$CLAUDE_SETTINGS" ]; then
  echo "Merging MCP config into $CLAUDE_SETTINGS..."
  tmp=$(mktemp)
  # Deep merge: mcpServers existentes + nuevos (los nuevos tienen prioridad por clave)
  jq -s '
    .[0] + {
      mcpServers: (
        (.[0].mcpServers // {}) + .[1].mcpServers
      )
    }
  ' "$CLAUDE_SETTINGS" "$MCPS_CONFIG" > "$tmp"
  mv "$tmp" "$CLAUDE_SETTINGS"
  echo "  MCPs merged (existing MCPs preserved)"
else
  echo "  $CLAUDE_SETTINGS not found — creating"
  mkdir -p "$HOME/.claude"
  cp "$MCPS_CONFIG" "$CLAUDE_SETTINGS"
fi

echo "MCPs configured: filesystem, docker, vercel, google-drive, supabase"
