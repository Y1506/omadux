#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Task 5 DMS IPC Omarchy Discovery Test ==="

FAILED=0

# Check 1: qsipc package provides DiscoverSocket
if ! grep -q "func DiscoverSocket" core/internal/qsipc/client.go; then
    echo "[FAIL] core/internal/qsipc/client.go missing func DiscoverSocket"
    FAILED=1
else
    echo "[PASS] core/internal/qsipc/client.go defines func DiscoverSocket"
fi

# Check 2: core/cmd/dms/shell.go uses DiscoverSocket or omarchy discovery in tryDirectIPCCall
if ! grep -q "DiscoverSocket" core/cmd/dms/shell.go; then
    echo "[FAIL] core/cmd/dms/shell.go tryDirectIPCCall does not use DiscoverSocket"
    FAILED=1
else
    echo "[PASS] core/cmd/dms/shell.go uses DiscoverSocket"
fi

# Check 3: Bar.qml defines IpcHandler with target "omadux"
if ! grep -q 'target: "omadux"' Bar.qml; then
    echo "[FAIL] Bar.qml missing IpcHandler target: \"omadux\""
    FAILED=1
else
    echo "[PASS] Bar.qml defines IpcHandler target: \"omadux\""
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== Task 5 Tests FAILED (RED) ==="
    exit 1
fi

echo "=== Task 5 Tests PASSED (GREEN) ==="
exit 0
