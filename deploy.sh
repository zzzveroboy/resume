#!/usr/bin/env sh

# остановить публикацию при ошибках
set -e

# сборка
npm run build

# переход в каталог сборки
cd dist

# если вы публикуете на пользовательский домен
echo 'webmacaque.ru' > CNAME

git init
git add -A
git commit -m 'deploy'

# если вы публикуете по адресу https://<USERNAME>.github.io
# git push -f git@github.com:<USERNAME>/<USERNAME>.github.io.git gh-pages

# если вы публикуете по адресу https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:zzzveroboy/resume.git master:gh-pages
# git@github.com:zzzveroboy/resume.git gh-pages

cd -