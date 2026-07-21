#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# سكريبت تحديث نظام الموارد الطبية
# الاستخدام: bash update.sh [ملف_app.js_جديد]
# ═══════════════════════════════════════════════════════════════════

GITHUB_USERNAME="${GITHUB_USERNAME:-}"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
REPO="hr-medical-resources"
NEW_APP="${1:-}"

# قراءة المتغيرات من ملف .env إذا موجود
if [ -f ".env" ]; then
  export $(cat .env | grep -v '#' | xargs)
fi

if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
  echo ""
  echo "❌ المتغيرات غير مضبوطة!"
  echo ""
  echo "الحل 1 — أضف لملف .env:"
  echo "  GITHUB_USERNAME=your_username"
  echo "  GITHUB_TOKEN=ghp_xxxxxxxxxxxx"
  echo ""
  echo "الحل 2 — مرر مباشرة:"
  echo "  GITHUB_USERNAME=user GITHUB_TOKEN=token bash update.sh"
  echo ""
  exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " 🔄 تحديث نظام الموارد الطبية HR"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# استبدال app.js إذا تم تمرير ملف جديد
if [ -n "$NEW_APP" ] && [ -f "$NEW_APP" ]; then
  echo "📦 تحديث app.js من: $NEW_APP"
  cp "$NEW_APP" public/app.js
  echo "   ✅ تم"
fi

# Git commit & push
echo "⬆️  رفع التحديثات..."
git add -A
git commit -q -m "🔄 Auto-update $(date '+%Y-%m-%d %H:%M')" 2>/dev/null || \
  echo "   ℹ️  لا توجد تغييرات جديدة"

git remote remove origin 2>/dev/null || true
git remote add origin "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO.git"
git push -q origin main --force 2>&1 | tail -2

echo ""
echo "✅ تم! Netlify سيتحدث خلال 1-2 دقيقة"
echo "🔗 https://github.com/$GITHUB_USERNAME/$REPO/actions"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
