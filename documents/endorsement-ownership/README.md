# ملحق نقل وثيقة التأمين — قالب GIG قابل للتعديل

قالب HTML لوثيقة **ENDORSEMENT ANNEXURE FOR CHANGE OF OWNERSHIP** بهوية **GIG Gulf Insurance Oman** (تأمين شامل).

## التشغيل

افتح الملف مباشرة في المتصفح:

```bash
# من جذر المشروع
xdg-open documents/endorsement-ownership/index.html
# أو
python3 -m http.server 8080 --directory documents/endorsement-ownership
```

ثم افتح: `http://localhost:8080`

## التعديل

1. **الطريقة الأسهل:** عدّل القيم في `data.js` ثم أعد تحميل الصفحة.
2. **على الصفحة:** اضغط «تفعيل التعديل»، غيّر أي حقل، ثم «حفظ JSON» لتنزيل `data.js` محدّث.
3. **طباعة / PDF:** زر «طباعة / PDF» ثم اختر Save as PDF من نافذة الطباعة.

## الملفات

| ملف | الوظيفة |
|---|---|
| `index.html` | التخطيط والأنماط المطابقة للوثيقة |
| `data.js` | كل البيانات القابلة للتعديل |
| `app.js` | عرض الوثيقة وأدوات التعديل/الطباعة |
| `assets/` | الشعار والتوقيع |
| `source.pdf` | النسخة الأصلية للمقارنة |
