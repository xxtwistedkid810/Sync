# larper.cc-auth

Deployment target for **larper.cc** (VPS auto-sync from this repo).

This repository is intentionally minimal. Application code is deployed elsewhere or added later.

## VPS auto-sync (every 5 seconds)

On the server (once):

```bash
sudo bash /var/www/larper.cc-auth/deploy/install-sync.sh
```

Manual pull:

```bash
cd /var/www/larper.cc-auth && git pull origin main
```
