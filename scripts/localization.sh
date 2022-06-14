#!/usr/bin/env bash

set -e

BASE_DIR=`dirname $0`

FORMAT="json"
TOKEN="1b6812ef-c535-41d3-bb61-45635fa3ae22"
URL="https://script.google.com/macros/s/AKfycbwPQdlmxpabht5l6abL2ZZMxXKuVj31DZBB-OSBCE-O1OvzTR4MneAVyhxxWUCWXPgX/exec"

wget -O "${BASE_DIR}/../assets/i18n/en.json" "${URL}?locale=en&format=${FORMAT}&token=${TOKEN}"
wget -O "${BASE_DIR}/../assets/i18n/es.json" "${URL}?locale=es&format=${FORMAT}&token=${TOKEN}"

flutter pub upgrade
flutter pub pub run dalocale:dalocale.dart ./assets/i18n/ ./lib/services/localizations.dart en ./lib
flutter format lib --line-length=150