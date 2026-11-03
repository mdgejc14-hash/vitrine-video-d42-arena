#!/bin/sh
# Env de build Android reproductible (P2). Idempotent : reinstallable apres tout reset sandbox.
# Usage: . tools-dev/android-env.sh   (source, pas execute)
set -e
C=${VV_TOOLCHAIN:-/home/user/.cache/vv-toolchain}
mkdir -p "$C"
if [ ! -x "$C/jdk/bin/java" ]; then
  if [ -x /usr/lib/jvm/java-21-openjdk-amd64/bin/java ]; then
    ln -sfn /usr/lib/jvm/java-21-openjdk-amd64 "$C/jdk"
  elif [ -x /usr/lib/jvm/java-17-openjdk-amd64/bin/java ]; then
    ln -sfn /usr/lib/jvm/java-17-openjdk-amd64 "$C/jdk"
  else
    (sudo -n apt-get update -qq && sudo -n apt-get install -y -qq openjdk-21-jdk-headless) >/dev/null 2>&1 || true
    ln -sfn /usr/lib/jvm/java-21-openjdk-amd64 "$C/jdk"
  fi
fi
if [ ! -x "$C/android-sdk/cmdline-tools/latest/bin/sdkmanager" ]; then
  mkdir -p "$C/android-sdk/cmdline-tools"
  curl -fsSL -o "$C/cmdtools.zip" https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip
  (cd "$C/android-sdk/cmdline-tools" && unzip -q -o "$C/cmdtools.zip" && mv cmdline-tools latest)
  yes | "$C/jdk/bin/java" -Xmx512m -cp "$C/android-sdk/cmdline-tools/latest/lib/sdkmanager-classpath.jar" com.android.sdklib.tools.SDKManagerHandler --licenses >/dev/null 2>&1 || \
  yes | "$C/android-sdk/cmdline-tools/latest/bin/sdkmanager" --licenses >/dev/null 2>&1 || true
fi
if [ ! -d "$C/android-sdk/platforms/android-36" ]; then
  "$C/android-sdk/cmdline-tools/latest/bin/sdkmanager" "platforms;android-36" "build-tools;36.0.0" >/dev/null 2>&1
fi
export JAVA_HOME="$C/jdk"
export ANDROID_HOME="$C/android-sdk"
export ANDROID_SDK_ROOT="$C/android-sdk"
export GRADLE_USER_HOME="$C/gradle-home"
