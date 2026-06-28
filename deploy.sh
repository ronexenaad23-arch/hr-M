#!/bin/bash
GITHUB_USERNAME="${1:-}"
GITHUB_TOKEN="${2:-}"
REPO_NAME="hr-medical-resources"

if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
  echo "الاستخدام: bash deploy.sh <اسم_المستخدم> <التوكن>"
  echo "التوكن من: https://github.com/settings/tokens/new → repo"
  exit 1
fi

echo "🚀 إنشاء مستودع $REPO_NAME ..."
curl -sf -X POST -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO_NAME\",\"description\":\"نظام HR - الموارد الطبية\",\"private\":false}" > /dev/null 2>&1 || true

git init -q
git config user.email "hr@medical-resources.com"
git config user.name "$GITHUB_USERNAME"
git add -A
git commit -q -m "🏥 HR System v4 - الموارد الطبية" 2>/dev/null || git commit --allow-empty -q -m "update"
git remote remove origin 2>/dev/null; git remote add origin "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git branch -M main
git push -u origin main --force -q

echo "✅ تم الرفع: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo ""
echo "📌 الآن اربط Netlify:"
echo "   app.netlify.com → New site → Import from GitHub → $REPO_NAME"
echo "   Publish directory: public  →  Deploy ✅"
