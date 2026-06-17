# قائمة الرفع النهائية — Launch Quality Mobile

> **آخر تحديث:** 2026-06-17  
> **الحالة:** جاهز للرفع — ينتظر إنشاء المستودع + رفع APK من Desktop

---

## 1) مستودع GitHub (الأولوية الأولى)

| البند | القيمة |
|--------|--------|
| **المستودع المطلوب** | `walednajjar2-salam/launch-quality-mobile` |
| **الحالة** | ❌ غير موجود بعد — يجب إنشاؤه من حسابك |
| **الفرع الجاهز** | `cursor/launch-quality-mobile-547d` |
| **PR مؤقت** | https://github.com/walednajjar2-salam/-/pull/1 |

### أمر الرفع (على الكمبيوتر)

```bash
gh auth login
gh repo create walednajjar2-salam/launch-quality-mobile --public \
  --description "Launch Quality LLC staff Android app"
git clone https://github.com/walednajjar2-salam/-.git
cd -
git checkout cursor/launch-quality-mobile-547d
./scripts/publish-github.sh cursor/launch-quality-mobile-547d
```

---

## 2) ملفات المصدر — تُرفع إلى `launch-quality-mobile`

| المجلد/الملف | الغرض |
|---------------|--------|
| `android/` | مشروع Android كامل (Capacitor 8) |
| `www/` | صفحة fallback + redirect |
| `capacitor.config.json` | رابط Production Railway |
| `package.json` + `package-lock.json` | تبعيات Node |
| `scripts/build-apk.sh` | بناء APK |
| `scripts/publish-github.sh` | دفع إلى GitHub |
| `README.md` | التوثيق |
| `.gitignore` | استثناء node_modules و build |

### ❌ لا ترفع

- `node_modules/`
- `android/app/build/`
- `android/.gradle/`
- `*.apk` (يُرفع في Releases فقط)
- `*.keystore` / كلمات مرور التوقيع
- `.env` / أسرار

---

## 3) ملف APK (من Desktop)

| البند | القيمة |
|--------|--------|
| **الملف** | `Launch-Quality-Staff.apk` |
| **الموقع** | Desktop على الكمبيوتر |
| **أين يُرفع** | GitHub Releases → `launch-quality-mobile` |
| **Tag مقترح** | `v1.0.0-staff` |

```bash
gh release create v1.0.0-staff \
  --repo walednajjar2-salam/launch-quality-mobile \
  --title "Launch Quality Staff v1.0" \
  ~/Desktop/Launch-Quality-Staff.apk
```

> إذا لم يكن APK على Desktop، ابنِه محلياً:
> `npm install && npx cap sync android && ./scripts/build-apk.sh`

---

## 4) Backend — ✅ مرفوع ويعمل (لا يرفع من هنا)

| البند | القيمة |
|--------|--------|
| **الاستضافة** | Railway (Production) |
| **الرابط** | https://web-production-08d73.up.railway.app |
| **API** | https://web-production-08d73.up.railway.app/api |
| **Health** | https://web-production-08d73.up.railway.app/api/health |
| **الإصدار** | `Launch-Quality-LLC-v47-railway` |
| **مستودع Backend** | `walednajjar2-salam/jawdah-cloud-v47` |

---

## 5) ملخص سريع — 3 خطوات للإنهاء

```
[ ] 1. gh auth login
[ ] 2. إنشاء + push مستودع launch-quality-mobile (كود المصدر)
[ ] 3. رفع Launch-Quality-Staff.apk إلى GitHub Releases
```

---

## 6) رسالة Agent من الموبايل (للمتابعة)

```text
أكمل رفع Launch Quality Mobile.
المستودع: walednajjar2-salam/launch-quality-mobile
الفرع: cursor/launch-quality-mobile-547d
APK: Desktop/Launch-Quality-Staff.apk → GitHub Releases
Backend: https://web-production-08d73.up.railway.app/api/health
```

---

## 7) روابط مفيدة

| الغرض | الرابط |
|--------|--------|
| Agent من الموبايل | https://cursor.com/agents |
| Backend Production | https://web-production-08d73.up.railway.app |
| API Health | https://web-production-08d73.up.railway.app/api/health |
| Backend repo | https://github.com/walednajjar2-salam/jawdah-cloud-v47 |
| PR الحالي (مؤقت) | https://github.com/walednajjar2-salam/-/pull/1 |
