#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 3 DMS Daemon Lifecycle Verification Suite"

PLUGIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DMS_BIN="$PLUGIN_DIR/bin/dms"

if [[ ! -x "$DMS_BIN" ]]; then
    echo "ERROR: bin/dms is not executable" >&2
    exit 1
fi

if [[ ! -f "$PLUGIN_DIR/omarchy/DmsProcess.qml" ]]; then
    echo "ERROR: omarchy/DmsProcess.qml does not exist" >&2
    exit 1
fi

if [[ ! -f "$PLUGIN_DIR/omarchy/qmldir" ]]; then
    echo "ERROR: omarchy/qmldir does not exist" >&2
    exit 1
fi

grep -q "DmsProcess" "$PLUGIN_DIR/omarchy/qmldir" || {
    echo "ERROR: DmsProcess not registered in omarchy/qmldir" >&2
    exit 1
}

echo "✓ DmsProcess.qml and omarchy/qmldir exist and are declared"

# Test running dms daemon directly with OMADUX_DISABLE_EXTERNAL_DEPLOY=1 in test environment
TEST_SOCK="/tmp/test-omadux-dms-$$.sock"
rm -f "$TEST_SOCK"

OMADUX_DISABLE_EXTERNAL_DEPLOY=1 DMS_SOCKET="$TEST_SOCK" "$DMS_BIN" run --session >/tmp/test-dms-$$.log 2>&1 &
DMS_PID=$!

cleanup() {
    kill -TERM "$DMS_PID" 2>/dev/null || true
    wait "$DMS_PID" 2>/dev/null || true
    rm -f "$TEST_SOCK" "/tmp/test-dms-$$.log"
}
trap cleanup EXIT

# Wait up to 5s for socket or process startup
for i in {1..25}; do
    if kill -0 "$DMS_PID" 2>/dev/null; then
        break
    fi
    sleep 0.1
done

if ! kill -0 "$DMS_PID" 2>/dev/null; then
    echo "ERROR: dms process failed to launch. Log:" >&2
    cat "/tmp/test-dms-$$.log" >&2
    exit 1
fi

echo "✓ dms process launched successfully (PID: $DMS_PID)"

# Verify clean SIGTERM shutdown
kill -TERM "$DMS_PID"
for i in {1..20}; do
    if ! kill -0 "$DMS_PID" 2>/dev/null; then
        break
    fi
    sleep 0.1
done

if kill -0 "$DMS_PID" 2>/dev/null; then
    echo "ERROR: dms process did not terminate cleanly on SIGTERM" >&2
    exit 1
fi

echo "✓ dms terminated cleanly on SIGTERM"
echo "ALL TESTS PASSED for Task 3"
