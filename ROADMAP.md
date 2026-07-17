# Launch Quality Flutter — Structure & Roadmap

## One app · Four platforms

| Platform | Purpose |
|----------|---------|
| **iPhone / iOS** | Staff + Portal on iPhone (Xcode archive / TestFlight) |
| **Android** | Staff + Portal in production |
| **Windows** | Desktop operations dashboard |
| **Chrome** | Fast API/UI testing |

**Entry:** `lib/main.dart` → `LaunchQualityApp`  
**Backend:** `https://web-production-08d73.up.railway.app/api` (no backend changes)

---

## Project structure

```
launch-quality-mobile/
├── assets/logo.png
├── lib/
│   ├── main.dart                      # Single entry
│   ├── app.dart                       # Router + providers
│   ├── config/api_config.dart
│   ├── models/
│   │   ├── app_user.dart              # can() mirrors server permissions
│   │   └── portal_data.dart
│   ├── services/
│   │   ├── api_client.dart            # HTTP + Arabic errors
│   │   ├── auth_service.dart          # POST login + GET me
│   │   ├── bootstrap_service.dart     # GET bootstrap
│   │   └── portal_service.dart        # portal_token APIs
│   ├── state/
│   │   ├── app_state.dart             # Staff session
│   │   └── portal_state.dart          # Tenant session
│   ├── theme/
│   │   ├── brand_colors.dart          # Black + turquoise/gold
│   │   ├── app_theme.dart             # Dark RTL
│   │   └── widgets/
│   │       ├── glass_card.dart        # 28px glassmorphism
│   │       ├── luxury_background.dart # Logo watermark
│   │       └── circular_progress_ring.dart
│   ├── utils/layout_breakpoints.dart  # Phone / desktop
│   └── screens/
│       ├── login_screen.dart
│       ├── staff_shell.dart           # Rail (desktop) / Bottom nav (phone)
│       ├── portal/
│       │   ├── portal_gate_screen.dart
│       │   └── portal_shell.dart
│       └── modules/
│           ├── dashboard_screen.dart
│           ├── projects_screen.dart
│           ├── staff_screen.dart
│           ├── finance_screen.dart    # fl_chart
│           ├── maintenance_screen.dart
│           ├── payment_proofs_screen.dart
│           └── properties/clients/contracts/invoices
├── ios/                               # iPhone / iPad (Xcode)
├── android/                           # APK build
├── windows/                           # Desktop build
├── web/                               # Chrome testing
└── scripts/
    ├── build-apk.ps1
    ├── build-windows.ps1
    └── build-ios.sh
```

---

## Roadmap (implementation status)

| Phase | Task | Status |
|-------|------|--------|
| 1 | Luxury theme (dark, glass, 28px, RTL) | ✅ |
| 2 | API: `POST /login` + `GET /me` + permissions | ✅ |
| 3 | `GET /bootstrap` dashboard KPIs | ✅ |
| 4 | Projects · Staff · Finance screens | ✅ |
| 5 | Maintenance + Payment proofs | ✅ |
| 6 | Portal `portal_token` in same app | ✅ |
| 7 | Responsive shell (phone / desktop) | ✅ |
| 8 | Android + Windows + Web targets | ✅ |
| 9 | Build scripts + README | ✅ |
| 10 | iPhone polish (Safe Area, dark launch, Arabic name, haptics, Podfile) | ✅ |

---

## Routes

| Path | Screen |
|------|--------|
| `/` | Staff login |
| `/staff` | Staff shell (all modules) |
| `/portal` | Tenant gate (paste token) |
| `/portal?token=XXX` | Auto-open portal |
| `/portal/app` | Tenant dashboard |

---

## Responsive layout

| Width | Layout |
|-------|--------|
| `< 600px` | Bottom nav (4 tabs + «المزيد») |
| `≥ 900px` | NavigationRail + wide grids |

---

## Build commands

```bash
flutter pub get
flutter run -d chrome          # test
flutter run -d windows         # desktop
flutter run -d android         # Android phone
flutter run -d ios             # iPhone / Simulator
flutter build apk --release
flutter build windows --release
flutter build ios --release --no-codesign
```

## Test login (production)

| User | Password |
|------|----------|
| waleed.najjar | Waleed2026! |

> الحسابات القديمة في الوثائق (`Najjar` / `owner`) لم تعد صالحة على الإنتاج.

---

**Launch Quality LLC · جودة الانطلاقة للخدمات**
