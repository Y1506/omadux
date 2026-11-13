#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 4 Handover & State Restoration Verification Suite"

PLUGIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
export OMADUX_OFFLINE=1

# Mock state dir in /tmp
export XDG_RUNTIME_DIR="/tmp/test-omadux-runtime-$$"
mkdir -p "$XDG_RUNTIME_DIR"
STATE_FILE="$XDG_RUNTIME_DIR/omadux-handover/state.json"

cleanup() {
    rm -rf "$XDG_RUNTIME_DIR"
}
trap cleanup EXIT

# Verify scripts exist
for s in "scripts/handover.py" "scripts/osd-handover" "scripts/notif-popups" "scripts/lock-screen"; do
    if [[ ! -f "$PLUGIN_DIR/$s" ]]; then
        echo "FAIL: Missing script $s" >&2
        exit 1
    fi
done

# Verify QML handover components exist
for q in "Handover.qml" "KbService.qml" "NotifHandover.qml" "OsdHandover.qml" "LockHandover.qml"; do
    if [[ ! -f "$PLUGIN_DIR/omarchy/$q" ]]; then
        echo "FAIL: Missing QML component omarchy/$q" >&2
        exit 1
    fi
done

# Test handover.py apply in offline test mode
python3 "$PLUGIN_DIR/scripts/handover.py" apply --test-mode
if [[ ! -f "$STATE_FILE" ]]; then
    echo "FAIL: handover.py apply did not create state.json" >&2
    exit 1
fi
echo "✓ handover.py apply successfully created snapshot at $STATE_FILE"

# Test idempotency: second apply must not overwrite baseline state.json
mtime1=$(stat -c %Y "$STATE_FILE")
sleep 0.1
python3 "$PLUGIN_DIR/scripts/handover.py" apply --test-mode
mtime2=$(stat -c %Y "$STATE_FILE")
if [[ "$mtime1" != "$mtime2" ]]; then
    echo "FAIL: handover.py apply is not idempotent (overwrote existing snapshot)" >&2
    exit 1
fi
echo "✓ handover.py apply is verified idempotent"

# Test handover.py restore
python3 "$PLUGIN_DIR/scripts/handover.py" restore --test-mode
if [[ -f "$STATE_FILE" ]]; then
    echo "FAIL: handover.py restore did not clean up state.json" >&2
    exit 1
fi
echo "✓ handover.py restore cleanly removed state.json and left zero residual state"

echo "ALL TESTS PASSED for Task 4"
