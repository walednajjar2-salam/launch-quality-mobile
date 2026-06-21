# Launch Quality — Flutter Native

One Flutter app targeting Android, Windows, and Chrome (web). UI is dark/luxury, Arabic RTL.
See `README.md` and `ROADMAP.md` for product structure and routes.

## Cursor Cloud specific instructions

### Environment
- Flutter SDK (stable, 3.44.x / Dart 3.12.x) is installed at `/home/ubuntu/flutter` and added to `PATH` via `~/.bashrc`. The update script runs `flutter pub get` on startup.
- The app talks to a live production backend: `https://web-production-08d73.up.railway.app/api` (see `lib/config/api_config.dart`). Outbound network access is required for login/dashboard data. Override with `--dart-define=API_BASE_URL=...` if needed.
- Test staff logins (production): `Najjar` / `Najjar2026`, `owner` / `owner2015` (see `README.md`).

### Running (web is the practical target on this Linux VM)
- Standard commands: `flutter analyze` (lint), `flutter test`, `flutter run -d chrome` / `-d linux`.
- To serve the web app for the in-VM browser, bind to a fixed port/host (Chrome is at `/usr/local/bin/google-chrome`):
  `flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0`
  First compile takes ~20s; it then prints "is being served at http://0.0.0.0:8080". Open `http://localhost:8080/`.
- Routes: `/` staff login, `/staff` dashboard, `/portal?token=XXX` tenant portal.

### Notes
- `flutter analyze` reports 2 pre-existing non-error lints (a deprecation `info` and an unused-import `warning` in `test/widget_test.dart`); there are no analyzer errors.
