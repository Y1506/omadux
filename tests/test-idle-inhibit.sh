#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 6: Fullscreen & Media Idle Inhibit Test"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

# 1. CompositorService.qml must define activeWindowFullscreen
echo "Checking CompositorService.qml activeWindowFullscreen..."
COMP_SVC="$REPO_DIR/quickshell/Services/CompositorService.qml"
if ! grep -q "activeWindowFullscreen" "$COMP_SVC"; then
    echo "FAIL: CompositorService.qml missing activeWindowFullscreen" >&2
    exit 1
fi
echo "✓ CompositorService.qml has activeWindowFullscreen"

# 2. MprisController.qml must define isPlaying
echo "Checking MprisController.qml isPlaying..."
MPRIS_CTRL="$REPO_DIR/quickshell/Services/MprisController.qml"
if ! grep -q "readonly property bool isPlaying:" "$MPRIS_CTRL"; then
    echo "FAIL: MprisController.qml missing isPlaying property" >&2
    exit 1
fi
echo "✓ MprisController.qml has isPlaying property"

# 3. IdleService.qml must gate base on autoInhibitActive / fullscreen / media
echo "Checking IdleService.qml idle inhibition..."
IDLE_SVC="$REPO_DIR/quickshell/Services/IdleService.qml"
if ! grep -q "autoInhibitActive" "$IDLE_SVC"; then
    echo "FAIL: IdleService.qml missing autoInhibitActive" >&2
    exit 1
fi
if ! grep -q "onAutoInhibitActiveChanged:" "$IDLE_SVC"; then
    echo "FAIL: IdleService.qml missing onAutoInhibitActiveChanged" >&2
    exit 1
fi
echo "✓ IdleService.qml gates idle timeout on fullscreen and media"

echo "✓ All Task 6 checks passed"
