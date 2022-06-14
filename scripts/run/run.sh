#!/usr/bin/env bash

set -e

if [ -n "$1" ]; then
    flutter run -t lib/main/main.dart -d $1
else
    flutter run -t lib/main/main.dart
fi