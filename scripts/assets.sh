#!/usr/bin/env bash

set -e

flutter clean
flutter pub upgrade
flutter pub pub run daassets:daassets.dart ./pubspec.yaml ./lib/services/assets.dart
flutter format lib --line-length=150