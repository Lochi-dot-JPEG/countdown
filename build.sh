#!/bin/sh

mkdir output
rm countdown.love
zip -9 -r countdown.love .
npx love.js -c countdown.love output -m 106777216
cd output
python -m http.server 8000
