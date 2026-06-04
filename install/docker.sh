#!/usr/bin/env bash
set -e

echo "Docker setup (WSL notes)"

echo "Install Docker Desktop on Windows"
echo "Enable WSL integration in Docker settings"

if command -v docker &>/dev/null; then
  echo  "Docker CLI detected: $(docker --version)"
else
  echo "ocker not found in WSL (expected until Docker Desktop is installed)"
fi
