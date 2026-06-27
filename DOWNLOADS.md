# روابط التحميل المباشر — Launch Quality Staff

| المنصة | الرابط المباشر |
|--------|----------------|
| **أندرويد (APK)** | https://github.com/walednajjar2-salam/launch-quality-mobile/raw/downloads-v1.0.1-staff/downloads/Launch-Quality-Staff.apk |
| **ويندوز (ZIP)** | https://github.com/walednajjar2-salam/launch-quality-mobile/raw/downloads-v1.0.1-staff/downloads/Launch-Quality-Staff-Windows.zip |

> أيقونة التطبيق = شعار **جودة الانطلاقة** (`assets/logo.png`).

## صفحة التحميل

افتح `www/download.html` من التطبيق أو من المتصفح بعد النشر.

## إعادة البناء والرفع

```powershell
# 1) أيقونات من الشعار
python scripts/generate-app-icons.py

# 2) APK أندرويد
cd android
.\gradlew.bat assembleRelease
# المخرج: android\app\build\outputs\apk\release\Launch-Quality-Staff.apk

# 3) ويندوز (يتطلب Flutter + Visual Studio)
flutter build windows --release
powershell -File scripts\package-windows-release.ps1

# 4) رفع GitHub Release
powershell -File scripts\publish-release.ps1
```

## Backend

https://web-production-08d73.up.railway.app/api/health
