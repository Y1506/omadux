#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 3: Async pluginApi Injection & omarchyPlugins Test"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# 1. Bar.qml must have onPluginApiChanged handler and pass pluginApi to handovers
echo "Checking Bar.qml onPluginApiChanged and handover bindings..."
BAR_QML="$REPO_DIR/Bar.qml"
if ! grep -q "onPluginApiChanged:" "$BAR_QML"; then
    echo "FAIL: Bar.qml missing onPluginApiChanged" >&2
    exit 1
fi
for handover in "handover" "notifHandover" "osdHandover" "lockHandover" "kbService"; do
    if ! grep -B 2 -A 5 "id:[[:space:]]*${handover}" "$BAR_QML" | grep -q "pluginApi: root.pluginApi"; then
        echo "FAIL: Bar.qml does not pass pluginApi to $handover" >&2
        exit 1
    fi
done
echo "✓ Bar.qml has onPluginApiChanged and forwards pluginApi to all handovers"

# 2. Handovers must have property var pluginApi and onPluginApiChanged
echo "Checking Handover files for pluginApi property and onPluginApiChanged..."
for file in "Handover.qml" "OsdHandover.qml" "NotifHandover.qml" "LockHandover.qml" "KbService.qml"; do
    path="$REPO_DIR/omarchy/$file"
    if ! grep -q "property var pluginApi" "$path"; then
        echo "FAIL: omarchy/$file missing property var pluginApi" >&2
        exit 1
    fi
    if ! grep -q "onPluginApiChanged" "$path"; then
        echo "FAIL: omarchy/$file missing onPluginApiChanged" >&2
        exit 1
    fi
done
echo "✓ All omarchy handovers react to pluginApi changes"

# 3. WidgetsTab.qml widgetAvailability must explicitly enable omarchyPlugins
echo "Checking WidgetsTab.qml omarchyPlugins availability..."
WIDGETS_TAB="$REPO_DIR/quickshell/Modules/Settings/WidgetsTab.qml"
if ! grep -A 4 '"omarchyPlugins":' "$WIDGETS_TAB" | grep -q '"enabled": true'; then
    echo "FAIL: WidgetsTab.qml does not explicitly mark omarchyPlugins as enabled: true" >&2
    exit 1
fi
echo "✓ WidgetsTab.qml marks omarchyPlugins enabled: true"

echo "✓ All Task 3 checks passed"
