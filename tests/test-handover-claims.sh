#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Task 4 Handover Claims & Actions Test ==="

FAILED=0

# Check 1: scripts/osd-handover writes claim files with pid on claim and unlinks on release
TEST_RT="/tmp/omadux-test-rt-$$"
mkdir -p "$TEST_RT"
export XDG_RUNTIME_DIR="$TEST_RT"

./scripts/osd-handover claim 12345
if [ ! -f "$TEST_RT/omacale-osd-claim.json" ] || [ ! -f "$TEST_RT/omadux-osd-claim.json" ]; then
    echo "[FAIL] scripts/osd-handover claim did not create omacale-osd-claim.json and omadux-osd-claim.json"
    FAILED=1
else
    if ! grep -q '"pid":12345' "$TEST_RT/omacale-osd-claim.json"; then
        echo "[FAIL] omacale-osd-claim.json missing correct pid"
        FAILED=1
    else
        echo "[PASS] scripts/osd-handover claim created valid claim files"
    fi
fi

./scripts/osd-handover release
if [ -f "$TEST_RT/omacale-osd-claim.json" ] || [ -f "$TEST_RT/omadux-osd-claim.json" ]; then
    echo "[FAIL] scripts/osd-handover release did not remove claim files"
    FAILED=1
else
    echo "[PASS] scripts/osd-handover release cleanly removed claim files"
fi

# Check 2: scripts/notif-popups writes claim files with pid on claim and unlinks on release
./scripts/notif-popups claim 12345
if [ ! -f "$TEST_RT/omacale-notifs-claim.json" ] || [ ! -f "$TEST_RT/omadux-notifs-claim.json" ]; then
    echo "[FAIL] scripts/notif-popups claim did not create omacale-notifs-claim.json and omadux-notifs-claim.json"
    FAILED=1
else
    if ! grep -q '"pid":12345' "$TEST_RT/omacale-notifs-claim.json"; then
        echo "[FAIL] omacale-notifs-claim.json missing correct pid"
        FAILED=1
    else
        echo "[PASS] scripts/notif-popups claim created valid claim files"
    fi
fi

./scripts/notif-popups release
if [ -f "$TEST_RT/omacale-notifs-claim.json" ] || [ -f "$TEST_RT/omadux-notifs-claim.json" ]; then
    echo "[FAIL] scripts/notif-popups release did not remove claim files"
    FAILED=1
else
    echo "[PASS] scripts/notif-popups release cleanly removed claim files"
fi

rm -rf "$TEST_RT"

# Check 3: OsdHandover.qml and NotifHandover.qml pass Quickshell.processId
if ! grep -q 'Quickshell.processId' omarchy/OsdHandover.qml; then
    echo "[FAIL] omarchy/OsdHandover.qml must pass Quickshell.processId to osdScript"
    FAILED=1
else
    echo "[PASS] omarchy/OsdHandover.qml passes Quickshell.processId"
fi

if ! grep -q 'Quickshell.processId' omarchy/NotifHandover.qml; then
    echo "[FAIL] omarchy/NotifHandover.qml must pass Quickshell.processId to notifScript"
    FAILED=1
else
    echo "[PASS] omarchy/NotifHandover.qml passes Quickshell.processId"
fi

# Check 4: NotificationPopup.qml preserves invoke function in snapshotNotification
if ! grep -q '"invoke":' quickshell/Modules/Notifications/Popup/NotificationPopup.qml; then
    echo "[FAIL] quickshell/Modules/Notifications/Popup/NotificationPopup.qml missing action invoke preservation in snapshot"
    FAILED=1
else
    echo "[PASS] quickshell/Modules/Notifications/Popup/NotificationPopup.qml preserves action invoke"
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== Task 4 Tests FAILED (RED) ==="
    exit 1
fi

echo "=== Task 4 Tests PASSED (GREEN) ==="
exit 0
