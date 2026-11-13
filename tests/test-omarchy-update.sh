#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Task 6 Omarchy Update Dispatch Test ==="

FAILED=0

# Check 1: backend_pacman.go checks for omarchy binary
if ! grep -q 'commandExists("omarchy")' core/internal/server/sysupdate/backend_pacman.go; then
    echo "[FAIL] core/internal/server/sysupdate/backend_pacman.go missing commandExists(\"omarchy\")"
    FAILED=1
else
    echo "[PASS] core/internal/server/sysupdate/backend_pacman.go checks for omarchy command"
fi

# Check 2: backend_pacman.go dispatches omarchy update
if ! grep -q '"omarchy", "update"' core/internal/server/sysupdate/backend_pacman.go; then
    echo "[FAIL] core/internal/server/sysupdate/backend_pacman.go missing [\"omarchy\", \"update\"] dispatch"
    FAILED=1
else
    echo "[PASS] core/internal/server/sysupdate/backend_pacman.go dispatches omarchy update"
fi

# Check 3: Go unit tests for sysupdate pass
if ! (cd core && go test -v ./internal/server/sysupdate/); then
    echo "[FAIL] go test ./internal/server/sysupdate/ failed"
    FAILED=1
else
    echo "[PASS] go test ./internal/server/sysupdate/ succeeded"
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== Task 6 Tests FAILED (RED) ==="
    exit 1
fi

echo "=== Task 6 Tests PASSED (GREEN) ==="
exit 0
