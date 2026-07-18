# 🛠️ Setup Guide - دليل الإعداد

هذا الدليل يساعدك على إعداد بيئة التطوير لمشروع **Launch Quality Mobile** بشكل صحيح.

---

## 📋 المتطلبات الأساسية

### ✅ نظام التشغيل
- **Windows 10+** أو **macOS 10.15+** أو **Linux** (Ubuntu 18.04+)
- **RAM:** 8 GB على الأقل
- **Disk Space:** 10 GB متاح

### ✅ الأدوات المطلوبة
- **Git** - [Download](https://git-scm.com/download)
- **Flutter SDK 3.3.0+** - [Download](https://flutter.dev/docs/get-started/install)
- **Android Studio** أو **VS Code** - [Download](https://developer.android.com/studio) أو [Download](https://code.visualstudio.com)
- **Java Development Kit (JDK) 11+**

---

## 🖥️ Windows Setup

### 1️⃣ تثبيت Flutter

```bash
# تحميل Flutter
git clone https://github.com/flutter/flutter.git -b stable

# إضافة Flutter إلى PATH
setx PATH "%PATH%;C:\path\to\flutter\bin"
setx PUB_HOSTED_URL https://pub.flutter-io.cn
setx FLUTTER_STORAGE_BASE_URL https://storage.flutter-io.cn

# التحقق
flutter --version
```

### 2️⃣ تثبيت Android SDK

```bash
# من Android Studio:
# 1. افتح Android Studio
# 2. Settings → Appearance & Behavior → System Settings → Android SDK
# 3. اختر Android 12+ (API 31+)
# 4. اختر Google Play Services
```

### 3️⃣ تثبيت القيود

```bash
flutter doctor
```

تأكد من أن جميع المتطلبات مكتملة (✓)

### 4️⃣ استنساخ المشروع

```bash
git clone https://github.com/walednajjar2-salam/launch-quality-mobile.git
cd launch-quality-mobile
```

### 5️⃣ تثبيت الحزم

```bash
flutter pub get
```

---

## 🍎 macOS Setup

### 1️⃣ تثبيت Flutter

```bash
# استخدم Homebrew
brew install flutter

# أو يدويًا
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:~/flutter/bin"

# أضف إلى ~/.zshrc أو ~/.bash_profile
echo 'export PATH="$PATH:~/flutter/bin"' >> ~/.zshrc
```

### 2️⃣ تثبيت Xcode

```bash
# من App Store أو:
xcode-select --install
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### 3️⃣ تثبيت CocoaPods

```bash
sudo gem install cocoapods
```

### 4️⃣ التحقق من المتطلبات

```bash
flutter doctor
```

### 5️⃣ استنساخ وإعداد المشروع

```bash
git clone https://github.com/walednajjar2-salam/launch-quality-mobile.git
cd launch-quality-mobile
flutter pub get
```

---

## 🐧 Linux Setup

### 1️⃣ تثبيت المتطلبات

```bash
sudo apt-get update
sudo apt-get install -y git curl libglu1-mesa openjdk-11-jdk
```

### 2️⃣ تثبيت Flutter

```bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:~/flutter/bin"

# أضف إلى ~/.bashrc
echo 'export PATH="$PATH:~/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### 3️⃣ تثبيت Android SDK

```bash
# استخدم Android Studio أو:
# قم بتحميل Android SDK Command-line Tools
# وقم بتثبيت الأدوات المطلوبة
```

### 4️⃣ إعداد المشروع

```bash
git clone https://github.com/walednajjar2-salam/launch-quality-mobile.git
cd launch-quality-mobile
flutter pub get
flutter doctor
```

---

## 📱 تشغيل التطبيق

### اختبار في المتصفح (Chrome)

```bash
flutter run -d chrome
```

### تشغيل على Windows Desktop

```bash
flutter run -d windows
```

### تشغيل على Android

```bash
# تأكد من توصيل جهاز أو محاكي
flutter devices
flutter run -d android
```

### تشغيل على iOS (macOS فقط)

```bash
flutter run -d ios
```

---

## 🧪 تشغيل الاختبارات

```bash
# جميع الاختبارات
flutter test

# اختبار محدد
flutter test test/services/api_client_test.dart

# مع التغطية
flutter test --coverage
```

---

## 📊 فحص الكود

```bash
# تحليل الكود
flutter analyze

# تنسيق الكود
flutter format lib/ test/

# إصلاح تحذيرات التنسيق
flutter format lib/ test/ --set-exit-if-changed
```

---

## 🔌 تكوين المحرر (VS Code)

### 1️⃣ التوسعات المطلوبة

```
- Dart Code
- Flutter
- Awesome Flutter Snippets
- Pubspec Assist
```

### 2️⃣ إعدادات VS Code (`settings.json`)

```json
{
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "editor.rulers": [80, 120]
  },
  "dart.enableSdkFormatter": true,
  "dart.sdkPath": "/path/to/flutter/bin/cache/dart-sdk",
  "dart.flutterSdkPath": "/path/to/flutter"
}
```

---

## 🔧 تكوين المحرر (Android Studio)

### 1️⃣ التوسعات المطلوبة

```
- Flutter
- Dart
- Android NDK
```

### 2️⃣ إعدادات IDE

```
1. File → Settings → Editor → Code Style → Dart
2. اختر "Google Style"
3. طبق إعدادات editorconfig
```

---

## 🌐 بيانات API الاختبار

### Login Credentials

```
API: https://jawda-al-intilaqa-production.up.railway.app/api

User 1:
- Username: Najjar
- Password: Najjar2026

User 2:
- Username: owner
- Password: owner2015

User 3:
- Username: operations
- Password: 1234
```

---

## 🚀 أول تشغيل

```bash
# 1. انتقل إلى مجلد المشروع
cd launch-quality-mobile

# 2. احصل على الحزم
flutter pub get

# 3. قم بتشغيل التطبيق
flutter run -d chrome

# 4. سجل الدخول باستخدام بيانات الاختبار
# Username: Najjar
# Password: Najjar2026

# 5. استكشف لوحة التحكم!
```

---

## 🐛 استكشاف الأخطاء

### Flutter doctor يظهر تحذيرات

```bash
flutter doctor -v
flutter doctor --android-licenses
```

### مشاكل الحزم

```bash
flutter pub get
flutter pub upgrade
flutter pub cache repair
```

### مشاكل البناء

```bash
flutter clean
flutter pub get
flutter run
```

### تعارضات المنفذ

```bash
# تغيير المنفذ
flutter run -d chrome --web-port 8081
```

---

## 📚 المراجع المفيدة

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Android Development](https://developer.android.com)
- [iOS Development](https://developer.apple.com)

---

## ✅ قائمة التحقق

- [ ] تم تثبيت Flutter SDK
- [ ] تم تثبيت Java JDK 11+
- [ ] تم تثبيت Git
- [ ] تم استنساخ المستودع
- [ ] تم تشغيل `flutter pub get`
- [ ] تم تشغيل `flutter doctor` بنجاح
- [ ] تم تشغيل التطبيق بنجاح
- [ ] تم فهم بنية المشروع

---

## 📞 الدعم

إذا واجهت أي مشاكل:

1. تحقق من [FAQ](#faq)
2. ابحث في [GitHub Issues](https://github.com/walednajjar2-salam/launch-quality-mobile/issues)
3. أنشئ Issue جديدة مع وصف المشكلة
4. تواصل عبر: [walednajjar2@gmail.com](mailto:walednajjar2@gmail.com)

---

**آخر تحديث:** 17 يوليو 2026 ✨
