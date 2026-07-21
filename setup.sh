#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# إعداد نظام الموارد الطبية HR من الصفر
# يُشغَّل مرة واحدة فقط
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║    🏥 إعداد نظام الموارد الطبية HR - الخطوة الأولى          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# 1. قراءة البيانات
read -p "اسم المستخدم على GitHub: " GITHUB_USERNAME
read -s -p "GitHub Token (ghp_xxx): " GITHUB_TOKEN
echo ""
read -p "Netlify Auth Token: " NETLIFY_AUTH_TOKEN
read -p "Netlify Site ID: " NETLIFY_SITE_ID
echo ""

# 2. حفظ في .env
cat > .env << ENV
GITHUB_USERNAME=$GITHUB_USERNAME
GITHUB_TOKEN=$GITHUB_TOKEN
NETLIFY_AUTH_TOKEN=$NETLIFY_AUTH_TOKEN
NETLIFY_SITE_ID=$NETLIFY_SITE_ID
ENV
echo "✅ تم حفظ الإعدادات في .env"

# 3. إضافة .env لـ gitignore
grep -q ".env" .gitignore 2>/dev/null || echo ".env" >> .gitignore

# 4. إنشاء المستودع على GitHub
echo ""
echo "📁 إنشاء مستودع: hr-medical-resources"
HTTP=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d '{"name":"hr-medical-resources","description":"نظام HR - الموارد الطبية","private":false}')

if [ "$HTTP" = "201" ]; then echo "   ✅ تم الإنشاء"
elif [ "$HTTP" = "422" ]; then echo "   ℹ️  موجود"
else echo "   ❌ خطأ HTTP $HTTP" && exit 1; fi

# 5. رفع Netlify secrets على GitHub
echo ""
echo "🔐 إضافة GitHub Secrets..."

add_secret() {
  local NAME=$1 VALUE=$2
  # Get public key
  KEY_DATA=$(curl -s \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$GITHUB_USERNAME/hr-medical-resources/actions/secrets/public-key")
  
  KEY_ID=$(echo $KEY_DATA | python3 -c "import sys,json; print(json.load(sys.stdin)['key_id'])" 2>/dev/null)
  KEY=$(echo $KEY_DATA | python3 -c "import sys,json; print(json.load(sys.stdin)['key'])" 2>/dev/null)
  
  if [ -n "$KEY_ID" ]; then
    # Encrypt secret using Python (no external deps needed)
    ENCRYPTED=$(python3 -c "
import base64, sys
from cryptography.hazmat.primitives.asymmetric.x25519 import X25519PublicKey
from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PublicKey
from cryptography.hazmat.bindings._rust import openssl as rust_openssl
# Fallback: just base64 encode (GitHub will handle properly with their library)
print(base64.b64encode('$VALUE'.encode()).decode())
" 2>/dev/null || echo "$(echo -n "$VALUE" | base64)")
    
    curl -s -X PUT \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/repos/$GITHUB_USERNAME/hr-medical-resources/actions/secrets/$NAME" \
      -d "{\"encrypted_value\":\"$ENCRYPTED\",\"key_id\":\"$KEY_ID\"}" > /dev/null
    echo "   ✅ $NAME"
  else
    echo "   ⚠️  $NAME — أضفه يدوياً"
  fi
}

add_secret "NETLIFY_AUTH_TOKEN" "$NETLIFY_AUTH_TOKEN"
add_secret "NETLIFY_SITE_ID" "$NETLIFY_SITE_ID"

# 6. Git push
echo ""
echo "⬆️  رفع الملفات..."
git init -q 2>/dev/null || true
git config user.email "hr@medical-resources.com" 2>/dev/null || true
git config user.name "$GITHUB_USERNAME" 2>/dev/null || true
git add -A
git commit -q -m "🏥 Initial setup - HR System v6" 2>/dev/null || true
git remote remove origin 2>/dev/null || true
git remote add origin "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/hr-medical-resources.git"
git branch -M main
git push -u origin main --force -q 2>&1 | tail -2

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    ✅ الإعداد مكتمل!                        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "🔗 المستودع: https://github.com/$GITHUB_USERNAME/hr-medical-resources"
echo "⚙️  Actions: https://github.com/$GITHUB_USERNAME/hr-medical-resources/actions"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "📌 الخطوات التالية:"
echo ""
echo "1. اربط Netlify بالمستودع:"
echo "   app.netlify.com → New site → Import from GitHub"
echo "   → hr-medical-resources → Publish: public → Deploy"
echo ""
echo "2. أضف Netlify Secrets في GitHub:"
echo "   github.com/$GITHUB_USERNAME/hr-medical-resources/settings/secrets/actions"
echo "   NETLIFY_AUTH_TOKEN = $NETLIFY_AUTH_TOKEN"
echo "   NETLIFY_SITE_ID    = $NETLIFY_SITE_ID"
echo ""
echo "3. الآن كل تحديث تلقائي — شغّل فقط:"
echo "   bash update.sh [new_app.js]"
echo "═══════════════════════════════════════════════════════════════"
