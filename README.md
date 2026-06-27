# Launch Quality Mobile (Staff)

تطبيق **Launch Quality Staff** للأندرويد — يتصل بلوحة التحكم الإنتاجية لـ Launch Quality LLC (جودة الانطلاقة).

| البند | القيمة |
|--------|--------|
| **Backend (Production)** | https://web-production-08d73.up.railway.app |
| **API Health** | https://web-production-08d73.up.railway.app/api/health |
| **Package ID** | `com.launchquality.staff` |
| **APK (Android)** | https://github.com/walednajjar2-salam/launch-quality-mobile/raw/downloads-v1.0.1-staff/downloads/Launch-Quality-Staff.apk |
| **Windows (ZIP)** | https://github.com/walednajjar2-salam/launch-quality-mobile/raw/downloads-v1.0.1-staff/downloads/Launch-Quality-Staff-Windows.zip |
| **صفحة التحميل (Railway)** | https://web-production-08d73.up.railway.app/download.html |
| **Source repo** | https://github.com/walednajjar2-salam/launch-quality-mobile |

## ما يفعله التطبيق

- يفتح لوحة التحكم الإنتاجية داخل WebView (Capacitor).
- يعمل مع نفس حسابات النظام على Railway (مثل `razan.accounting`).
- مناسب للموظفين: عقارات، عقود، فواتير، صيانة، تقارير.

## تنزيل التطبيق (روابط مباشرة)

| المنصة | الرابط |
|--------|--------|
| **أندرويد** | https://github.com/walednajjar2-salam/launch-quality-mobile/raw/downloads-v1.0.1-staff/downloads/Launch-Quality-Staff.apk |
| **ويندوز** | https://github.com/walednajjar2-salam/launch-quality-mobile/raw/downloads-v1.0.1-staff/downloads/Launch-Quality-Staff-Windows.zip |

أيقونة التطبيق = شعار **جودة الانطلاقة** (`assets/logo.png`). لتوليد الأيقونات:

```bash
python scripts/generate-app-icons.py
```

صفحة التحميل داخل التطبيق: `www/download.html`

## متطلبات البناء (على الكمبيوتر)

1. **Node.js** 18+
2. **Android Studio** + Android SDK
3. **Java** 21 (للبناء من المصدر)

```bash
npm install
npx cap sync android
```

## بناء APK

### Debug (اختبار سريع)

```bash
npm run android:debug
# المخرج: android/app/build/outputs/apk/debug/app-debug.apk
```

### Release (للتوزيع)

```bash
# مرة واحدة: أنشئ keystore
keytool -genkey -v -keystore launch-quality-staff.keystore -alias staff \
  -keyalg RSA -keysize 2048 -validity 10000

# أضف إلى android/gradle.properties (لا ترفع الملف إلى GitHub):
# MYAPP_UPLOAD_STORE_FILE=../launch-quality-staff.keystore
# MYAPP_UPLOAD_KEY_ALIAS=staff
# MYAPP_UPLOAD_STORE_PASSWORD=***
# MYAPP_UPLOAD_KEY_PASSWORD=***

npm run android:build
# المخرج: android/app/build/outputs/apk/release/Launch-Quality-Staff.apk
```

> إذا كان لديك APK جاهز على Desktop باسم `Launch-Quality-Staff.apk`، يمكنك رفعه مباشرة إلى [GitHub Releases](https://github.com/walednajjar2-salam/launch-quality-mobile/releases) دون إعادة البناء.

## النشر على GitHub

المستودع المستهدف: **walednajjar2-salam/launch-quality-mobile**

```bash
# 1) تسجيل الدخول (مرة واحدة على جهازك)
gh auth login

# 2) إنشاء المستودع (إن لم يكن موجوداً)
gh repo create walednajjar2-salam/launch-quality-mobile --public \
  --description "Launch Quality LLC staff Android app"

# 3) الدفع
git remote add launch-quality-mobile \
  https://github.com/walednajjar2-salam/launch-quality-mobile.git
git push -u launch-quality-mobile main
```

أو استخدم السكربت:

```bash
./scripts/publish-github.sh
```

## المتابعة من الموبايل (Cursor Agent)

1. افتح https://cursor.com/agents من Safari أو Chrome.
2. سجّل الدخول بنفس حساب Cursor.
3. (اختياري) Add to Home Screen.
4. ابدأ جلسة Agent جديدة وانسخ:

```text
أكمل مشروع Launch Quality Mobile.
المشروع: launch-quality-mobile
Backend: https://web-production-08d73.up.railway.app/api
APK جاهز على Desktop: Launch-Quality-Staff.apk
المطلوب: gh auth ثم push إلى walednajjar2-salam/launch-quality-mobile
```

> المحادثة على الكمبيوتر لا تُنقل تلقائياً — تبدأ جلسة جديدة لكن من نفس المشروع.

## تغيير رابط الـ Backend

عدّل `capacitor.config.json`:

```json
"server": {
  "url": "https://web-production-08d73.up.railway.app"
}
```

ثم:

```bash
npx cap sync android
```

## فحص الاتصال

```bash
curl https://web-production-08d73.up.railway.app/api/health
```

يجب أن ترى `"ok": true` و `"version": "Launch-Quality-LLC-v47-railway"`.
