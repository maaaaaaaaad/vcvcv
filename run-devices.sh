#!/bin/bash

set -euo pipefail

IOS_UDID="81D1F7B9-4C47-4C98-A939-3F4CF33A232E"
ANDROID_AVD_NAME="Medium_Phone_API_36.0"

prepare_project() {
  echo "Preparing Flutter project (pub get + generate native splash)..."
  if command -v flutter >/dev/null 2>&1; then
    flutter pub get
  else
    echo "Error: 'flutter' not found in PATH" >&2
    exit 1
  fi

  if command -v dart >/dev/null 2>&1; then
    dart run flutter_native_splash:create || flutter pub run flutter_native_splash:create
  else
    flutter pub run flutter_native_splash:create
  fi

  echo "Project prepared."
}

ensure_simulator_app() {
  if ! pgrep -x "Simulator" >/dev/null; then
    echo "Launching Simulator.app..."
    open -a Simulator || true

    sleep 2
  fi
}

boot_ios_simulator() {
  echo "Booting iOS Simulator ($IOS_UDID)..."

  ensure_simulator_app

  state=$(xcrun simctl list devices | awk -v id="$IOS_UDID" '$0 ~ id {print $0}' | grep -q "(Booted)" && echo Booted || echo Shutdown)
  if [ "$state" != "Booted" ]; then
    xcrun simctl boot "$IOS_UDID" || true
  fi

  open -a Simulator --args -CurrentDeviceUDID "$IOS_UDID" || true

  echo "Waiting for iOS Simulator to finish booting..."
  xcrun simctl bootstatus "$IOS_UDID" -b
  echo "iOS Simulator is ready."
}

boot_android_emulator() {
  echo "Starting Android Emulator..."
  emulator -avd "$ANDROID_AVD_NAME" &
  adb wait-for-device
  while true; do
    boot_completed=$(adb shell getprop sys.boot_completed | tr -d '\r')
    if [[ "$boot_completed" == "1" ]]; then
      break
    fi
    echo "Waiting for Android Emulator to boot... Current state: $boot_completed"
    sleep 5
  done
  echo "Android Emulator is ready."
}

prepare_project

boot_ios_simulator &
ios_pid=$!

boot_android_emulator &
android_pid=$!

wait $ios_pid
wait $android_pid

echo "Running app on all connected devices..."
flutter run -d all