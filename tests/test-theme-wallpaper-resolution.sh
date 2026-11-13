#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

echo "==> Running Task 1: Theme & Wallpaper Resolution Test"

cd "$REPO_ROOT"

# Test 1: Check OmarchyThemeSync.qml does NOT pass directory to setWallpaper or wallpaperPath
echo "Checking OmarchyThemeSync.qml wallpaper resolution..."
if grep -rn "setWallpaper(bgDir)" omarchy/OmarchyThemeSync.qml >/dev/null 2>&1; then
    echo "FAIL: OmarchyThemeSync.qml passes backgrounds directory to setWallpaper(bgDir)"
    exit 1
fi

# Ensure OmarchyThemeSync.qml resolves image file and sets wallpaperLastPath / wallpaperFolder
python3 -c '
with open("omarchy/OmarchyThemeSync.qml", "r") as f:
    content = f.read()

# Must not assign directory to currentWallpaper
if "currentWallpaper = bgDir" in content:
    print("FAIL: OmarchyThemeSync.qml assigns bgDir directly to currentWallpaper")
    exit(1)

# Must have logic to resolve real image file
if "background" not in content or "backgrounds" not in content:
    print("FAIL: OmarchyThemeSync.qml missing background/backgrounds handling")
    exit(1)

# Must check for image file extensions
if not any(ext in content for ext in [".png", ".jpg", ".webp"]):
    print("FAIL: OmarchyThemeSync.qml does not check for image extensions when resolving wallpaper")
    exit(1)
'

# Test 2: Verify dms matugen generate handles relative --shell-dir without failing
TEST_IMG="$HOME/.config/omarchy/themes/starsend/backgrounds/1-dune.webp"
if [[ -f "$TEST_IMG" ]]; then
    echo "Testing dms matugen generate with relative --shell-dir ./quickshell..."
    OUT=$("$REPO_ROOT/bin/dms" matugen generate \
        --state-dir /tmp/dms-state-test \
        --config-dir "$HOME/.config/dms" \
        --shell-dir "./quickshell" \
        --kind image \
        --value "$TEST_IMG" 2>&1 || true)

    if echo "$OUT" | grep -q "Theme generation failed"; then
        echo "FAIL: dms matugen failed with relative --shell-dir:"
        echo "$OUT"
        exit 1
    fi

    # Test 3: Verify dms matugen generate handles directory input gracefully
    echo "Testing dms matugen generate when given a directory path..."
    DIR_IMG="$HOME/.config/omarchy/themes/starsend/backgrounds"
    OUT_DIR=$("$REPO_ROOT/bin/dms" matugen generate \
        --state-dir /tmp/dms-state-test \
        --config-dir "$HOME/.config/dms" \
        --shell-dir "./quickshell" \
        --kind image \
        --value "$DIR_IMG" 2>&1 || true)

    if echo "$OUT_DIR" | grep -q "Theme generation failed"; then
        echo "FAIL: dms matugen failed when given directory path:"
        echo "$OUT_DIR"
        exit 1
    fi
fi

echo "✓ Task 1 tests passed!"
