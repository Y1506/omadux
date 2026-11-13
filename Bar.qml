import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons
import "./omarchy"
import "./quickshell"
import "./quickshell/Common"
import "./quickshell/Services"
import "./quickshell/Modals"
import "./quickshell/Modules"

PanelWindow {
    id: root

    property var pluginApi: null

    WlrLayershell.namespace: "omadux-anchor"
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    mask: Region {}
    implicitWidth: 1
    implicitHeight: 1
    color: "transparent"
    visible: true
    anchors {
        top: true
        left: true
    }

    // Quattro & Omarchy CLI IPC Router
    IpcHandler {
        target: "plugin:y1506.omadux.bar"

        function toggle() {
            if (typeof ModalManager !== "undefined") {
                ModalManager.toggleDefault();
            }
        }

        function launcher() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openLauncher === "function") {
                ModalManager.openLauncher();
            } else if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleLauncher === "function") {
                PopoutService.toggleLauncher();
            }
        }

        function emoji() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openEmoji === "function") {
                ModalManager.openEmoji();
            } else {
                launcher();
            }
        }

        function clipboard() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openClipboard === "function") {
                ModalManager.openClipboard();
            } else if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleClipboard === "function") {
                PopoutService.toggleClipboard();
            }
        }

        function settings() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openSettings === "function") {
                ModalManager.openSettings();
            }
        }

        function session() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openPowerMenu === "function") {
                ModalManager.openPowerMenu();
            }
        }

        function keybinds() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openKeybinds === "function") {
                ModalManager.openKeybinds();
            }
        }

        function dnd() {
            if (typeof NotificationService !== "undefined") {
                NotificationService.dnd = !NotificationService.dnd;
            }
        }

        function notifications() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openNotifications === "function") {
                ModalManager.openNotifications();
            } else if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleNotifications === "function") {
                PopoutService.toggleNotifications();
            }
        }

        function dash() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openDash === "function") {
                ModalManager.openDash();
            }
        }

        function dashMedia() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openDashMedia === "function") {
                ModalManager.openDashMedia();
            }
        }

        function lock() {
            if (typeof LockService !== "undefined" && typeof LockService.lockSession === "function") {
                LockService.lockSession();
            }
        }

        function unlock() {
            if (typeof LockService !== "undefined" && typeof LockService.unlockSession === "function") {
                LockService.unlockSession();
            }
        }

        function reloadTheme() {
            omarchyThemeSync.syncNow();
        }

        function volUp() {
            if (typeof AudioService !== "undefined" && typeof AudioService.increaseVolume === "function") {
                AudioService.increaseVolume();
            }
        }

        function volDown() {
            if (typeof AudioService !== "undefined" && typeof AudioService.decreaseVolume === "function") {
                AudioService.decreaseVolume();
            }
        }

        function volMute() {
            if (typeof AudioService !== "undefined" && typeof AudioService.toggleMute === "function") {
                AudioService.toggleMute();
            }
        }

        function micMute() {
            if (typeof AudioService !== "undefined" && typeof AudioService.toggleMicMute === "function") {
                AudioService.toggleMicMute();
            }
        }

        function briUp() {
            if (typeof BrightnessService !== "undefined" && typeof BrightnessService.increaseBrightness === "function") {
                BrightnessService.increaseBrightness();
            }
        }

        function briDown() {
            if (typeof BrightnessService !== "undefined" && typeof BrightnessService.decreaseBrightness === "function") {
                BrightnessService.decreaseBrightness();
            }
        }
    }

    // 1. DMS daemon supervisor
    DmsProcess {
        id: dmsProcess
    }

    // 2. Handover baseline snapshot & restore watchdog
    Handover {
        id: handover
    }

    // 3. Notification popups takeover (Mako DND)
    NotifHandover {
        id: notifHandover
    }

    // 4. Volume / brightness OSD takeover (SwayOSD)
    OsdHandover {
        id: osdHandover
    }

    // 5. Lock screen shim coordinator (~/.local/bin/omarchy-lock-screen)
    LockHandover {
        id: lockHandover
    }

    // 6. Dynamic Hyprland keybind takeover
    KbService {
        id: kbService
    }

    // 7. Omarchy colors.toml & wallpaper sync
    OmarchyThemeSync {
        id: omarchyThemeSync
    }

    // 8. DUX Shell root item
    DMSShell {
        id: dmsShell
        pluginApi: root.pluginApi
    }
}
