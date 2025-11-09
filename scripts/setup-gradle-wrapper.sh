#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WRAPPER_JAR="${ROOT}/backend/gradle/wrapper/gradle-wrapper.jar"

GRADLE_VERSION="9.2.0"
WRAPPER_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"

if [[ -f "${WRAPPER_JAR}" ]]; then
  echo "Gradle wrapper jar already present at ${WRAPPER_JAR}"
  exit 0
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Downloading Gradle ${GRADLE_VERSION} distribution..."
curl -sSL "${WRAPPER_URL}" -o "${TMP_DIR}/gradle.zip"

echo "Extracting wrapper jar..."
unzip -q "${TMP_DIR}/gradle.zip" "gradle-${GRADLE_VERSION}/lib/gradle-wrapper-*.jar" -d "${TMP_DIR}"

WRAPPER_SOURCE="$(find "${TMP_DIR}/gradle-${GRADLE_VERSION}/lib" -name 'gradle-wrapper-*.jar' -print -quit)"

if [[ -z "${WRAPPER_SOURCE}" ]]; then
  echo "Failed to locate gradle-wrapper jar for Gradle ${GRADLE_VERSION}" >&2
  exit 1
fi

mkdir -p "$(dirname "${WRAPPER_JAR}")"
mv "${WRAPPER_SOURCE}" "${WRAPPER_JAR}"

echo "Gradle wrapper jar installed at ${WRAPPER_JAR}"
