#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 4: Omarchy Hyprland Keybindings Discovery Test"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DMS_BIN="$REPO_DIR/bin/dms"

if [[ ! -x "$DMS_BIN" ]]; then
    echo "FAIL: bin/dms does not exist or is not executable" >&2
    exit 1
fi

echo "Running dms keybinds show hyprland..."
output=$("$DMS_BIN" keybinds show hyprland)

echo "$output" | python3 -c "
import json, sys
data = json.load(sys.stdin)
binds = data.get('binds', {})
total_binds = sum(len(v) for v in binds.values())
print(f'Discovered {total_binds} keybinds across {len(binds)} categories')
if total_binds < 5:
    print(f'FAIL: Expected at least 5 keybinds on Omarchy system, got {total_binds}', file=sys.stderr)
    sys.exit(1)
"

echo "✓ Omarchy Hyprland keybind discovery succeeded!"
