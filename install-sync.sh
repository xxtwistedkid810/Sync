#!/usr/bin/env bash
# Install 5-second git sync timer (run once on VPS as root).

set -euo pipefail

SITE_DIR="${SITE_DIR:-/var/www}"
REPO_URL="${REPO_URL:-https://github.com/xxtwistedkid810/Sync.git}"
BRANCH="${BRANCH:-main}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root: sudo bash install-sync.sh"
    exit 1
fi

systemctl disable --now larper-sync.timer 2>/dev/null || true
rm -f /etc/systemd/system/larper-sync.service /etc/systemd/system/larper-sync.timer

mkdir -p "$SITE_DIR"
git config --global --add safe.directory "$SITE_DIR" 2>/dev/null || true

install_repo() {
    local tmp
    tmp=$(mktemp -d)
    git clone -b "$BRANCH" "$REPO_URL" "$tmp"
    if [ -d "$SITE_DIR/.git" ]; then
        rm -rf "$SITE_DIR/.git"
    fi
    cp -a "$tmp"/. "$SITE_DIR"/
    rm -rf "$tmp"
}

if [ ! -d "$SITE_DIR/.git" ]; then
    if [ -n "$(ls -A "$SITE_DIR" 2>/dev/null || true)" ]; then
        echo "Initializing git in non-empty $SITE_DIR (old files kept except .git)..."
        install_repo
    else
        git clone -b "$BRANCH" "$REPO_URL" "$SITE_DIR"
    fi
else
    cd "$SITE_DIR"
    git config --global --add safe.directory "$SITE_DIR"
    git remote set-url origin "$REPO_URL" 2>/dev/null || true
    git fetch origin "$BRANCH"
    git reset --hard "origin/$BRANCH"
    git clean -fd
fi

chmod +x "$SITE_DIR/sync.sh"
chmod +x "$SITE_DIR/install-sync.sh"

cp "$SITE_DIR/sync.service" /etc/systemd/system/sync.service
cp "$SITE_DIR/sync.timer" /etc/systemd/system/sync.timer

systemctl daemon-reload
systemctl enable --now sync.timer
systemctl start sync.service

echo "Installed. Status:"
systemctl status sync.timer --no-pager || true
echo "Sync runs every 5 seconds into $SITE_DIR"
