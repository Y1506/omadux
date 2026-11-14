#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Test: Keybind Pop-Outs & IPC Routing ==="

FAILED=0

BAR_QML="Bar.qml"

# Check 1: doLauncher in Bar.qml calls toggleDankLauncherV2
if ! grep -A 10 "function doLauncher()" "$BAR_QML" | grep -q "toggleDankLauncherV2"; then
    echo "[FAIL] Bar.qml doLauncher() does not call PopoutService.toggleDankLauncherV2"
    FAILED=1
else
    echo "[PASS] Bar.qml doLauncher() calls PopoutService.toggleDankLauncherV2"
fi

# Check 2: doLauncher in Bar.qml does NOT call non-existent toggleLauncher or ModalManager.openLauncher
if grep -A 10 "function doLauncher()" "$BAR_QML" | grep -q "PopoutService\.toggleLauncher"; then
    echo "[FAIL] Bar.qml doLauncher() still calls non-existent PopoutService.toggleLauncher"
    FAILED=1
else
    echo "[PASS] Bar.qml doLauncher() does not call non-existent PopoutService.toggleLauncher"
fi

if grep -A 10 "function doLauncher()" "$BAR_QML" | grep -q "ModalManager\.openLauncher"; then
    echo "[FAIL] Bar.qml doLauncher() still calls non-existent ModalManager.openLauncher"
    FAILED=1
else
    echo "[PASS] Bar.qml doLauncher() does not call non-existent ModalManager.openLauncher"
fi

# Check 3: doControlCenter in Bar.qml passes focused screen fallback
if ! grep -A 10 "function doControlCenter()" "$BAR_QML" | grep -q "getFocusedScreen"; then
    echo "[FAIL] Bar.qml doControlCenter() does not pass focused screen fallback"
    FAILED=1
else
    echo "[PASS] Bar.qml doControlCenter() passes focused screen fallback"
fi

# Check 4: doNotifications in Bar.qml calls toggleNotificationCenter or openNotificationCenter with focused screen
if ! grep -A 10 "function doNotifications()" "$BAR_QML" | grep -q "getFocusedScreen"; then
    echo "[FAIL] Bar.qml doNotifications() does not pass focused screen fallback"
    FAILED=1
else
    echo "[PASS] Bar.qml doNotifications() passes focused screen fallback"
fi

# Check 5: doSettings in Bar.qml calls PopoutService.toggleSettings
if ! grep -A 10 "function doSettings()" "$BAR_QML" | grep -q "toggleSettings"; then
    echo "[FAIL] Bar.qml doSettings() does not call PopoutService.toggleSettings"
    FAILED=1
else
    echo "[PASS] Bar.qml doSettings() calls PopoutService.toggleSettings"
fi

# Check 6: doClipboard in Bar.qml calls PopoutService.toggleClipboardHistory
if ! grep -A 10 "function doClipboard()" "$BAR_QML" | grep -q "toggleClipboardHistory"; then
    echo "[FAIL] Bar.qml doClipboard() does not call PopoutService.toggleClipboardHistory"
    FAILED=1
else
    echo "[PASS] Bar.qml doClipboard() calls PopoutService.toggleClipboardHistory"
fi

# Check 7: doSession in Bar.qml calls PopoutService.togglePowerMenu
if ! grep -A 10 "function doSession()" "$BAR_QML" | grep -q "togglePowerMenu"; then
    echo "[FAIL] Bar.qml doSession() does not call PopoutService.togglePowerMenu"
    FAILED=1
else
    echo "[PASS] Bar.qml doSession() calls PopoutService.togglePowerMenu"
fi

# Check 8: Bar.qml registers handlers with IpcRegistry
if ! grep -q "IpcRegistry\.register" "$BAR_QML"; then
    echo "[FAIL] Bar.qml does not register IpcHandlers with IpcRegistry"
    FAILED=1
else
    echo "[PASS] Bar.qml registers IpcHandlers with IpcRegistry"
fi

# Check 9: DLauncherV2ModalHost.qml ensures screen fallback
if ! grep -A 10 "id: contentWindow" quickshell/Modals/DLauncherV2/DLauncherV2ModalHost.qml | grep -q "screen:"; then
    echo "[FAIL] DLauncherV2ModalHost.qml contentWindow does not declare screen fallback"
    FAILED=1
else
    echo "[PASS] DLauncherV2ModalHost.qml contentWindow declares screen fallback"
fi

# Check 10: DPopout.qml ensures screen fallback before opening/toggling
if ! grep -A 15 "function open()" quickshell/Widgets/DPopout.qml | grep -q "_ensureScreen"; then
    echo "[FAIL] DPopout.qml open() missing _ensureScreen"
    FAILED=1
else
    echo "[PASS] DPopout.qml open() calls _ensureScreen"
fi

if [ "$FAILED" -ne 0 ]; then
    echo "=== Keybind Pop-Outs & IPC Tests FAILED (RED) ==="
    exit 1
fi

echo "=== Keybind Pop-Outs & IPC Tests PASSED (GREEN) ==="
exit 0
