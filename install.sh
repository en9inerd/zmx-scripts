#!/usr/bin/env bash
set -e

REPO="https://raw.githubusercontent.com/en9inerd/zmx-scripts/master"
BIN_DIR="${HOME}/.local/bin"
CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zmx-sessionizer"
WORKSPACE_DIR="$CONF_DIR/workspaces"

mkdir -p "$BIN_DIR" "$CONF_DIR" "$WORKSPACE_DIR"

curl -fsSL "$REPO/bin/zmx-sessionizer" -o "$BIN_DIR/zmx-sessionizer"
curl -fsSL "$REPO/bin/zmx-workspace"   -o "$BIN_DIR/zmx-workspace"
chmod +x "$BIN_DIR/zmx-sessionizer" "$BIN_DIR/zmx-workspace"
echo "[ok] zmx-sessionizer -> $BIN_DIR"
echo "[ok] zmx-workspace   -> $BIN_DIR"

if [[ ! -f "$CONF_DIR/zmx-sessionizer.conf" ]]; then
    curl -fsSL "$REPO/config/zmx-sessionizer.conf.example" -o "$CONF_DIR/zmx-sessionizer.conf"
    echo "[ok] created $CONF_DIR/zmx-sessionizer.conf"
else
    echo "[skip] zmx-sessionizer.conf already exists"
fi

echo ""
echo "See https://github.com/en9inerd/zmx-scripts/blob/master/README.md for ghostty and zshrc setup."
