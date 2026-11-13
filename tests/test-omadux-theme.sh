#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 5 Omarchy Theme Sync Verification Suite"

PLUGIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# Verify omadux script exists
if [[ ! -x "$PLUGIN_DIR/scripts/omadux" ]]; then
    echo "FAIL: scripts/omadux does not exist or is not executable" >&2
    exit 1
fi

# Verify omadux.lua exists
if [[ ! -f "$PLUGIN_DIR/omadux.lua" ]]; then
    echo "FAIL: omadux.lua does not exist" >&2
    exit 1
fi

# Verify OmarchyThemeSync.qml exists
if [[ ! -f "$PLUGIN_DIR/omarchy/OmarchyThemeSync.qml" ]]; then
    echo "FAIL: omarchy/OmarchyThemeSync.qml does not exist" >&2
    exit 1
fi

# Create a test colors.toml
TEST_DIR="/tmp/test-omadux-theme-$$"
mkdir -p "$TEST_DIR"
TEST_COLORS="$TEST_DIR/colors.toml"
TEST_BG="$TEST_DIR/background"
TEST_CACHE="$TEST_DIR/cache/DankMaterialShell"
mkdir -p "$TEST_CACHE"

cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

cat << 'EOF' > "$TEST_COLORS"
mode = "dark"
accent = "#f0913f"
selection = "#1c2f33"
muted = "#617877"
background = "#05090a"
dark_background = "#030607"
lighter_background = "#0e1719"
foreground = "#c3d2d0"
red = "#d2705c"
green = "#86a68f"
blue = "#8299aa"
yellow = "#c9a878"
EOF

echo "/usr/share/backgrounds/test.png" > "$TEST_BG"

# Run scripts/omadux sync with test paths
OMADUX_COLORS_PATH="$TEST_COLORS" OMADUX_BG_PATH="$TEST_BG" OMADUX_CACHE_DIR="$TEST_CACHE" "$PLUGIN_DIR/scripts/omadux" sync

THEME_OUT="$TEST_CACHE/omarchy-theme.json"
if [[ ! -f "$THEME_OUT" ]]; then
    echo "FAIL: scripts/omadux sync did not generate omarchy-theme.json at $THEME_OUT" >&2
    exit 1
fi

# Validate JSON schema and key colors
jq -e '.id == "omarchy-theme"' "$THEME_OUT" >/dev/null || { echo "FAIL: Missing or invalid theme id"; exit 1; }
jq -e '.dark.primary == "#f0913f"' "$THEME_OUT" >/dev/null || { echo "FAIL: dark.primary does not match accent"; exit 1; }
jq -e '.dark.background == "#05090a"' "$THEME_OUT" >/dev/null || { echo "FAIL: dark.background does not match background"; exit 1; }
jq -e '.dark.surface != null and .dark.surfaceContainer != null' "$THEME_OUT" >/dev/null || { echo "FAIL: missing surface container tokens"; exit 1; }

echo "✓ omarchy-theme.json generated and validated successfully"

# Verify enableExternalAppTheming is in SettingsData and SettingsSpec
grep -q "enableExternalAppTheming" "$PLUGIN_DIR/quickshell/Common/SettingsData.qml" || {
    echo "FAIL: enableExternalAppTheming not found in SettingsData.qml" >&2
    exit 1
}
grep -q "enableExternalAppTheming" "$PLUGIN_DIR/quickshell/Common/settings/SettingsSpec.js" || {
    echo "FAIL: enableExternalAppTheming not found in SettingsSpec.js" >&2
    exit 1
}
echo "✓ enableExternalAppTheming gated in SettingsData.qml & SettingsSpec.js"

echo "ALL TESTS PASSED for Task 5"
