#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 1: Control Center Scope & widgets.js Verification"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# 1. Verify required imports in ControlCenter Components
echo "Checking imports in ControlCenter components..."
for comp in "Components/CcTileGrid.qml" "Components/QuickTilesGroup.qml" "Components/CcEditChrome.qml" "Components/CcTileSlot.qml"; do
    target="$REPO_DIR/quickshell/Modules/ControlCenter/$comp"
    if ! grep -q 'import "../../../Services"' "$target" && ! grep -q 'import "../../Services"' "$target"; then
        echo "FAIL: $comp is missing Services import" >&2
        exit 1
    fi
    if ! grep -q 'import "../../../Common"' "$target" && ! grep -q 'import "../../Common"' "$target"; then
        echo "FAIL: $comp is missing Common import" >&2
        exit 1
    fi
done
echo "✓ ControlCenter components import Common and Services"

# 2. Check widgets.js defensive scoping for singletons
echo "Checking widgets.js defensive scoping for singletons..."
WIDGETS_JS="$REPO_DIR/quickshell/Modules/ControlCenter/utils/widgets.js"

# In widgets.js, direct unguarded references to singletons must not cause ReferenceErrors.
# Run a node/qml test verifying widgets.js functions can be evaluated in isolated context
node - << 'EOF'
const fs = require('fs');
const code = fs.readFileSync('quickshell/Modules/ControlCenter/utils/widgets.js', 'utf8');

// Strip .import directives for pure JS evaluation
const sanitized = code.replace(/^\.import\s+.*$/gm, '// stripped import');

const ctx = {
    // Isolated context WITHOUT BatteryService, PowerProfileWatcher, DgopService, SettingsData, CcMetrics
    console: console
};

try {
    const vm = require('vm');
    vm.createContext(ctx);
    vm.runInContext(sanitized, ctx);

    // Call isShown with battery and diskUsage without crashing
    const shownBattery = ctx.isShown({ id: 'battery' });
    const shownDisk = ctx.isShown({ id: 'diskUsage' });
    const size = ctx.sizeSpec({ id: 'battery' }, 4);

    if (typeof shownBattery !== 'boolean' || typeof shownDisk !== 'boolean') {
        throw new Error('isShown did not return boolean');
    }
    if (!size || typeof size.step !== 'number') {
        throw new Error('sizeSpec did not return expected spec object');
    }
    console.log('Isolated JS scope evaluation succeeded: isShown and sizeSpec handled missing globals gracefully');
} catch (e) {
    console.error('FAIL: widgets.js threw in isolated scope:', e.message);
    process.exit(1);
}
EOF

echo "✓ widgets.js scope test passed"
