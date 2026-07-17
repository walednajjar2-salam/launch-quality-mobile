# 📁 Project Structure Guide - دليل بنية المشروع

دليل شامل لفهم بنية مشروع **Launch Quality Mobile**.

---

## 📊 الهيكل العام

```
launch-quality-mobile/
├── 📂 lib/                          # كود المصدر الرئيسي (Dart)
├── 📂 test/                         # الاختبارات
├── 📂 android/                      # إعدادات Android
├── 📂 ios/                          # إعدادات iOS
├── 📂 windows/                      # إعدادات Windows
├── 📂 web/                          # إعدادات Web
├── 📂 assets/                       # الصور والموارد
├── 📂 scripts/                      # سكريبتات البناء
├── 📄 pubspec.yaml                  # الحزم والتبعيات
├── 📄 pubspec.lock                  # ملف القفل
├── 📄 analysis_options.yaml         # قواعس الجودة
├── 📄 README.md                     # التوثيق الأساسي
├── 📄 ROADMAP.md                    # خريطة الطريق
├── 📄 CONTRIBUTING.md               # إرشادات المساهمة
├── 📄 CHANGELOG.md                  # سجل التغييرات
├── 📄 SECURITY.md                   # سياسة الأمان
├── 📄 SETUP.md                      # دليل الإعداد
├── 📄 .gitignore                    # ملفات يتم تجاهلها
├── 📄 .gitattributes                # خصائص Git
└── 📄 .editorconfig                 # إعدادات المحرر
```

---

## 📂 مجلد `lib/` - كود التطبيق

### البنية الرئيسية

```
lib/
├── main.dart                        # نقطة الدخول للتطبيق
├── app.dart                         # إعدادات الجذر والموجهات
├── config/                          # الإعدادات
├── models/                          # نماذج البيانات
├── services/                        # الخدمات والـ APIs
├── state/                           # إدارة الحالة
├── theme/                           # الألوان والأنماط
├── utils/                           # دوال مساعدة
└── screens/                         # الشاشات والواجهات
```

### 📄 `main.dart` - نقطة الدخول

```dart
void main() {
  runApp(const LaunchQualityApp());
}

class LaunchQualityApp extends StatelessWidget {
  const LaunchQualityApp();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // إعدادات التطبيق
    );
  }
}
```

**الوظيفة:** نقطة بداية التطبيق، يتم فيها تحديد الإعدادات الأساسية.

---

### 📄 `app.dart` - إعدادات الجذر

```
app.dart
├── Router Setup (GoRouter)
├── Theme Configuration
├── Provider Setup
└── Localization
```

**الوظيفة:** إعداد الموجهات، الثيمات، وإدارة الحالة العامة.

---

### 📁 `config/` - الإعدادات

```
config/
└── api_config.dart                  # إعدادات API
    ├── API Base URL
    ├── Timeouts
    ├── Headers
    └── Error Messages
```

---

### 📁 `models/` - نماذج البيانات

```
models/
├── app_user.dart                    # نموذج المستخدم
├── portal_data.dart                 # بيانات البوابة
└── dashboard_data.dart              # بيانات لوحة التحكم
```

---

### 📁 `services/` - الخدمات

```
services/
├── api_client.dart                  # عميل HTTP
├── auth_service.dart                # خدمة المصادقة
├── bootstrap_service.dart           # تحميل البيانات الأولية
└── portal_service.dart              # خدمة البوابة
```

---

### 📁 `state/` - إدارة الحالة

```
state/
├── app_state.dart                   # حالة التطبيق (Provider)
└── portal_state.dart                # حالة البوابة
```

---

### 📁 `theme/` - الألوان والأنماط

```
theme/
├── brand_colors.dart                # الألوان
├── app_theme.dart                   # الثيم الكامل
└── widgets/                         # مكونات مخصصة
    ├── glass_card.dart
    ├── luxury_background.dart
    └── circular_progress_ring.dart
```

---

### 📁 `screens/` - الشاشات

```
screens/
├── login_screen.dart                # شاشة تسجيل الدخول
├── staff_shell.dart                 # الغلاف الرئيسي
├── portal/
│   ├── portal_gate_screen.dart
│   └── portal_shell.dart
└── modules/                         # الوحدات
    ├── dashboard_screen.dart
    ├── projects_screen.dart
    ├── staff_screen.dart
    ├── finance_screen.dart
    ├── maintenance_screen.dart
    └── payment_proofs_screen.dart
```

---

## 📂 مجلد `test/` - الاختبارات

```
test/
├── services/
├── models/
├── utils/
└── widgets/
```

**الوظيفة:** اختبارات الوحدة (Unit Tests).

---

## 🚀 سير العمل النموذجي

```
1. العمل على ميزة جديدة
   ├── إنشاء فرع
   ├── إنشاء Model
   ├── إنشاء Service
   ├── إضافة الاختبارات
   ├── إنشاء Screen
   └── التحديث في Routes

2. الاختبار
   ├── flutter analyze
   ├── flutter test
   └── flutter run

3. الإرسال
   ├── git add .
   ├── git commit
   └── git push
```

---

## 📚 القواعس الموصى بها

| النوع | الصيغة | مثال |
|--------|--------|----------|
| Classes | `PascalCase` | `LoginScreen` |
| Functions | `camelCase` | `getUserData()` |
| Variables | `camelCase` | `userName` |
| Constants | `camelCase` | `apiTimeout` |
| Private | `_camelCase` | `_privateMethod()` |
| Files | `snake_case` | `login_screen.dart` |

---

**آخر تحديث:** 17 يوليو 2026 ✨