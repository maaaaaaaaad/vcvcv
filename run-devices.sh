#!/bin/bash

boot_ios_simulator() {
    echo "Starting iOS Simulator..."
    xcrun simctl boot 81D1F7B9-4C47-4C98-A939-3F4CF33A232E


    while true; do
        state=$(xcrun simctl list --json devices | jq -r '.devices[] | .[] | select(.udid == "81D1F7B9-4C47-4C98-A939-3F4CF33A232E") | .state')
        if [[ "$state" == "Booted" ]]; then
            break
        fi
        echo "Waiting for iOS Simulator to boot... Current state: $state"
        sleep 5
    done
    echo "iOS Simulator is ready."
}

boot_android_emulator() {
    echo "Starting Android Emulator..."
    emulator -avd "Medium_Phone_API_36.0" &


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

boot_ios_simulator &
ios_pid=$!

boot_android_emulator &
android_pid=$!

wait $ios_pid
wait $android_pid

echo "Running app on all connected devices..."
flutter run -d all