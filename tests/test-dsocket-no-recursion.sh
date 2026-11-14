#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Test: DSocket No Recursion & DMSService Bindings ==="

FAILED=0

# Check 1: DSocket files must NOT have onPathChanged overriding connected
for f in quickshell/Common/DSocket.qml quickshell/DCommon/Common/DSocket.qml quickshell/Common/DankSocket.qml; do
    if grep -q 'onPathChanged' "$f"; then
        echo "[FAIL] $f contains onPathChanged handler which breaks declarative bindings"
        FAILED=1
    else
        echo "[PASS] $f does not contain onPathChanged"
    fi

    if grep -q 'onConnectionStateChanged' "$f"; then
        echo "[FAIL] $f contains onConnectionStateChanged which risks infinite recursion"
        FAILED=1
    else
        echo "[PASS] $f does not contain onConnectionStateChanged"
    fi
done

# Check 2: DMSService.qml must have onSocketPathChanged
if ! grep -q 'onSocketPathChanged' quickshell/Services/DMSService.qml; then
    echo "[FAIL] DMSService.qml missing onSocketPathChanged reconnect handler"
    FAILED=1
else
    echo "[PASS] DMSService.qml has onSocketPathChanged reconnect handler"
fi

# Check 3: DMSService.qml requestSocket must bind connected: root.socketPath.length > 0
if ! grep -q 'connected: root.socketPath.length > 0' quickshell/Services/DMSService.qml; then
    echo "[FAIL] DMSService.qml requestSocket does not bind connected: root.socketPath.length > 0"
    FAILED=1
else
    echo "[PASS] DMSService.qml requestSocket binds connected: root.socketPath.length > 0"
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== Test FAILED (RED) ==="
    exit 1
fi

echo "=== Test PASSED (GREEN) ==="
exit 0
