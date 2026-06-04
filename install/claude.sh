#!/usr/bin/env bash
set -e

echo "CLAUDE SETUP"

# cargar NVM si existe
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
else
  echo "NVM not found. Install Node first."
  exit 1
fi

# comprobar node
if ! command -v node &>/dev/null; then
  echo "Node not found. Run node.sh first."
  exit 1
fi

# comprobar npm
if ! command -v npm &>/dev/null; then
  echo "npm not found"
  exit 1
fi

# comprobar si ya está instalado
if command -v claude &>/dev/null; then
  echo "Claude already installed: $(claude --version 2>/dev/null)"
  exit 0
fi

# instalar
npm install -g @anthropic-ai/claude-code

# verificar instalación
if command -v claude &>/dev/null; then
  echo "Claude installed successfully: $(claude --version)"
else
  echo "Claude installation failed"
  exit 1
fi
