# 🏥 الموارد الطبية HR — النشر التلقائي

## ⚡ كيف يعمل النظام التلقائي

```
Claude (تعديلات) 
    ↓ تنزيل app.js
bash update.sh app.js
    ↓
GitHub (push)
    ↓ GitHub Actions تلقائياً
Netlify (deploy)
    ↓
الموقع يتحدث ✅
```

---

## 🔧 الإعداد (مرة واحدة فقط)

### الخطوة 1 — Tokens المطلوبة

**GitHub Token:**
1. github.com/settings/tokens/new
2. ✅ `repo` + ✅ `workflow`
3. Generate token → انسخه

**Netlify Token:**
1. app.netlify.com → User settings → Applications
2. New access token → انسخه

**Netlify Site ID:**
1. الموقع على Netlify → Site settings
2. انسخ Site ID

### الخطوة 2 — تشغيل الإعداد
```bash
bash setup.sh
```
سيطلب منك البيانات ويضبط كل شيء تلقائياً.

---

## 🔄 التحديث اليومي

### عند تلقي ملف جديد من Claude:
```bash
bash update.sh path/to/new-app.js
```

### أو بدون ملف جديد (رفع التعديلات الحالية):
```bash
bash update.sh
```

**النتيجة:** GitHub يستقبل التحديث ← Actions تُشغَّل ← Netlify يُحدِّث الموقع خلال دقيقة.

---

## 📋 هيكل الملفات

```
├── .github/
│   └── workflows/
│       └── deploy.yml      ← GitHub Actions (النشر التلقائي)
├── public/
│   ├── app.js              ← الكود المبني (يُحدَّث من Claude)
│   ├── index.html          ← صفحة HTML
│   ├── manifest.json       ← PWA
│   ├── sw.js               ← Service Worker
│   ├── icon-192.png        
│   └── icon-512.png        
├── scripts/
│   └── build.sh            ← بناء محلي (اختياري)
├── .env                    ← بيانات التوكن (لا يُرفع على GitHub)
├── setup.sh                ← إعداد أولي
├── update.sh               ← تحديث سريع
├── netlify.toml            ← إعدادات Netlify
└── README.md
```

---

## 🔑 بيانات الدخول
`admin` / `admin123`

---

## 📱 تثبيت كتطبيق (PWA)
بعد النشر على Netlify — بانر تلقائي على Android/Chrome
iPhone: شارك ⬆️ ← إضافة للشاشة الرئيسية
