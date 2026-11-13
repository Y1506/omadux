#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 2 QML Import & Namespace Verification Suite"

QUICKSHELL_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../quickshell" && pwd)"

if [[ ! -d "$QUICKSHELL_DIR" ]]; then
    echo "ERROR: quickshell directory not found at $QUICKSHELL_DIR" >&2
    exit 1
fi

# 1. Check for forbidden DUX qs.* imports
echo "Scanning for forbidden 'import qs.{Common,Services,DCommon,Widgets,Modals,Modules}'..."
forbidden_matches=$(grep -rnE "^[[:space:]]*import[[:space:]]+qs\.(Common|Services|DCommon|Widgets|Modals|Modules)" "$QUICKSHELL_DIR" --include="*.qml" || true)

if [[ -n "$forbidden_matches" ]]; then
    echo "FAIL: Found forbidden qs.* imports in quickshell tree:" >&2
    echo "$forbidden_matches" | head -30 >&2
    exit 1
fi
echo "✓ Zero forbidden qs.* imports found in quickshell tree"

# 2. Check that critical directories have valid qmldir files
required_qmldirs=(
    "Common"
    "Services"
    "DCommon"
    "DCommon/Widgets"
    "Widgets"
    "Modals/Common"
)

for sub in "${required_qmldirs[@]}"; do
    qfile="$QUICKSHELL_DIR/$sub/qmldir"
    if [[ ! -f "$qfile" ]]; then
        echo "FAIL: Missing qmldir at $qfile" >&2
        exit 1
    fi
    # Check that qmldir is not empty
    if [[ ! -s "$qfile" ]]; then
        echo "FAIL: Empty qmldir at $qfile" >&2
        exit 1
    fi
done
echo "✓ All required submodule qmldir files exist and are populated"

# 3. Check that DMSShell.qml root is an Item / Scope and not a standalone ShellRoot
if grep -q "ShellRoot" "$QUICKSHELL_DIR/DMSShell.qml"; then
    echo "FAIL: DMSShell.qml still contains ShellRoot" >&2
    exit 1
fi
echo "✓ DMSShell.qml root adapted for Quattro embedding"

echo "ALL TESTS PASSED for Task 2"
