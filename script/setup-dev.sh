#!/bin/bash
set -euo pipefail

# Docker Buildx
BUILDX="$(brew --prefix docker-buildx)/lib/docker/cli-plugins/docker-buildx"
PLUGIN="$HOME/.docker/cli-plugins/docker-buildx"

mkdir -p "$HOME/.docker/cli-plugins"

if [ ! -e "$PLUGIN" ] && [ ! -L "$PLUGIN" ]; then
    ln -s "$BUILDX" "$PLUGIN"
fi

# DDEV
ddev config global --docker-buildx-version=system

# Colima
if ! colima status >/dev/null 2>&1; then
    colima start --cpu 6 --memory 8 --disk 100
fi

echo "Development environment configured."