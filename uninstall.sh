#!/usr/bin/env bash
set -Eeuo pipefail

PLUGIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Uninstalling Omadux..."

# Restore compositor handovers
if [[ -f "$PLUGIN_DIR/scripts/handover.py" ]]; then
    python3 "$PLUGIN_DIR/scripts/handover.py" restore >/dev/null 2>&1 || true
fi

# Stop any running dms daemon instances associated with omadux
pkill -f "$PLUGIN_DIR/bin/dms run --session" >/dev/null 2>&1 || true

# Remove symlinks & hooks
rm -f "$HOME/.local/bin/omadux"
if [[ -L "$HOME/.local/bin/omarchy-lock-screen" ]]; then
    target=$(readlink -f "$HOME/.local/bin/omarchy-lock-screen" 2>/dev/null || true)
    if [[ "$target" == *"$PLUGIN_DIR"* ]]; then
        rm -f "$HOME/.local/bin/omarchy-lock-screen"
    fi
fi
rm -f "$HOME/.config/omarchy/hooks/theme-set.d/20-omadux.sh"

echo "✓ Omadux uninstalled cleanly."
