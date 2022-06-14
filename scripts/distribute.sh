#!/usr/bin/env bash

set -e

export FIREBASE_TOKEN="1//03Sndls5DItcACgYIARAAGAMSNwF-L9Ir4GA6oeaFoH9P4wuJU6Qow0RZ13jKTPYfU-qs5Z2jHjX9AiWO-wtpW4cvJWrCpNfGns8"

flutter clean
flutter pub get
flutter build apk -t lib/main/main.dart

cd android
./gradlew appDistributionUploadRelease