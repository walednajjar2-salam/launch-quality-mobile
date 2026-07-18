# إعداد RAILWAY_TOKEN (خطوة واحدة — يدوياً)

> **لا** تنشئ repo باسم `RAILWAY_TOKEN`  
> **لا** تضع التوken في `README.md` أو أي commit

## الخطوات (دقيقة واحدة)

1. افتح: https://github.com/walednajjar2-salam/launch-quality-mobile/settings/secrets/actions  
2. **New repository secret**  
3. الاسم: `RAILWAY_TOKEN`  
4. القيمة: Project Token من Railway → **Jawda-Al-Intilaqa** → Settings → Tokens  
5. **Add secret**

## التحقق

GitHub → **Actions** → **Deploy Jawdah Cloud to Railway** → **Run workflow**

يجب ألا يظهر: `RAILWAY_TOKEN secret is not configured — skipping deploy`

## النشر اليدوي (بدون GitHub)

```bash
export RAILWAY_TOKEN=your-project-token
./scripts/deploy-jawdah-cloud.sh
./scripts/deploy-flutter-web.sh
```

## الروابط الحية

| الخدمة | الرابط |
|--------|--------|
| Backend API | https://jawda-al-intilaqa-production.up.railway.app/api |
| ERP | https://jawda-al-intilaqa-production.up.railway.app/app.html |
| Flutter Web | https://launch-quality-mobile-production-bb40.up.railway.app |
