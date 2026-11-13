import QtQuick
import Quickshell.Wayland
import "../../Common"

FadeOverlayWindow {
    WlrLayershell.namespace: "dms:fade-to-lock"
    fadeEnabled: SettingsData.fadeToLockEnabled
    gracePeriod: SettingsData.fadeToLockGracePeriod
    holdsAfterCompletion: true
}
