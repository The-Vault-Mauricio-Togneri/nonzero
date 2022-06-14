#!/usr/bin/env bash

set -e

flutter clean
flutter build web -t lib/main/main.dart --web-renderer canvaskit