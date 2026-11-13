#!/usr/bin/env bash
set -euo pipefail

ready=0
for _ in 1 2 3 4 5 6 7 8 9 10 11 12; do
  if adb shell pm path android >/dev/null 2>&1; then
    ready=1
    break
  fi
  sleep 5
done

test "$ready" = 1
flutter test integration_test || flutter test integration_test
