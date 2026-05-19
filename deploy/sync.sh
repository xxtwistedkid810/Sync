#!/usr/bin/env bash
# Pull latest from GitHub (runs every 5s via systemd timer).

set -euo pipefail

SITE_DIR="${SITE_DIR:-/var/www/Sync}"
BRANCH="${BRANCH:-main}"
LOG_TAG="sync"

cd "$SITE_DIR"

git fetch --quiet origin "$BRANCH"
LOCAL=$(git rev-parse "$BRANCH")
REMOTE=$(git rev-parse "origin/$BRANCH")

if [ "$LOCAL" != "$REMOTE" ]; then
    logger -t "$LOG_TAG" "syncing $LOCAL -> $REMOTE"
    git reset --hard "origin/$BRANCH" --quiet
    git clean -fd --quiet
fi
