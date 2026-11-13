#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 7 Root Bar & Quattro Contract Verification Suite"

PLUGIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# 1. Validate manifest.json and plugin entry points using omarchy plugin validate
if command -v omarchy-plugin-validate >/dev/null 2>&1 || command -v omarchy >/dev/null 2>&1; then
    omarchy plugin validate "$PLUGIN_DIR"
    echo "✓ omarchy plugin validate passed"
fi

# 2. Check root Bar.qml contract
BAR_QML="$PLUGIN_DIR/Bar.qml"
grep -q "property var pluginApi" "$BAR_QML" || {
    echo "FAIL: Bar.qml missing property var pluginApi" >&2
    exit 1
}

grep -q 'target: "plugin:y1506.omadux.bar"' "$BAR_QML" || {
    echo "FAIL: Bar.qml missing IpcHandler for plugin:y1506.omadux.bar" >&2
    exit 1
}

# 3. Check IPC routing methods exist in Bar.qml
for method in "launcher" "emoji" "clipboard" "settings" "session" "keybinds" "dnd" "notifications" "lock" "unlock" "volUp" "volDown" "briUp"; do
    grep -q "function ${method}(" "$BAR_QML" || {
        echo "FAIL: Bar.qml missing IPC method ${method}()" >&2
        exit 1
    }
done
echo "✓ All required IPC routing methods present in Bar.qml"

# 4. Check that services are instantiated
for svc in "DmsProcess" "Handover" "NotifHandover" "OsdHandover" "LockHandover" "KbService" "OmarchyThemeSync" "DMSShell"; do
    grep -q "${svc}[[:space:]]*{" "$BAR_QML" || {
        echo "FAIL: Bar.qml missing instantiation of ${svc}" >&2
        exit 1
    }
done
echo "✓ All runtime services instantiated in Bar.qml"

# 5. Check root qmldir exists and declares Bar
ROOT_QMLDIR="$PLUGIN_DIR/qmldir"
[[ -f "$ROOT_QMLDIR" ]] || { echo "FAIL: Missing root qmldir"; exit 1; }
grep -q "Bar 1.0 Bar.qml" "$ROOT_QMLDIR" || { echo "FAIL: Root qmldir missing Bar declaration"; exit 1; }
echo "✓ Root qmldir verified"

echo "ALL TESTS PASSED for Task 7"
