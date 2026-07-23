#!/bin/sh

mkdir export_dir
rm countdown.love
zip -9 -r countdown.love .
npx love.js countdown.love export_dir
cd export_dir
python -m http.server 8000
