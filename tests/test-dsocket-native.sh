#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Test: Native DSocket & DMS Socket Connection ==="

FAILED=0

# Check 1: DSocket.qml in Common, DCommon, and DankSocket must inherit Socket and NOT shadow connected
for f in quickshell/Common/DSocket.qml quickshell/DCommon/Common/DSocket.qml quickshell/Common/DankSocket.qml; do
    if grep -q 'property bool connected' "$f"; then
        echo "[FAIL] $f shadows native Socket.connected with 'property bool connected'"
        FAILED=1
    else
        echo "[PASS] $f does not shadow Socket.connected"
    fi

    if grep -q '_restartSocket' "$f"; then
        echo "[FAIL] $f calls non-existent _restartSocket"
        FAILED=1
    else
        echo "[PASS] $f does not call _restartSocket"
    fi

    if ! grep -q 'readonly property bool linkUp: connected' "$f"; then
        echo "[FAIL] $f missing 'readonly property bool linkUp: connected'"
        FAILED=1
    else
        echo "[PASS] $f has linkUp alias"
    fi
done

# Check 2: Live Quickshell DSocket connect test against /run/user/1000/dms.sock
if [ -S "/run/user/$(id -u)/dms.sock" ]; then
    echo "Testing live DSocket connection via quickshell..."
    TEST_QML="/tmp/test-live-dsocket-run.qml"
    cat << EOF > "$TEST_QML"
import QtQuick
import Quickshell
import Quickshell.Io
import "file:$REPO_ROOT/quickshell/DCommon/Common" as DCommon

Scope {
    id: root

    property bool receivedResponse: false

    DCommon.DSocket {
        id: sock
        path: "/run/user/$(id -u)/dms.sock"
        parser: SplitParser {
            onRead: line => {
                console.log("TEST_DSOCKET_READ:", line)
                root.receivedResponse = true
                Qt.quit()
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        onTriggered: {
            console.log("TEST_DSOCKET_TIMEOUT")
            Qt.quit()
        }
    }
}
EOF
    OUT=$(quickshell -p "$TEST_QML" 2>&1 || true)
    if echo "$OUT" | grep -q "TEST_DSOCKET_READ:"; then
        echo "[PASS] Live DSocket connected and received data from dms.sock"
    else
        echo "[FAIL] Live DSocket failed to connect or receive data from dms.sock"
        echo "$OUT" | tail -n 20
        FAILED=1
    fi
    rm -f "$TEST_QML"
else
    echo "[WARN] /run/user/$(id -u)/dms.sock not found, skipping live socket test"
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== Test FAILED (RED) ==="
    exit 1
fi

echo "=== Test PASSED (GREEN) ==="
exit 0
