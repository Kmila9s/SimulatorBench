#!/usr/bin/env bash
# Installs GHDL + GTKWave via Homebrew (macOS). See HANDOFF §2.
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "ERROR: Homebrew not found. Install from https://brew.sh first." >&2
  exit 1
fi

echo "[install-deps] brew update"
brew update

for pkg in ghdl gtkwave; do
  if brew list --formula | grep -q "^${pkg}\$"; then
    echo "[install-deps] $pkg already installed"
  else
    echo "[install-deps] installing $pkg"
    brew install "$pkg"
  fi
done

echo
echo "[install-deps] versions:"
ghdl --version | head -1
gtkwave --version 2>&1 | head -1 || true
echo
echo "[install-deps] done. Run: dotnet run --project SimulatorBench -- verify"
