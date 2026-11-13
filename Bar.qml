import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Core
import qs.Ui
import "./omarchy"
import "./quickshell"
import "./quickshell/Common"
import "./quickshell/Services"
import "./quickshell/Modals"
import "./quickshell/Modules"

Item {
    id: root

    property var pluginApi: null

    // Anchor surface for Quattro bar loader contract
    PanelWindow {
        id: anchorSurface
        width: 1
        height: 1
        color: "transparent"
        visible: true
        anchors {
            top: true
            left: true
        }
        exclusionMode: ExclusionMode.Ignore
    }

    // Quattro & Omarchy CLI IPC Router
    IpcHandler {
        target: "plugin:y1506.omadux.bar"

        function toggle(): void {
            if (typeof ModalManager !== "undefined") {
                ModalManager.toggleDefault();
            }
        }

        function launcher(): void {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openLauncher === "function") {
                ModalManager.openLauncher();
            } else if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleLauncher === "function") {
                PopoutService.toggleLauncher();
            }
        }

        function emoji(): void {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openEmoji === "function") {
                ModalManager.openEmoji();
            } else {
                launcher();
            }
        }

        function clipboard(): void {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openClipboard === "function") {
                ModalManager.openClipboard();
            } else if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleClipboard === "function") {
                PopoutService.toggleClipboard();
            }
        }

        function settings(): void {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openSettings === "function") {
                ModalManager.openSettings();
            }
        }

        function session(): void {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openPowerMenu === "function") {
                ModalManager.openPowerMenu();
            }
        }

        function keybinds(): void {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openKeybinds === "function") {
                ModalManager.openKeybinds();
            }
        }

        function dnd(): void {
            if (typeof NotificationService !== "undefined") {
                NotificationService.dnd = !NotificationService.dnd;
            }
        }

        function notifications(): void {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openNotifications === "function") {
                ModalManager.openNotifications();
            } else if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleNotifications === "function") {
                PopoutService.toggleNotifications();
            }
        }

        function dash(): void {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openDash === "function") {
                ModalManager.openDash();
            }
        }

        function dashMedia(): void {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openDashMedia === "function") {
                ModalManager.openDashMedia();
            }
        }

        function lock(): void {
            if (typeof LockService !== "undefined" && typeof LockService.lockSession === "function") {
                LockService.lockSession();
            }
        }

        function unlock(): void {
            if (typeof LockService !== "undefined" && typeof LockService.unlockSession === "function") {
                LockService.unlockSession();
            }
        }

        function reloadTheme(): void {
            omarchyThemeSync.syncNow();
        }

        function volUp(): void {
            if (typeof AudioService !== "undefined" && typeof AudioService.increaseVolume === "function") {
                AudioService.increaseVolume();
            }
        }

        function volDown(): void {
            if (typeof AudioService !== "undefined" && typeof AudioService.decreaseVolume === "function") {
                AudioService.decreaseVolume();
            }
        }

        function volMute(): void {
            if (typeof AudioService !== "undefined" && typeof AudioService.toggleMute === "function") {
                AudioService.toggleMute();
            }
        }

        function micMute(): void {
            if (typeof AudioService !== "undefined" && typeof AudioService.toggleMicMute === "function") {
                AudioService.toggleMicMute();
            }
        }

        function briUp(): void {
            if (typeof BrightnessService !== "undefined" && typeof BrightnessService.increaseBrightness === "function") {
                BrightnessService.increaseBrightness();
            }
        }

        function briDown(): void {
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
