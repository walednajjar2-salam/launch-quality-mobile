# رفع GitHub + بناء APK/Windows

## ✅ تم محلياً

- Commit: `9c77cde` — native luxury Flutter app
- نسخة ZIP: `Desktop\launch-quality-mobile-v1.1.zip`

---

## 1) رفع GitHub

المستودع `walednajjar2-salam/launch-quality-mobile` **غير موجود** أو يحتاج تسجيل دخول.

### الخطوات (مرة واحدة)

```powershell
# ثبّت GitHub CLI من https://cli.github.com/ ثم:
gh auth login

cd c:\Users\waled\OneDrive\Desktop\launch-quality-mobile
.\scripts\push-to-github.ps1
```

أو يدوياً:

```powershell
gh repo create walednajjar2-salam/launch-quality-mobile --public --source=. --remote=origin --push
git push -u origin main
```

---

## 2) بناء APK (Android)

**المطلوب:**
1. Android Studio → SDK Manager → تثبيت Android SDK
2. Windows **Developer Mode** (لـ Flutter plugins):
   - `start ms-settings:developers` → فعّل Developer Mode
3. أعد تشغيل Cursor/Terminal

```powershell
cd c:\Users\waled\OneDrive\Desktop\launch-quality-mobile
flutter pub get
.\scripts\build-apk.ps1
```

المخرج: `Desktop\Launch-Quality-Staff.apk`

---

## 3) بناء Windows

```powershell
.\scripts\build-windows.ps1
```

المخرج: `build\windows\x64\runner\Release\`

---

## 4) اختبار Chrome (بدون SDK)

```powershell
flutter run -d chrome
```

Login: **waleed.najjar** / **Waleed2026!**

---

## 5) بناء iPhone (macOS + Xcode)

**المطلوب:** Mac مع Xcode و CocoaPods و Flutter.

```bash
cd launch-quality-mobile
chmod +x scripts/build-ios.sh
./scripts/build-ios.sh
open ios/Runner.xcworkspace
```

في Xcode: اختر فريق التوقيع (Signing Team) → Product → Archive → Distribute (TestFlight / جهاز).

اسم التطبيق على الشاشة الرئيسية: **جودة الانطلاقة**
