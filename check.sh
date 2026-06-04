#!/usr/bin/env bash
set -e

echo "DEV SETUP CHECK"
echo "==============="

fail=0

check() {
  if command -v "$1" &>/dev/null; then
    echo "OK $1: $($1 --version 2>/dev/null | head -n 1)"
  else
    echo "FAIL $1 not found"
    fail=1
  fi
}

echo ""
echo "SYSTEM TOOLS"
check git
check curl
check wget

echo ""
echo "DEV TOOLS"
check fzf
check rg
check jq

echo ""
echo "LANGUAGES"
check python3
check node
check npm

echo ""
echo "GLOBAL TOOLS"
check claude

echo ""
echo "CONFIG FILES"

[ -f "$HOME/.bashrc" ] && echo "OK .bashrc" || { echo "FAIL .bashrc"; fail=1; }
[ -f "$HOME/.gitconfig" ] && echo "OK .gitconfig" || { echo "FAIL .gitconfig"; fail=1; }

echo ""
if [ $fail -eq 0 ]; then
  echo "ALL GOOD"
else
  echo "SOME FAILURES DETECTED"
fi

exit $fail
