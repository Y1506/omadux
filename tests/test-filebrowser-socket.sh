#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 2: FileBrowser & Plugin DMS Socket Connection Test"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# 1. Bar.qml must initialize Host.files and DC.Host.files to FilesService
echo "Checking Host.files and DC.Host.files initialization in Bar.qml..."
BAR_QML="$REPO_DIR/Bar.qml"
if ! grep -q "Host.files = FilesService" "$BAR_QML"; then
    echo "FAIL: Bar.qml does not wire Host.files = FilesService" >&2
    exit 1
fi
if ! grep -q "DC.Host.files = FilesService" "$BAR_QML"; then
    echo "FAIL: Bar.qml does not wire DC.Host.files = FilesService" >&2
    exit 1
fi
echo "✓ Bar.qml wires Host.files and DC.Host.files to FilesService"

# 2. Go daemon runDaemonOnly in commands_common.go must clean stale sockets and maintain dms.sock symlink
echo "Checking stale socket cleanup and dms.sock symlink in commands_common.go..."
GO_COMMON="$REPO_DIR/core/cmd/dms/commands_common.go"
if ! grep -q "cleanStaleSockets" "$GO_COMMON"; then
    echo "FAIL: commands_common.go missing cleanStaleSockets" >&2
    exit 1
fi
if ! grep -q "dms.sock" "$GO_COMMON"; then
    echo "FAIL: commands_common.go missing dms.sock symlink logic" >&2
    exit 1
fi
echo "✓ commands_common.go has cleanStaleSockets and dms.sock symlink logic"

# 3. DMSService.qml should support fallback to dms.sock and clean reconnection
echo "Checking DMSService.qml socket resolution..."
DMS_SVC="$REPO_DIR/quickshell/Services/DMSService.qml"
if ! grep -q 'dms.sock' "$DMS_SVC"; then
    echo "FAIL: DMSService.qml missing dms.sock fallback in discovery" >&2
    exit 1
fi
echo "✓ DMSService.qml has dms.sock fallback"

echo "✓ All Task 2 checks passed"
