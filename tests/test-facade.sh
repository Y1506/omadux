#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 6 Dual Plugin Support Verification Suite"

PLUGIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# Verify omarchy facade files exist
for f in "PluginBarFacade.qml" "BarWidgetSlot.qml" "OmarchyPluginService.qml"; do
    if [[ ! -f "$PLUGIN_DIR/omarchy/$f" ]]; then
        echo "FAIL: Missing omarchy/$f" >&2
        exit 1
    fi
done

# Verify DBar widget exists
if [[ ! -f "$PLUGIN_DIR/quickshell/Modules/DBar/Widgets/OmarchyPlugins.qml" ]]; then
    echo "FAIL: Missing quickshell/Modules/DBar/Widgets/OmarchyPlugins.qml" >&2
    exit 1
fi

# Verify registration in BarWidgetCatalog.qml
grep -q '"omarchyPlugins"' "$PLUGIN_DIR/quickshell/Common/BarWidgetCatalog.qml" || {
    echo "FAIL: omarchyPlugins not registered in BarWidgetCatalog.qml" >&2
    exit 1
}

# Verify registration in BarWidgetDefaults.js
grep -q '"omarchyPlugins"' "$PLUGIN_DIR/quickshell/Common/settings/BarWidgetDefaults.js" || {
    echo "FAIL: omarchyPlugins not in default right widgets list in BarWidgetDefaults.js" >&2
    exit 1
}

# Verify registration in WidgetHost.qml
grep -q 'widgetId === "omarchyPlugins"' "$PLUGIN_DIR/quickshell/Modules/DBar/WidgetHost.qml" || {
    echo "FAIL: omarchyPlugins not handled in WidgetHost.qml" >&2
    exit 1
}

# Verify omarchy/qmldir exports the facade components
for f in "PluginBarFacade" "BarWidgetSlot" "OmarchyPluginService"; do
    grep -q "$f" "$PLUGIN_DIR/omarchy/qmldir" || {
        echo "FAIL: $f not registered in omarchy/qmldir" >&2
        exit 1
    }
done

echo "✓ Dual plugin integration verified in DBar catalog, defaults, and widget host"
echo "ALL TESTS PASSED for Task 6"
