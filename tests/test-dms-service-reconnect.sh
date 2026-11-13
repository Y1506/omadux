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

# Check 2: DSocket.qml onPathChanged restarts socket when connected
if ! grep -q 'onPathChanged:.*_restartSocket' quickshell/Common/DSocket.qml; then
    echo "[FAIL] quickshell/Common/DSocket.qml missing onPathChanged: { if (connected) _restartSocket(); }"
    FAILED=1
else
    echo "[PASS] quickshell/Common/DSocket.qml has onPathChanged handler"
fi

if ! grep -q 'onPathChanged:.*_restartSocket' quickshell/DCommon/Common/DSocket.qml; then
    echo "[FAIL] quickshell/DCommon/Common/DSocket.qml missing onPathChanged: { if (connected) _restartSocket(); }"
    FAILED=1
else
    echo "[PASS] quickshell/DCommon/Common/DSocket.qml has onPathChanged handler"
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
