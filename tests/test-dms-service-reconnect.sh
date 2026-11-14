#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Task 3 DMSService & Calendar Reconnect Test ==="

FAILED=0

# Check 1: connectTimer in DMSService.qml runs whenever !isConnected (not blocked by requestSocket.connected)
if ! grep -q 'running: !root.isConnected$' quickshell/Services/DMSService.qml; then
    echo "[FAIL] quickshell/Services/DMSService.qml connectTimer should have running: !root.isConnected"
    FAILED=1
else
    echo "[PASS] quickshell/Services/DMSService.qml connectTimer is properly set to running: !root.isConnected"
fi

# Check 2: DMSService.qml onSocketPathChanged reconnects socket cleanly
if ! grep -q 'onSocketPathChanged:' quickshell/Services/DMSService.qml; then
    echo "[FAIL] quickshell/Services/DMSService.qml missing onSocketPathChanged handler"
    FAILED=1
else
    echo "[PASS] quickshell/Services/DMSService.qml has onSocketPathChanged handler"
fi

if grep -q 'onPathChanged:' quickshell/Common/DSocket.qml; then
    echo "[FAIL] quickshell/Common/DSocket.qml should not contain imperative onPathChanged"
    FAILED=1
else
    echo "[PASS] quickshell/Common/DSocket.qml avoids imperative onPathChanged"
fi

# Check 3: CalendarService.qml dankNeedsLaunch gates on binaryExists
if ! grep -q 'dankBackend.binaryExists && !dankBackend.connected' quickshell/Services/CalendarService.qml; then
    echo "[FAIL] quickshell/Services/CalendarService.qml dankNeedsLaunch must check dankBackend.binaryExists"
    FAILED=1
else
    echo "[PASS] quickshell/Services/CalendarService.qml dankNeedsLaunch gates on dankBackend.binaryExists"
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== Task 3 Tests FAILED (RED) ==="
    exit 1
fi

echo "=== Task 3 Tests PASSED (GREEN) ==="
exit 0
