# Launch Quality Mobile - Development Roadmap

**Version:** 1.1.1+3 | **Status:** Active Development

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

## 🎯 المرحلة الحالية: التوسع والتحسين

### Q3 2026 - أولويات حالية

#### 🔴 عالية الأولوية
- [ ] **PR #1 Review** - إصلاح مشاكل التطوير (26 يوم معلق)
- [ ] **iOS Support (PR #8)** - إضافة دعم الآيفون الكامل
- [ ] **Unit Tests** - تغطية اختبارات شاملة للـ Services والـ Models
- [ ] **Error Handling** - نظام معالجة الأخطاء الموحد

#### 🟡 متوسطة الأولوية
- [ ] **Offline Support** - دعم العمل بدون إنترنت
- [ ] **Performance Optimization** - تحسين الأداء والذاكرة
- [ ] **Analytics** - إضافة تتبع الأحداث
- [ ] **Localization** - دعم لغات إضافية

#### 🟢 منخفضة الأولوية
- [ ] **Animation Improvements** - تحسينات الرسوم المتحركة
- [ ] **Dark Mode Enhancements** - تحسينات الثيم الداكن
- [ ] **Accessibility** - تحسينات إمكانية الوصول

---

## 📅 الخريطة الزمنية

### ✅ المرحلة 1: الأساسيات (مكتملة)
| المهمة | الحالة | الإصدار |
|------|--------|--------|
| Luxury Theme | ✅ | 1.0.0 |
| API Integration | ✅ | 1.0.0 |
| Dashboard | ✅ | 1.0.0 |
| Responsive Layout | ✅ | 1.0.0 |
| Multi-Platform | ✅ | 1.1.0 |

### 🟡 المرحلة 2: التحسينات (قيد التقدم)
| المهمة | الحالة | الإصدار المخطط |
|------|--------|----------------|
| iOS Support | 🟡 PR #8 | 1.1.1 |
| Unit Tests | 🟡 In Progress | 1.1.1 |
| Error Handling | 🟠 Planned | 1.1.1 |
| Offline Support | ⚪ Planned | 1.2.0 |

### ⚪ المرحلة 3: الميزات المستقبلية
| المهمة | الحالة | الإصدار المخطط |
|------|--------|----------------|
| Advanced Analytics | ⚪ Backlog | 1.2.0 |
| Multi-Language | ⚪ Backlog | 1.3.0 |
| Performance Suite | ⚪ Backlog | 1.3.0 |

---

## 🏗️ بنية المشروع

```
launch-quality-mobile/
├── lib/
│   ├── main.dart                  # نقطة الدخول
│   ├── app.dart                   # إعدادات التطبيق والموجهات
│   ├── config/
│   │   └── api_config.dart        # إعدادات API
│   ├── models/
│   │   ├── app_user.dart          # نموذج المستخدم
│   │   └── portal_data.dart       # نموذج البيانات
│   ├── services/
│   │   ├── api_client.dart        # عميل HTTP
│   │   ├── auth_service.dart      # خدمة المصادقة
│   │   ├── bootstrap_service.dart # تحميل البيانات الأولية
│   │   └── portal_service.dart    # خدمة البوابة
│   ├── state/
│   │   ├── app_state.dart         # حالة التطبيق
│   │   └── portal_state.dart      # حالة البوابة
│   ├── theme/
│   │   ├── brand_colors.dart      # الألوان
│   │   ├── app_theme.dart         # الثيم
│   │   └── widgets/               # مكونات مخصصة
│   ├── utils/
│   │   └── layout_breakpoints.dart # نقاط التوقف
│   └── screens/
│       ├── login_screen.dart
│       ├── staff_shell.dart
│       ├── portal/
│       └── modules/
│           ├── dashboard_screen.dart
│           ├── projects_screen.dart
│           ├── staff_screen.dart
│           ├── finance_screen.dart    # fl_chart
│           ├── maintenance_screen.dart
│           ├── payment_proofs_screen.dart
│           └── properties/clients/contracts/invoices
├── test/                          # الاختبارات
├── ios/                           # iPhone / iPad (Xcode)
├── android/                       # APK build
├── windows/                       # Desktop build
├── web/                           # Chrome testing
├── scripts/
│   ├── build-apk.ps1
│   ├── build-windows.ps1
│   └── build-ios.sh
├── assets/                        # الموارد (الشعار، الصور)
├── pubspec.yaml                   # الحزم والتبعيات
└── analysis_options.yaml          # قواعس الجودة
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

## 🚀 أوامر البناء

### التطوير
```bash
flutter pub get
flutter run -d chrome          # Web
flutter run -d windows         # Desktop
flutter run -d android         # Mobile
flutter run -d ios             # iPhone / Simulator

# تحليل الكود
flutter analyze

# تشغيل الاختبارات
flutter test

# تنسيق الكود
flutter format lib/ test/
```

### الإنتاج
```bash
# APK (Android)
flutter build apk --release

# Windows
flutter build windows --release

# Web
flutter build web --release

# iOS
./scripts/build-ios.sh
```

---

## 📊 معايير الجودة

### الحد الأدنى المطلوب:
- ✅ لا توجد أخطاء في `flutter analyze`
- ✅ تغطية اختبارات ≥ 70%
- ✅ الكود منسّق بـ `flutter format`
- ✅ معايير لينت صارمة

### الأداء:
- ⚡ وقت البدء < 2 ثانية
- ⚡ سرعة الواجهة 60 FPS
- ⚡ حجم التطبيق < 150 MB

---

## 🔄 دورة الإصدار

| النسخة | التاريخ المخطط | الميزات |
|--------|----------------|--------|
| 1.1.1 | July 2026 | iOS, Tests, Error Handling |
| 1.2.0 | September 2026 | Offline, Analytics |
| 1.3.0 | December 2026 | Multi-language, Performance |

---

## 📝 ملاحظات مهمة

- ✅ لا تغييرات على الـ API المتوفرة
- ✅ التوافق الخلفي محفوظ
- ✅ جميع التحديثات اختيارية
- ✅ الأمان والجودة الأولوية

---

## 👥 المساهمون

- **Waled Najjar** - المالك والمطور الرئيسي

---

## 📞 التواصل والدعم

للأسئلة أو الاقتراحات:
- 📧 Email: [walednajjar2@gmail.com](mailto:walednajjar2@gmail.com)
- 🐛 Issues: [GitHub Issues](https://github.com/walednajjar2-salam/launch-quality-mobile/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/walednajjar2-salam/launch-quality-mobile/discussions)

---

**آخر تحديث:** 17 يوليو 2026 | **الحالة:** نشط ✨
