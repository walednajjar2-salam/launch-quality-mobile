# ⚡ Quick Start - البدء السريع

ابدأ مع **Launch Quality Mobile** في 5 دقائق فقط! 🚀

---

## 🎯 المتطلبات الدنيا

- ✅ **Git** مثبت
- ✅ **Flutter 3.3.0+** مثبت
- ✅ **VS Code** أو **Android Studio**

---

## 1️⃣ استنساخ المستودع

```bash
git clone https://github.com/walednajjar2-salam/launch-quality-mobile.git
cd launch-quality-mobile
```

---

## 2️⃣ تثبيت الحزم

```bash
flutter pub get
```

---

## 3️⃣ اختر منصة للتشغيل

### 🌐 على المتصفح (الأسرع)

```bash
flutter run -d chrome
```

### 🖥️ على Windows Desktop

```bash
flutter run -d windows
```

### 📱 على Android (مع جهاز/محاكي متصل)

```bash
flutter devices          # تحقق من الأجهزة المتصلة
flutter run -d android
```

### 🍎 على iOS (macOS فقط)

```bash
flutter run -d ios
```

---

## 4️⃣ تسجيل الدخول

استخدم بيانات الاختبار:

```
Username: Najjar
Password: Najjar2026
```

أو

```
Username: owner
Password: owner2015
```

---

## 5️⃣ استكشف التطبيق! 🎉

- 📊 **Dashboard** - لوحة التحكم مع الإحصائيات
- 📁 **Projects** - إدارة المشاريع
- 👥 **Staff** - إدارة الموظفين
- 💰 **Finance** - التقارير المالية
- 🔧 **Maintenance** - إدارة الصيانة
- 💳 **Payment Proofs** - إثبات الدفع
- 🌐 **Portal** - بوابة المستأجرين

---

## 🧪 اختبر الكود

```bash
# تشغيل جميع الاختبارات
flutter test

# تحليل الكود
flutter analyze

# تنسيق الكود
flutter format lib/ test/
```

---

## 📚 الخطوات التالية

1. اقرأ [SETUP.md](SETUP.md) - إعداد شامل
2. ادرس [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - بنية المشروع
3. اتبع [CONTRIBUTING.md](CONTRIBUTING.md) - إرشادات المساهمة
4. افحص [ROADMAP.md](ROADMAP.md) - خريطة الطريق

---

## ⚙️ المشاكل الشائعة

### ❌ خطأ: Flutter غير مثبت

```bash
# تحقق من التثبيت
flutter --version

# إذا لم يعمل، ثبت Flutter من:
# https://flutter.dev/docs/get-started/install
```

### ❌ خطأ: أجهزة غير متاحة

```bash
# اعرض الأجهزة المتاحة
flutter devices

# تأكد من توصيل جهاز أو تشغيل محاكي
```

### ❌ خطأ في الحزم

```bash
# نظف وأعد تثبيت
flutter clean
flutter pub get
```

### ❌ مشكلة في البناء

```bash
# نظف كل شيء
flutter clean

# ثبت من جديد
flutter pub get

# جرب مرة أخرى
flutter run -d chrome
```

---

## 🎓 نصائح للمطورين

### اختبر الميزات الجديدة

```bash
# قم بإنشاء فرع
git checkout -b feature/my-feature

# اكتب الكود
# ثم اختبر
flutter test

# وأرسل PR
```

### استخدم Hot Reload

اضغط `r` في المحطة أثناء تشغيل التطبيق لإعادة تحميل سريعة:

```
r     - Hot reload (إعادة تحميل سريعة)
R     - Hot restart (إعادة تشغيل سريعة)
q     - إيقاف التطبيق
```

### تصحيح الأخطاء

```bash
# تشغيل مع وضع التصحيح
flutter run -d chrome --debug

# تشغيل مع معلومات مفصلة
flutter run -d chrome -v
```

---

## 📞 الدعم السريع

| المشكلة | الحل |
|--------|------|
| تطبيق بطيء | استخدم `flutter run -d chrome` أو `--release` |
| أخطاء الحزم | قم بتشغيل `flutter pub get` |
| مشاكل البناء | استخدم `flutter clean` ثم `flutter pub get` |
| أخطاء التحليل | قم بتشغيل `flutter analyze` |

---

## ✨ الخطوات التالية

1. ✅ التطبيق يعمل؟
2. 📖 اقرأ التوثيق الكاملة
3. 🤝 ساهم في المشروع!
4. 🎯 تابع [ROADMAP.md](ROADMAP.md)

---

**جاهز؟ ابدأ الآن! 🚀**

```bash
git clone https://github.com/walednajjar2-salam/launch-quality-mobile.git
cd launch-quality-mobile
flutter pub get
flutter run -d chrome
```

**استمتع بالتطوير!** 🎉
