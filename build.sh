#!/bin/sh

cd textures
sh asepritecompile.sh
cd ..
mkdir output
rm countdown.love
FILES=""

FILES="$FILES $(find -type f -name "*.png")"
FILES="$FILES $(find -type f -name "*.lua")"
FILES="$FILES $(find -type f -name "*.ogg")"
FILES="$FILES $(find -type f -name "*.wav")"
FILES="$FILES $(find -type f -name "*.otf")"
zip -9 -r countdown.love $FILES
npx love.js -c countdown.love output -m 106777216
cd output
python -m http.server 8000
