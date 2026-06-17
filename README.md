# Launch Quality Mobile — Staff App (Phase 2)

Flutter staff dashboard for **Jawdah Cloud** on Railway.

## API

Production default:

`https://web-production-08d73.up.railway.app/api`

Override:

```bash
flutter run -t lib/main.dart --dart-define=API_BASE_URL=https://your-host/api
```

## Run

```bash
cd launch-quality-mobile
flutter pub get
flutter run -t lib/main.dart
```

## Routes

| Path | Screen |
|------|--------|
| `/` | Login |
| `/staff` | StaffShell (bottom nav modules) |

Portal is **web-only** (`portal.html` + `portal_token`). `lib/main_portal.dart` is deprecated.

## Staff modules

- **Dashboard** — KPIs + executive decisions from `/api/bootstrap`
- **Properties** — list/search
- **Clients** — list/search + balance
- **Contracts** — list/search
- **Invoices** — filters + collect payment (`/api/pay_invoice`)
- **Maintenance** — open/tenant tickets + status updates
- **Payment proofs** — pending portal proofs approve/reject

Modules hide automatically based on `/api/me` permissions.

## Test users (production)

| User | Password |
|------|----------|
| operations | 1234 |
| maintenance | 1234 |
| razan.accounting | Jawdeh123 |

## Notes

- Token stored in `SharedPreferences` key `jawdah_cloud_token` (same as web)
- No DB schema / backend changes required
- Deep link intents removed from Android manifest (staff-only app)
