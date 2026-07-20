#!/bin/bash
U="${1:-}" T="${2:-}" R="hr-medical-resources"
if [ -z "$U" ]||[ -z "$T" ];then echo "bash deploy.sh USERNAME TOKEN";echo "Token: github.com/settings/tokens/new -> repo";exit 1;fi
echo "Deploying to GitHub..."
curl -sf -X POST -H "Authorization: token $T" -H "Accept: application/vnd.github.v3+json" https://api.github.com/user/repos -d "{\"name\":\"$R\",\"private\":false}" >/dev/null 2>&1||true
git init -q;git config user.email "hr@mr.com";git config user.name "$U"
git add -A;git commit -q -m "HR v5 $(date +%Y-%m-%d)" 2>/dev/null||git commit --allow-empty -q -m "update"
git remote remove origin 2>/dev/null;git remote add origin "https://$T@github.com/$U/$R.git"
git branch -M main;git push -u origin main --force -q
echo "Done: https://github.com/$U/$R"
echo "Netlify: app.netlify.com -> New site -> Import -> $R -> Publish: public -> Deploy"
