#!/bin/bash
# ═══════════════════════════════════════════════════
# نشر نظام الموارد الطبية على GitHub + Netlify
# ═══════════════════════════════════════════════════
GITHUB_USERNAME="${1:-}"
GITHUB_TOKEN="${2:-}"
REPO_NAME="hr-medical-resources"

if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
  echo ""
  echo "الاستخدام:"
  echo "  bash deploy.sh <اسم_المستخدم_GitHub> <التوكن>"
  echo ""
  echo "للحصول على التوكن:"
  echo "  1. اذهب إلى: https://github.com/settings/tokens/new"
  echo "  2. اختر مدة انتهاء مناسبة"
  echo "  3. حدّد: ✅ repo (كل الخيارات تحتها)"
  echo "  4. اضغط Generate token"
  echo "  5. انسخ التوكن واستخدمه هنا"
  echo ""
  exit 1
fi

echo ""
echo "═══════════════════════════════════════"
echo " 🏥 نظام الموارد الطبية - بدء النشر"
echo "═══════════════════════════════════════"
echo ""

# إنشاء المستودع على GitHub
echo "📁 إنشاء مستودع: $REPO_NAME"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO_NAME\",\"description\":\"نظام إدارة الموارد البشرية - الموارد الطبية\",\"private\":false,\"auto_init\":false}")

if [ "$HTTP_CODE" = "201" ]; then
  echo "✅ تم إنشاء المستودع"
elif [ "$HTTP_CODE" = "422" ]; then
  echo "⚠️  المستودع موجود مسبقاً — سيتم التحديث"
else
  echo "❌ خطأ في إنشاء المستودع (HTTP: $HTTP_CODE)"
  echo "   تحقق من التوكن وصلاحياته"
  exit 1
fi

# إعداد Git
echo ""
echo "⚙️  إعداد Git..."
git init -q 2>/dev/null || true
git config user.email "hr@medical-resources.com" 2>/dev/null || true
git config user.name "$GITHUB_USERNAME" 2>/dev/null || true

# إضافة الملفات والـ commit
echo "📦 تجهيز الملفات..."
git add -A
git commit -q -m "🏥 نظام الموارد الطبية HR v5

الميزات:
✅ 46 موظف | 17 فرع صيدلية
✅ PWA - تثبيت كتطبيق جوال
✅ Service Worker للعمل Offline
✅ إشعارات Push للجوال
✅ ملاحظات وتذكيرات
✅ ترجمة عربي/إنجليزي
✅ تنبيهات انتهاء التراخيص والإقامات
✅ تصدير CSV/HTML/JSON
✅ نسخ احتياطي مع سجل الاستعادة
✅ Sidebar قابل للطي
✅ Responsive كامل" 2>/dev/null || \
git commit --allow-empty -q -m "🏥 Update HR System v5" 2>/dev/null

# الرفع على GitHub
echo "⬆️  جاري الرفع..."
git remote remove origin 2>/dev/null || true
git remote add origin "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git branch -M main
git push -u origin main --force -q 2>&1

if [ $? -eq 0 ]; then
  echo ""
  echo "═══════════════════════════════════════"
  echo " ✅ تم الرفع بنجاح!"
  echo "═══════════════════════════════════════"
  echo ""
  echo "🔗 رابط المستودع:"
  echo "   https://github.com/$GITHUB_USERNAME/$REPO_NAME"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📌 الآن ارتبط Netlify (خطوة واحدة):"
  echo ""
  echo "  1. اذهب إلى: https://app.netlify.com"
  echo "  2. New site → Import from GitHub"
  echo "  3. اختر: $REPO_NAME"
  echo "  4. Publish directory: public"
  echo "  5. Deploy site ✅"
  echo ""
  echo "🔄 لتحديث النظام مستقبلاً:"
  echo "   فقط شغّل: bash deploy.sh $GITHUB_USERNAME [TOKEN]"
  echo "   وسيُحدَّث الموقع تلقائياً خلال دقيقة"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
  echo ""
  echo "❌ فشل الرفع"
  echo "   - تحقق من التوكن"
  echo "   - تأكد من الاتصال بالإنترنت"
fi
