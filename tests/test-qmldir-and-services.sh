#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running QMLdir, DMSService, and First-Run Bypass Test Suite"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# 1. Test: Zero 0-byte qmldir files in quickshell or omarchy
echo "Checking for zero 0-byte qmldir files..."
empty_qmldirs=$(find "$REPO_DIR/quickshell" "$REPO_DIR/omarchy" -name "qmldir" -size 0 || true)
if [[ -n "$empty_qmldirs" ]]; then
    echo "FAIL: Found 0-byte qmldir files:" >&2
    echo "$empty_qmldirs" >&2
    exit 1
fi
echo "✓ Zero 0-byte qmldir files found"

# 2. Test: Critical Module & Modal qmldir exports
echo "Checking critical Module and Modal qmldir exports..."
for mod in "Modules/DBar:DBar 1.0 DBar.qml" \
           "Modules/Dock:Dock 1.0 Dock.qml" \
           "Modules/ControlCenter:ControlCenterPopout 1.0 ControlCenterPopout.qml" \
           "Modules/OSD:VolumeOSD 1.0 VolumeOSD.qml" \
           "Modules/Lock:Lock 1.0 Lock.qml" \
           "Modals/DLauncherV2:DLauncherV2Modal 1.0 DLauncherV2Modal.qml"; do
    dir="${mod%%:*}"
    entry="${mod##*:}"
    qfile="$REPO_DIR/quickshell/$dir/qmldir"
    if [[ ! -f "$qfile" ]]; then
        echo "FAIL: Missing qmldir at $qfile" >&2
        exit 1
    fi
    if ! grep -q "$entry" "$qfile"; then
        echo "FAIL: $qfile does not export '$entry'" >&2
        exit 1
    fi
done
echo "✓ Critical Module and Modal qmldir files export expected types"

# 3. Test: Bar.qml instantiates ShellCore and connects it to DMSShell
echo "Checking Bar.qml ShellCore instantiation..."
if ! grep -q "ShellCore" "$REPO_DIR/Bar.qml"; then
    echo "FAIL: Bar.qml does not instantiate ShellCore" >&2
    exit 1
fi
if ! grep -E -q "core:[[:space:]]*shellCore" "$REPO_DIR/Bar.qml"; then
    echo "FAIL: Bar.qml does not bind core to shellCore in DMSShell" >&2
    exit 1
fi
echo "✓ Bar.qml instantiates ShellCore and passes core reference to DMSShell"

# 4. Test: DMSService has dynamic socket discovery, reconnect(), and retry Timer
echo "Checking DMSService socket discovery and reconnection..."
dms_service="$REPO_DIR/quickshell/Services/DMSService.qml"
if ! grep -q "function reconnect()" "$dms_service"; then
    echo "FAIL: DMSService.qml is missing function reconnect()" >&2
    exit 1
fi
if ! grep -q "function findSocket()" "$dms_service"; then
    echo "FAIL: DMSService.qml is missing function findSocket()" >&2
    exit 1
fi
if ! grep -E -q "(connectTimer|retryTimer)" "$dms_service"; then
    echo "FAIL: DMSService.qml is missing auto-retry Timer" >&2
    exit 1
fi
echo "✓ DMSService dynamic socket discovery and reconnect() verified"

# 5. Test: dms binary PATH symlink in install.sh and uninstall.sh
echo "Checking dms binary PATH symlink..."
if ! grep -q "local/bin/dms" "$REPO_DIR/install.sh"; then
    echo "FAIL: install.sh does not symlink dms to ~/.local/bin/dms" >&2
    exit 1
fi
if ! grep -q "local/bin/dms" "$REPO_DIR/uninstall.sh"; then
    echo "FAIL: uninstall.sh does not remove ~/.local/bin/dms" >&2
    exit 1
fi
echo "✓ dms binary PATH symlink present in install.sh and uninstall.sh"

# 6. Test: First-run welcome wizard bypassed
echo "Checking first-run welcome wizard bypass..."
cache_data="$REPO_DIR/quickshell/Common/CacheData.qml"
if ! grep -q "property bool welcomeCompleted: true" "$cache_data"; then
    echo "FAIL: CacheData.qml does not have 'property bool welcomeCompleted: true'" >&2
    exit 1
fi
dms_shell="$REPO_DIR/quickshell/DMSShell.qml"
if grep -A 10 "id: greeterLoader" "$dms_shell" | grep -q "active = true"; then
    echo "FAIL: DMSShell.qml still auto-activates greeterLoader on Component.onCompleted" >&2
    exit 1
fi
echo "✓ First-run welcome wizard is bypassed by default"

echo "ALL TESTS PASSED for QMLdir, DMSService, and First-Run Bypass Suite"
