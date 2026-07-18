# إيقاف الرابط القديم (v72)

الرابط القديم ما زال يعمل:

`https://web-production-08d73.up.railway.app`

هو **مشروع Railway منفصل** عن `Jawda-Al-Intilaqa`. لا يمكن إيقافه بدون توken ذلك المشروع.

## الخطوات (يدوياً)

1. ادخل https://railway.app/dashboard
2. افتح المشروع الذي يحتوي `web-production-08d73`
3. **Service** → **Settings** → **Delete Service** (أو Remove domain ثم Delete)
4. (اختياري) احذف المشروع بالكامل إن لم يعد مطلوباً

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
