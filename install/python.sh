#!/usr/bin/env bash
set -e

echo "Setting up Python..."

sudo apt update

sudo apt install -y \
python3 \
python3-pip \
python3-venv \
pipx

# pipx configuración recomendada
python3 -m pipx ensurepath || true

echo "Python ready"
