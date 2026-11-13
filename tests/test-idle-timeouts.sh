#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Task 7 Idle Timeouts & Service Test ==="

FAILED=0

# Check 1: SettingsSpec.js has non-zero timeout defaults
if grep -A 2 'acMonitorTimeout:' quickshell/Common/settings/SettingsSpec.js | grep -q 'def: 0'; then
    echo "[FAIL] SettingsSpec.js acMonitorTimeout has default 0 instead of 300"
    FAILED=1
else
    echo "[PASS] SettingsSpec.js acMonitorTimeout has positive default"
fi

if grep -A 2 'batteryMonitorTimeout:' quickshell/Common/settings/SettingsSpec.js | grep -q 'def: 0'; then
    echo "[FAIL] SettingsSpec.js batteryMonitorTimeout has default 0 instead of 180"
    FAILED=1
else
    echo "[PASS] SettingsSpec.js batteryMonitorTimeout has positive default"
fi

# Check 2: SettingsData.qml has bat* aliases
for key in batMonitorTimeout batLockTimeout batSuspendTimeout; do
    if ! grep -q "property alias $key:" quickshell/Common/SettingsData.qml; then
        echo "[FAIL] SettingsData.qml missing alias $key"
        FAILED=1
    else
        echo "[PASS] SettingsData.qml defines alias $key"
    fi
done

# Check 3: IdleService.qml defines actualInhibitReason
if ! grep -q 'actualInhibitReason' quickshell/Services/IdleService.qml; then
    echo "[FAIL] quickshell/Services/IdleService.qml missing actualInhibitReason property"
    FAILED=1
else
    echo "[PASS] quickshell/Services/IdleService.qml defines actualInhibitReason"
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== Task 7 Tests FAILED (RED) ==="
    exit 1
fi

echo "=== Task 7 Tests PASSED (GREEN) ==="
exit 0
