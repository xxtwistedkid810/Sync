# Sync

VPS auto-sync from GitHub every **5 seconds** into `/var/www`.

## First-time VPS setup

One command as **root**:

```bash
systemctl disable --now larper-sync.timer 2>/dev/null; rm -f /etc/systemd/system/larper-sync.{service,timer}; rm -rf /var/www/Sync; cd /tmp && rm -rf sync-bootstrap && git clone -q https://github.com/xxtwistedkid810/Sync.git sync-bootstrap && cd sync-bootstrap && chmod +x install-sync.sh sync.sh && bash install-sync.sh && systemctl status sync.timer --no-pager
```

## After that

```bash
systemctl status sync.timer
journalctl -u sync.service -f
```
