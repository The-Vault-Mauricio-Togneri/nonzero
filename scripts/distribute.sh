#!/usr/bin/env bash

set -e

# ./gradlew appDistributionLogin
export FIREBASE_TOKEN="1//03862p2TyUaRuCgYIARAAGAMSNwF-L9Irzx68Zyau_jp5IPMzSphXQrahNaXUvR5JQvnoUiJEaRvLiGg6qozBC4c2zJ0o_HNLtpI"

flutter clean
flutter pub get
flutter build apk -t lib/main/main.dart

cd android
./gradlew appDistributionUploadRelease