# Contributing to Launch Quality Mobile

شكراً لاهتمامك بالمساهمة في مشروع **Launch Quality Mobile**! 🙏

## 📋 قواعد المساهمة

### ✅ قبل البدء:
- اقرأ [README.md](README.md) و [ROADMAP.md](ROADMAP.md)
- تأكد من تثبيت Flutter SDK 3.3.0+
- فهم بنية المشروع في [ROADMAP.md](ROADMAP.md)

### 🔧 إعداد البيئة:

```bash
# استنساخ المستودع
git clone https://github.com/walednajjar2-salam/launch-quality-mobile.git
cd launch-quality-mobile

# تثبيت الحزم
flutter pub get

# التحقق من الكود
flutter analyze

# تشغيل الاختبارات
flutter test
```

### 📝 معايير الكود:

1. **التسميات (Naming):**
   - Classes: `PascalCase` (مثل `LoginScreen`)
   - Functions/Variables: `camelCase` (مثل `getUserData`)
   - Constants: `camelCase` (مثل `apiTimeout`)
   - Private: `_camelCase` (مثل `_privateMethod`)

2. **الصيغة (Format):**
   ```bash
   flutter format lib/ test/
   ```

3. **التحليل (Linting):**
   ```bash
   flutter analyze
   ```
   يجب أن تكون النتائج بدون أخطاء.

4. **الاختبارات (Testing):**
   - اكتب اختبارات لأي ميزة جديدة
   ```bash
   flutter test
   ```

5. **التوثيق (Documentation):**
   - اكتب تعليقات واضحة للدوال المعقدة
   - استخدم `///` للتوثيق العام
   ```dart
   /// تحميل بيانات المستخدم من الـ API
   /// 
   /// Returns: [AppUser] or throws [Exception]
   Future<AppUser> fetchUser(String id) async { }
   ```

### 🚀 خطوات المساهمة:

1. **إنشاء فرع جديد:**
   ```bash
   git checkout -b feature/my-feature
   ```

2. **إجراء التغييرات:**
   - اكتب الكود
   - اختبر الكود
   - طبق معايير الجودة

3. **Commit:**
   ```bash
   git commit -m "feat: add new feature description"
   ```
   استخدم Conventional Commits:
   - `feat:` - ميزة جديدة
   - `fix:` - إصلاح خطأ
   - `docs:` - تحديثات التوثيق
   - `style:` - تنسيق الكود
   - `refactor:` - إعادة هيكلة بدون تغيير الوظيفة
   - `test:` - إضافة/تحديث الاختبارات
   - `chore:` - تحديثات البناء والحزم

4. **Push والـ Pull Request:**
   ```bash
   git push origin feature/my-feature
   ```
   - اذهب إلى GitHub وأنشئ Pull Request
   - اكتب وصفاً واضحاً للتغييرات
   - ارتبط بأي Issues ذات صلة

### ✨ معايير الجودة:

- ✅ لا توجد أخطاء في `flutter analyze`
- ✅ جميع الاختبارات تمرّ `flutter test`
- ✅ الكود منسّق باستخدام `flutter format`
- ✅ التوثيق محدّث
- ✅ الـ PR يحتوي على وصف واضح

### 🐛 الإبلاغ عن الأخطاء:

1. افحص [Issues الموجودة](https://github.com/walednajjar2-salam/launch-quality-mobile/issues)
2. أنشئ Issue جديدة مع:
   - وصف واضح للمشكلة
   - خطوات إعادة الإنتاج
   - السلوك المتوقع
   - السلوك الفعلي
   - الإصدار والمنصة

### 🎯 البنية الموصى بها للملفات:

```
lib/
├── models/          # نماذج البيانات
├── services/        # خدمات API والوظائف
├── state/          # إدارة الحالة (Provider)
├── theme/          # الألوان والأنماط
├── utils/          # دوال مساعدة
└── screens/        # الشاشات والـ UI
```

### 📚 المراجع:

- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

---

**شكراً لمساهمتك!** 🌟

للأسئلة، أنشئ Issue أو تواصل معنا.
