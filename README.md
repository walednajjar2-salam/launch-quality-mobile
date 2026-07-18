# Launch Quality — Flutter Native

**One app** for **iPhone + Android + Windows + Chrome** · luxury dark UI · Railway API · no WebView.

Full structure and roadmap: **[ROADMAP.md](ROADMAP.md)**

## Quick start

```bash
cd launch-quality-mobile
flutter pub get

flutter run -d chrome      # test in browser
flutter run -d windows     # desktop
flutter run -d android     # Android phone
flutter run -d ios         # iPhone / Simulator (macOS + Xcode)
```

## API

`https://jawda-al-intilaqa-production.up.railway.app/api`

| User | Password |
|------|----------|
| waleed.najjar | Waleed2026! |

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
# iPhone / iPad (macOS only)
chmod +x scripts/build-ios.sh
./scripts/build-ios.sh
# ثم: افتح ios/Runner.xcworkspace في Xcode → Archive
```

## Deploy (Railway — Flutter Web)

انظر **[RAILWAY.md](RAILWAY.md)** — Dockerfile جاهز للنشر على Railway.
## Features

- Dark luxury theme · glass cards · 28px · RTL Arabic
- iPhone-ready: Arabic display name, dark launch screen, Safe Area / notch, haptics
- Dashboard KPIs · Projects · Staff · Finance charts
- Maintenance · Payment proofs
- Tenant portal via `portal_token`
- Responsive: phone bottom nav · desktop navigation rail

No backend changes required.
