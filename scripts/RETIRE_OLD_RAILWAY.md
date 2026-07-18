# إيقاف الرابط القديم (v72)

الرابط القديم:

`https://web-production-08d73.up.railway.app`

## الحالة (2026-07-18)

| الإجراء | الحالة |
|---------|--------|
| تعطيل دخول المستخدمين على v72 | **تم** — لا يعمل أي login بكلمات المرور المعروفة |
| حذف خدمة Railway بالكامل | **يتطلب** توken مشروع v72 القديم |

الـ health endpoint قد يظل 200 حتى حذف الخدمة من Railway.

## حذف كامل (موصى به)

### الطريقة 1 — لوحة Railway (يدوي)

1. https://railway.app/dashboard
2. افتح المشروع الذي يحتوي `web-production-08d73`
3. **Settings → Tokens → Create Token** (production)
4. على جهازك:

```bash
export OLD_RAILWAY_TOKEN=legacy-project-token
bash scripts/delete-old-railway.sh
```

### الطريقة 2 — من اللوحة مباشرة

1. Service → **Settings** → **Delete Service**
2. (اختياري) Delete Project

## قبل الحذف

تأكد أن الإنتاج الجديد يعمل:

| الخدمة | الرابط |
|--------|--------|
| Backend API | https://jawda-al-intilaqa-production.up.railway.app/api |
| ERP | https://jawda-al-intilaqa-production.up.railway.app/app.html |
| Flutter Web | https://launch-quality-mobile-production-bb40.up.railway.app |

## بيانات لم تُنقل (v72 فقط)

| الجدول | السبب |
|--------|--------|
| `employees` (3 سجلات) | لا يوجد جدول `employees` في v48 — البيانات في `salaries` |
| `collection_reminders` | فارغ في v72 |
| `payment_proofs` | فارغ في v72 |
