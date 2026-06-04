#!/usr/bin/env bash
set -e

echo " System setup starting..."

sudo apt update
sudo apt upgrade -y

echo "Installing base packages..."

sudo apt install -y \
git \
curl \
wget \
unzip \
zip \
build-essential \
jq \
ripgrep \
fzf \
htop \
ca-certificates \
gnupg \
lsb-release

echo "System tools installed"
