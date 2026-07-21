#!/bin/bash
U="${1:-}" T="${2:-}" R="hr-medical-resources"
[ -z "$U" ]||[ -z "$T" ]&&{ echo "bash deploy.sh USERNAME TOKEN"; echo "Token: github.com/settings/tokens/new -> repo"; exit 1; }
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " 🏥 الموارد الطبية HR v6 — جاري النشر..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
curl -sf -X POST -H "Authorization: token $T" -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos -d "{\"name\":\"$R\",\"private\":false}" >/dev/null 2>&1 || true
git init -q && git config user.email "hr@mr.com" && git config user.name "$U"
git add -A
git commit -q -m "HR System v6 $(date '+%Y-%m-%d %H:%M')

✅ Dark/Light Theme Toggle
✅ Session persists on refresh
✅ Sidebar icons clearer
✅ Translation fixed
✅ Reminders on Dashboard
✅ PWA install banner
✅ Favicon in tab" 2>/dev/null || git commit --allow-empty -q -m "update $(date '+%Y-%m-%d')"
git remote remove origin 2>/dev/null
git remote add origin "https://$T@github.com/$U/$R.git"
git branch -M main && git push -u origin main --force -q
echo ""
echo "✅ تم الرفع: https://github.com/$U/$R"
echo "📌 Netlify يتحدث تلقائياً خلال دقيقة إذا مربوط"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
