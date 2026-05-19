# Sync

VPS auto-sync from GitHub every **5 seconds** into `/var/www`.

## First-time VPS setup

Copy-paste on the server as **root**:

```bash
systemctl disable --now larper-sync.timer 2>/dev/null || true
rm -rf /var/www/Sync

cd /tmp
rm -rf sync-bootstrap
git clone https://github.com/xxtwistedkid810/Sync.git sync-bootstrap
cd sync-bootstrap
chmod +x install-sync.sh sync.sh
bash install-sync.sh
```

## After that

```bash
systemctl status sync.timer
journalctl -u sync.service -f
```
