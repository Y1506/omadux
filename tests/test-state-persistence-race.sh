#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Test: State Persistence Race & Reload Clobbering ==="

FAILED=0

# Check 1: SettingsData.qml exposes _isLoaded
if ! grep -q "readonly property bool _isLoaded:" quickshell/Common/SettingsData.qml; then
    echo "[FAIL] SettingsData.qml missing readonly property bool _isLoaded"
    FAILED=1
else
    echo "[PASS] SettingsData.qml exposes _isLoaded"
fi

# Check 2: SessionData.qml exposes _isLoaded
if ! grep -q "readonly property bool _isLoaded:" quickshell/Common/SessionData.qml; then
    echo "[FAIL] SessionData.qml missing readonly property bool _isLoaded"
    FAILED=1
else
    echo "[PASS] SessionData.qml exposes _isLoaded"
fi

# Check 3: SettingsData.qml saveSettings gates on !_hasLoaded
if ! grep -A 5 "function saveSettings()" quickshell/Common/SettingsData.qml | grep -q "!_hasLoaded"; then
    echo "[FAIL] SettingsData.qml saveSettings() does not check !_hasLoaded"
    FAILED=1
else
    echo "[PASS] SettingsData.qml saveSettings() checks !_hasLoaded"
fi

# Check 4: SettingsData.qml has flushSettings() and Component.onDestruction
if ! grep -q "function flushSettings()" quickshell/Common/SettingsData.qml; then
    echo "[FAIL] SettingsData.qml missing function flushSettings()"
    FAILED=1
else
    echo "[PASS] SettingsData.qml defines flushSettings()"
fi

if ! grep -q "Component.onDestruction: flushSettings()" quickshell/Common/SettingsData.qml && \
   ! grep -A 3 "Component.onDestruction" quickshell/Common/SettingsData.qml | grep -q "flushSettings"; then
    echo "[FAIL] SettingsData.qml missing Component.onDestruction flushSettings hook"
    FAILED=1
else
    echo "[PASS] SettingsData.qml has Component.onDestruction flushSettings hook"
fi

# Check 5: SessionData.qml settingsFile handles onLoadFailed
if ! grep -A 15 "id: settingsFile" quickshell/Common/SessionData.qml | grep -q "onLoadFailed"; then
    echo "[FAIL] SessionData.qml settingsFile missing onLoadFailed handler"
    FAILED=1
else
    echo "[PASS] SessionData.qml settingsFile handles onLoadFailed"
fi

# Check 6: SessionData.qml has Component.onDestruction
if ! grep -q "Component.onDestruction" quickshell/Common/SessionData.qml; then
    echo "[FAIL] SessionData.qml missing Component.onDestruction flush hook"
    FAILED=1
else
    echo "[PASS] SessionData.qml has Component.onDestruction flush hook"
fi

# Check 7: OmarchyThemeSync.qml guards applyTheme with readiness checks
if ! grep -A 25 "function applyTheme()" omarchy/OmarchyThemeSync.qml | grep -q "_isLoaded"; then
    echo "[FAIL] OmarchyThemeSync.qml applyTheme() does not guard on _isLoaded"
    FAILED=1
else
    echo "[PASS] OmarchyThemeSync.qml applyTheme() guards on _isLoaded"
fi

# Check 8: scripts/osd-handover and scripts/notif-popups do not mutate shell.json
if grep -q "shell.json" scripts/osd-handover; then
    echo "[FAIL] scripts/osd-handover still mutates shell.json"
    FAILED=1
else
    echo "[PASS] scripts/osd-handover does not mutate shell.json"
fi

if grep -q "shell.json" scripts/notif-popups; then
    echo "[FAIL] scripts/notif-popups still mutates shell.json"
    FAILED=1
else
    echo "[PASS] scripts/notif-popups does not mutate shell.json"
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== State Persistence Race Tests FAILED (RED) ==="
    exit 1
fi

echo "=== State Persistence Race Tests PASSED (GREEN) ==="
exit 0
