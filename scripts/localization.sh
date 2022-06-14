#!/usr/bin/env bash

set -e

BASE_DIR=`dirname $0`

FORMAT="json"
TOKEN="ce0e7ea2-c2bc-4a3c-b817-7d1f3259f607"
URL="https://script.google.com/macros/s/AKfycbyQHqel3bsdVdjW3kJWLS8uRJzdJSVSXSiZtSmerBOC25Gff6-4ZsmOVV-HQUKn40oE/exec"

wget -O "${BASE_DIR}/../assets/i18n/en.json" "${URL}?locale=en&format=${FORMAT}&token=${TOKEN}"
wget -O "${BASE_DIR}/../assets/i18n/fr.json" "${URL}?locale=fr&format=${FORMAT}&token=${TOKEN}"

flutter pub upgrade
flutter pub pub run dalocale:dalocale.dart ./assets/i18n/ ./lib/services/localizations.dart en ./lib
flutter format lib --line-length=150