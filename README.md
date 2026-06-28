# 🏥 نظام الموارد الطبية — HR v5

## 🚀 النشر السريع

### الخطوة 1 — الحصول على GitHub Token
```
https://github.com/settings/tokens/new
  ✅ repo (حدّد كل الخيارات تحتها)
  → Generate token → انسخه
```

### الخطوة 2 — تشغيل السكريبت
```bash
bash deploy.sh YOUR_USERNAME YOUR_TOKEN
```

### الخطوة 3 — ربط Netlify
```
app.netlify.com → New site → Import from GitHub
  Repo: hr-medical-resources
  Publish directory: public
  → Deploy site ✅
```

## 📱 تثبيت كتطبيق (PWA)
- **Android/Chrome**: سيظهر بانر تلقائي "تثبيت التطبيق"
- **iPhone/Safari**: شارك ← إضافة للشاشة الرئيسية
- **يعمل فقط** على HTTPS (بعد النشر على Netlify)

## 🔑 بيانات الدخول
| الحقل | القيمة |
|-------|--------|
| اسم المستخدم | `admin` |
| كلمة المرور | `admin123` |

## ✨ الميزات
- ✅ 46 موظف + 17 فرع صيدلية
- ✅ PWA + Service Worker (يعمل Offline)
- ✅ إشعارات Push للجوال
- ✅ ملاحظات وتذكيرات مع ألوان وأولويات
- ✅ ترجمة عربي/إنجليزي
- ✅ تنبيهات انتهاء الإقامات والتراخيص
- ✅ تصدير CSV / HTML / JSON
- ✅ نسخ احتياطي مع سجل الاستعادة
- ✅ Sidebar قابل للطي
- ✅ Responsive (جوال + تابلت + كمبيوتر)
