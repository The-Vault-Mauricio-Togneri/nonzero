#!/usr/bin/env bash

set -e

export FIREBASE_TOKEN="1//09YnM4v6IIZ7ZCgYIARAAGAkSNwF-L9IrMoHjsUzNDkR_QekDg9fo7SF9Dct07YYqrcnxvHZi95R-ajokc8WXjC3gkYbimC7U1BE"

flutter clean
flutter pub get
flutter build apk -t lib/main/main.dart

cd android
./gradlew appDistributionUploadRelease