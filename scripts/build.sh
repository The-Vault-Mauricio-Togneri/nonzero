#!/usr/bin/env bash

set -e

flutter clean
flutter build web -t lib/main/main.dart --web-renderer canvaskit

OUTPUT="../tensiontunnel-website/public/play"
rm -r ${OUTPUT}
mkdir ${OUTPUT}
cp -r build/web/** ${OUTPUT}
cp -r "${OUTPUT}/assets/assets/models" "${OUTPUT}/assets"
cp -r "${OUTPUT}/assets/assets/audio" "${OUTPUT}/assets"
sed -i'.original' -e 's/<base href=\"\/\">/<base href=\"\/play\/\">/' "../tensiontunnel-website/public/play/index.html"

cd ../tensiontunnel-website
firebase deploy --only hosting
cd ../tensiontunnel