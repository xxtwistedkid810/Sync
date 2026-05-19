# Sync

VPS auto-sync from GitHub every **5 seconds** into `/var/www`.

## Install on server (once)

```bash
sudo bash /var/www/install-sync.sh
```

## Manual pull

```bash
cd /var/www && git pull origin main
```
