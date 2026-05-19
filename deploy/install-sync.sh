#!/usr/bin/env bash
# Install 5-second git sync timer for larper.cc-auth (run once on VPS as root).

set -euo pipefail

SITE_DIR="${SITE_DIR:-/var/www/larper.cc-auth}"
REPO_URL="${REPO_URL:-https://github.com/xxtwistedkid810/larper.cc-auth.git}"
BRANCH="${BRANCH:-main}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root: sudo bash deploy/install-sync.sh"
    exit 1
fi

mkdir -p "$SITE_DIR"
if [ ! -d "$SITE_DIR/.git" ]; then
    git clone -b "$BRANCH" "$REPO_URL" "$SITE_DIR"
else
    cd "$SITE_DIR"
    git remote set-url origin "$REPO_URL" 2>/dev/null || true
    git fetch origin "$BRANCH"
    git reset --hard "origin/$BRANCH"
    git clean -fd
fi

chmod +x "$SITE_DIR/deploy/larper-sync.sh"
chmod +x "$SITE_DIR/deploy/install-sync.sh"

cp "$SITE_DIR/deploy/larper-sync.service" /etc/systemd/system/larper-sync.service
cp "$SITE_DIR/deploy/larper-sync.timer" /etc/systemd/system/larper-sync.timer

systemctl daemon-reload
systemctl enable --now larper-sync.timer
systemctl start larper-sync.service

echo "Installed. Status:"
systemctl status larper-sync.timer --no-pager || true
echo "Next runs every 5 seconds after each sync completes."
