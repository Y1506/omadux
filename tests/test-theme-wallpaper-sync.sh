#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 5: Matugen Integration & Theme/Wallpaper Sync Test"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# 1. Theme.qml must consider built-in dms matugen available
echo "Checking Theme.qml matugen availability..."
THEME_QML="$REPO_DIR/quickshell/Common/Theme.qml"
if grep -q 'command -v matugen"' "$THEME_QML"; then
    echo "FAIL: Theme.qml still has standalone-only 'command -v matugen' check" >&2
    exit 1
fi
echo "✓ Theme.qml recognizes built-in dms matugen"

# 2. OmarchyThemeSync.qml must sync wallpaper directory to backgrounds
echo "Checking OmarchyThemeSync.qml wallpaper directory sync..."
SYNC_QML="$REPO_DIR/omarchy/OmarchyThemeSync.qml"
if ! grep -q 'backgrounds' "$SYNC_QML"; then
    echo "FAIL: OmarchyThemeSync.qml does not reference ~/.config/omarchy/current/backgrounds" >&2
    exit 1
fi
if ! grep -q 'wallpaperFolders' "$SYNC_QML"; then
    echo "FAIL: OmarchyThemeSync.qml does not update SessionData.wallpaperFolders" >&2
    exit 1
fi
echo "✓ OmarchyThemeSync.qml syncs wallpaper directory"

# 3. ThemeColorsTab.qml must contain Omarchy Themes section with omarchy-theme-set
echo "Checking ThemeColorsTab.qml Omarchy themes section..."
TAB_QML="$REPO_DIR/quickshell/Modules/Settings/ThemeColorsTab.qml"
if ! grep -q 'Omarchy Themes' "$TAB_QML"; then
    echo "FAIL: ThemeColorsTab.qml missing Omarchy Themes card" >&2
    exit 1
fi
if ! grep -q 'omarchy-theme-set' "$TAB_QML"; then
    echo "FAIL: ThemeColorsTab.qml missing omarchy-theme-set invocation" >&2
    exit 1
fi
echo "✓ ThemeColorsTab.qml contains Omarchy Themes section"

echo "✓ All Task 5 checks passed"
