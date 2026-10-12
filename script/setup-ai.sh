#!/bin/bash
set -euo pipefail

# Install AI development tools using mise-managed Node.js.

if ! command -v npm >/dev/null 2>&1; then
  echo "npm saknas. Installera Node.js via mise först." >&2
  exit 1
fi

if ! command -v pi >/dev/null 2>&1; then
  npm install -g @mariozechner/pi-coding-agent
else
  echo "Pi är redan installerat."
fi

echo "AI development tools configured."

# Configure Herdr integration with Pi.
if command -v herdr >/dev/null 2>&1; then
  herdr integration install pi
fi