# AGENTS.md

## Cursor Cloud specific instructions

This is a monorepo with two independent products:

- **Launch Quality** (main): Real-estate/hospitality ERP. A Python stdlib backend
  (`backend/jawdah-cloud-v47/server.py`) serves both the REST API and an Arabic RTL
  web ERP, backed by SQLite. The primary client is a Flutter app (repo root, `lib/`)
  targeting Chrome/Windows/Android/iOS.
- **NAJJAR Auto Ads** (`integrations/najjar-auto-ads/`): a standalone car-classifieds
  platform — Express/TypeScript backend + React/Vite frontend, SQLite by default.

Standard commands live in the READMEs (`README.md`, `backend/jawdah-cloud-v47/README.md`,
`integrations/najjar-auto-ads/README.md`), `QUICK_START.md`, and `SETUP.md`. Notes below
are the non-obvious caveats discovered during setup.

### Toolchain

- Flutter/Dart is NOT a system package. The SDK lives at `$HOME/flutter` and is on
  `PATH` via `~/.bashrc` (`export PATH="$HOME/flutter/bin:$PATH"`). Non-interactive
  shells may not source `~/.bashrc`; call Flutter explicitly with `$HOME/flutter/bin/flutter`
  if `flutter` is not found. Version: Flutter 3.44.6 / Dart 3.12.2.
- Docker is NOT installed. Ignore the `docker compose` paths in the READMEs; run each
  service directly instead (commands below).

### Launch Quality backend (API + web ERP)

- Run from `backend/jawdah-cloud-v47/`: `python3 server.py` (listens on `JAWDAH_PORT`,
  default `8765`). Health: `http://localhost:8765/api/health`. Web ERP: `.../app.html`.
- On a fresh SQLite DB the seeded team credentials (e.g. `Najjar`/`Najjar2026`) do NOT
  work — those are production-only. Set `ADMIN_PASSWORD` (and/or `LQ_ADMIN_PASSWORD`)
  to bootstrap the `admin` user. `owner`/`owner2015` works locally as a test account.
  Set `LQ_ALLOW_DEFAULT_PASSWORDS=1` on a fresh DB to allow the legacy seed users.
- Set `JAWDAH_DATA_DIR=./data` for local dev; set `JAWDAH_AUTO_BACKUP=0` to avoid the
  background backup thread during local testing.
- `requirements.txt` is intentionally empty (stdlib only) — no `pip install` needed.

### Launch Quality Flutter client

- The API base URL is a compile-time define. To hit the local backend, run with
  `--dart-define=API_BASE_URL=http://localhost:8765/api`; otherwise it defaults to the
  production Railway URL in `lib/config/api_config.dart`.
- Web dev server (headless-friendly): `flutter run -d web-server --web-hostname 0.0.0.0
  --web-port 8080 --dart-define=API_BASE_URL=http://localhost:8765/api`. First launch
  compiles for ~20s before "is being served at". Lint/test/build: `flutter analyze`,
  `flutter test`, `flutter build web`.

### NAJJAR Auto Ads

- Backend (`integrations/najjar-auto-ads/backend`): `npm run dev` (port 4000). Requires
  `JWT_SECRET` of at least 16 chars or it throws on auth. No `MONGODB_URI` → auto-falls
  back to SQLite (`NAJJAR_DATA_DIR`). Demo admin: `admin@najjar.om` / `Najjar2026!`.
  Tests: `npm test`.
- Frontend (`integrations/najjar-auto-ads/frontend`): `npm run dev` (Vite on port 3000,
  proxies `/api` → `VITE_API_PROXY`, default `http://127.0.0.1:4000`). Build: `npm run build`.
- The ad-create API requires `make`, `model`, `year`, `price`, `mileage` (not `brand`);
  missing-field errors are returned in Arabic.
