# Launch Quality — Flutter Native

**One app** for **Android + Windows + Chrome** · luxury dark UI · Railway API · no WebView.

Full structure and roadmap: **[ROADMAP.md](ROADMAP.md)**

## Quick start

```bash
cd launch-quality-mobile
flutter pub get

flutter run -d chrome      # test in browser
flutter run -d windows     # desktop
flutter run -d android     # phone
```

## API

`https://web-production-08d73.up.railway.app/api`

| User | Password |
|------|----------|
| Najjar | Najjar2026 |
| owner | owner2015 |

## Routes

| Path | Purpose |
|------|---------|
| `/` | Staff login (`POST /login`, `GET /me`) |
| `/staff` | Dashboard shell |
| `/portal?token=XXX` | Tenant portal |

## Build

```powershell
.\scripts\build-apk.ps1
.\scripts\build-windows.ps1
```

```bash
./scripts/build-ios.sh
```

## Features

- Dark luxury theme · glass cards · 28px · RTL Arabic
- Dashboard KPIs · Projects · Staff · Finance charts
- Maintenance · Payment proofs
- Tenant portal via `portal_token`
- Responsive: phone bottom nav · desktop navigation rail

No backend changes required.
