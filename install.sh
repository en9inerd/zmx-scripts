#!/usr/bin/env bash
set -e

REPO="https://raw.githubusercontent.com/en9inerd/zmx-scripts/master"
BIN_DIR="${HOME}/.local/bin"
ZMX_SESS_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zmx-sessionizer"
ZMX_WS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zmx-workspace"

mkdir -p "$BIN_DIR" "$ZMX_SESS_CONF_DIR" "$ZMX_WS_DIR"

curl -fsSL "$REPO/bin/zmx-sessionizer" -o "$BIN_DIR/zmx-sessionizer"
curl -fsSL "$REPO/bin/zmx-workspace"  -o "$BIN_DIR/zmx-workspace"
chmod +x "$BIN_DIR/zmx-sessionizer" "$BIN_DIR/zmx-workspace"
echo "[ok] zmx-sessionizer -> $BIN_DIR"
echo "[ok] zmx-workspace   -> $BIN_DIR"

if [[ ! -f "$ZMX_SESS_CONF_DIR/zmx-sessionizer.conf" ]]; then
    curl -fsSL "$REPO/config/zmx-sessionizer.conf.example" -o "$ZMX_SESS_CONF_DIR/zmx-sessionizer.conf"
    echo "[ok] created $ZMX_SESS_CONF_DIR/zmx-sessionizer.conf"
else
    echo "[skip] zmx-sessionizer.conf already exists"
fi

echo ""
echo "See README.md for ghostty and zshrc setup."
