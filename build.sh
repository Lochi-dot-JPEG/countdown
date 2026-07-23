#!/bin/sh

mkdir output
rm countdown.love
zip -9 -r countdown.love .
npx love.js -c countdown.love output
cd output
python -m http.server 8000
