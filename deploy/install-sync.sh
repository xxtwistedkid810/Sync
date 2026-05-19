#!/usr/bin/env bash
# Install 5-second git sync timer (run once on VPS as root).

set -euo pipefail

SITE_DIR="${SITE_DIR:-/var/www/Sync}"
REPO_URL="${REPO_URL:-https://github.com/xxtwistedkid810/Sync.git}"
BRANCH="${BRANCH:-main}"

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root: sudo bash deploy/install-sync.sh"
    exit 1
fi

# Remove old larper.cc-auth timer if present
systemctl disable --now larper-sync.timer 2>/dev/null || true
rm -f /etc/systemd/system/larper-sync.service /etc/systemd/system/larper-sync.timer

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

chmod +x "$SITE_DIR/deploy/sync.sh"
chmod +x "$SITE_DIR/deploy/install-sync.sh"

cp "$SITE_DIR/deploy/sync.service" /etc/systemd/system/sync.service
cp "$SITE_DIR/deploy/sync.timer" /etc/systemd/system/sync.timer

systemctl daemon-reload
systemctl enable --now sync.timer
systemctl start sync.service

echo "Installed. Status:"
systemctl status sync.timer --no-pager || true
echo "Sync runs every 5 seconds."
