#!/usr/bin/env bash
set -e

echo "NODE SETUP (NVM)"

export NVM_DIR="$HOME/.nvm"

if [ ! -d "$NVM_DIR" ]; then
  echo "Installing NVM..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

echo "Node installed: $(node -v)"

# persist in bashrc
if ! grep -q "NVM_DIR" "$HOME/.bashrc"; then
  cat >> "$HOME/.bashrc" << 'EOF'

# NVM (auto-added by dev-setup)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF
fi
