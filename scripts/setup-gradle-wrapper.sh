#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WRAPPER_JAR="${ROOT}/backend/gradle/wrapper/gradle-wrapper.jar"

GRADLE_VERSION="8.10.1"
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
unzip -q "${TMP_DIR}/gradle.zip" "gradle-${GRADLE_VERSION}/lib/gradle-tooling-api-${GRADLE_VERSION}.jar" -d "${TMP_DIR}"
unzip -q "${TMP_DIR}/gradle.zip" "gradle-${GRADLE_VERSION}/lib/gradle-wrapper-${GRADLE_VERSION}.jar" -d "${TMP_DIR}"

mkdir -p "$(dirname "${WRAPPER_JAR}")"
mv "${TMP_DIR}/gradle-${GRADLE_VERSION}/lib/gradle-wrapper-${GRADLE_VERSION}.jar" "${WRAPPER_JAR}"

echo "Gradle wrapper jar installed at ${WRAPPER_JAR}"
