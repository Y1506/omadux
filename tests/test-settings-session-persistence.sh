#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Task 2 Persistence & Auto-Hide Test ==="

FAILED=0

# Check 1: setControlCenterWidgets in quickshell/Common/SettingsData.qml
if ! grep -q "function setControlCenterWidgets" quickshell/Common/SettingsData.qml; then
    echo "[FAIL] SettingsData.qml missing function setControlCenterWidgets"
    FAILED=1
else
    echo "[PASS] SettingsData.qml defines function setControlCenterWidgets"
fi

# Check 2: profileImage in SharedSessionSpec.js
if ! grep -q "profileImage:" quickshell/Common/settings/SharedSessionSpec.js; then
    echo "[FAIL] quickshell/Common/settings/SharedSessionSpec.js missing profileImage"
    FAILED=1
else
    echo "[PASS] quickshell/Common/settings/SharedSessionSpec.js defines profileImage"
fi

if ! grep -q "profileImage:" quickshell/DCommon/Common/settings/SharedSessionSpec.js; then
    echo "[FAIL] quickshell/DCommon/Common/settings/SharedSessionSpec.js missing profileImage"
    FAILED=1
else
    echo "[PASS] quickshell/DCommon/Common/settings/SharedSessionSpec.js defines profileImage"
fi

# Check 3: profileImage in SessionData.qml
if ! grep -q "property string profileImage" quickshell/Common/SessionData.qml; then
    echo "[FAIL] quickshell/Common/SessionData.qml missing property string profileImage"
    FAILED=1
else
    echo "[PASS] quickshell/Common/SessionData.qml defines property string profileImage"
fi

# Check 4: omadux*Takeover in SettingsData.qml
for key in omaduxOsdTakeover omaduxNotifTakeover omaduxKeybindTakeover omaduxLockTakeover; do
    if ! grep -q "$key" quickshell/Common/SettingsData.qml; then
        echo "[FAIL] quickshell/Common/SettingsData.qml missing $key"
        FAILED=1
    else
        echo "[PASS] quickshell/Common/SettingsData.qml defines $key"
    fi
done

# Check 5: DBarWindow.qml edge strip region evaluates active when autoHideActive is true
if ! grep -q "body.autoHideActive ||" quickshell/Modules/DBar/DBarWindow.qml; then
    echo "[FAIL] quickshell/Modules/DBar/DBarWindow.qml line 146 missing body.autoHideActive || fallback"
    FAILED=1
else
    echo "[PASS] quickshell/Modules/DBar/DBarWindow.qml autoHideActive reveals edge strip"
fi

# Check 6: PortalService profileImage sets SessionData profileImage
if ! grep -q "SessionData.set(\"profileImage\"" quickshell/Services/PortalService.qml; then
    echo "[FAIL] quickshell/Services/PortalService.qml does not persist profileImage to SessionData"
    FAILED=1
else
    echo "[PASS] quickshell/Services/PortalService.qml persists profileImage to SessionData"
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== Task 2 Tests FAILED (RED) ==="
    exit 1
fi

echo "=== Task 2 Tests PASSED (GREEN) ==="
exit 0
