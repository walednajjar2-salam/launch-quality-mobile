# Launch Quality LLC — Railway Deployment

## Quick deploy

1. Push this folder to GitHub: `walednajjar2-salam/jawdah-cloud-v47`
2. Railway → **New Project** → **Deploy from GitHub**
3. Select the repo and wait for build
4. Add variables (see below)
5. **Settings → Networking → Generate Domain**
6. Open `https://YOUR-APP.up.railway.app/api/health`

## Required variables

| Variable | Value |
|----------|-------|
| `JAWDAH_HOST` | `0.0.0.0` |
| `JAWDAH_DATA_DIR` | `/app/data` |

Railway sets `PORT` automatically — do not override it.

## Persistent database (recommended)

Volume **jawda-al-intilaqa-volume** is attached to the backend service:

| Setting | Value |
|---------|-------|
| Mount path | `/app/data` |
| SQLite file | `/app/data/jawdah.sqlite3` |
| Backups | `/app/data/backups/` |

Configured in `railway.toml`:

```toml
[[deploy.mounts]]
volumeName = "jawda-al-intilaqa-volume"
mountPath = "/app/data"
```

To recreate via Railway GraphQL (project token):

```bash
curl -X POST https://backboard.railway.com/graphql/v2 \
  -H "Project-Access-Token: $RAILWAY_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query":"mutation { volumeCreate(input: { projectId: \"PROJECT_ID\", environmentId: \"ENV_ID\", serviceId: \"SERVICE_ID\", mountPath: \"/app/data\" }) { id name } }"}'
```

## Unified production URL

| Service | URL |
|---------|-----|
| Landing | https://jawda-al-intilaqa-production.up.railway.app/ |
| ERP | https://jawda-al-intilaqa-production.up.railway.app/app.html |
| API | https://jawda-al-intilaqa-production.up.railway.app/api |
| Flutter app | uses same API via `lib/config/api_config.dart` |

Legacy v72 URL (`web-production-08d73.up.railway.app`) is a separate Railway project — retire it from the old project's dashboard when ready.

## Persistent database (legacy section)

## Automatic daily backup (enabled by default)

Backups are stored on the same persistent volume:

- Directory: `/app/data/backups/daily/`
- Contents per archive: `jawdah.sqlite3`, `export.json`, `company_settings.json`, `manifest.json`
- Schedule: daily around **03:00 Asia/Muscat**
- Retention: **14 days** (older archives are removed automatically)

Optional variables:

| Variable | Default |
|----------|---------|
| `JAWDAH_AUTO_BACKUP` | `1` |
| `JAWDAH_BACKUP_HOUR` | `3` |
| `JAWDAH_BACKUP_RETAIN_DAYS` | `14` |
| `JAWDAH_BACKUP_TZ` | `Asia/Muscat` |

Status API (authenticated): `GET /api/backup/auto`  
Manual run (admin): `POST /api/backup/run`

## Health check

- Path: `/api/health`
- Configured in `railway.toml`

## Login (seed data)

- `admin` — set `ADMIN_PASSWORD` in Railway variables (required for admin login)
- `razan.accounting` / `Jawdeh123`

## Start command

```
python server.py
```

Also defined in `Procfile` and `railway.toml`.
