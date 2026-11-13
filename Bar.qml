import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "./omarchy"
import "./quickshell"
import "./quickshell/Common"
import "./quickshell/DCommon/Common" as DC
import "./quickshell/Services"
import "./quickshell/Modals"
import "./quickshell/Modules"

PanelWindow {
    id: root

    property var pluginApi: null

    onPluginApiChanged: {
        if (root.pluginApi) {
            if (typeof OmarchyPluginService !== "undefined" && typeof OmarchyPluginService.init === "function") {
                OmarchyPluginService.init(root.pluginApi);
            }
        }
    }

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

    Component.onCompleted: {
        DC.Style.theme = Theme;
        DC.Style.settings = SettingsData;
        DC.I18n.backend = I18n;
        DC.Paths.backend = Paths;
        DC.Log.backend = Log;
        DC.Host.session = SessionService;
        DC.Host.cache = CacheData;
        DC.Host.files = FilesService;
        DC.Host.hyprlandFocusGrab = Qt.binding(() => CompositorService.useHyprlandFocusGrab);
        DC.Host.ownWindowDecorations = Qt.binding(() => SettingsData.floatingWindowTitleBars);
        Host.files = FilesService;
        Host.session = SessionService;
        Host.cache = CacheData;
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

    IpcHandler {
        target: "omadux"

        function toggle() {
            if (typeof ModalManager !== "undefined") {
                ModalManager.toggleDefault();
            }
        }

        function toggleLauncher() {
            if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleLauncher === "function") {
                PopoutService.toggleLauncher();
            } else if (typeof ModalManager !== "undefined" && typeof ModalManager.openLauncher === "function") {
                ModalManager.openLauncher();
            }
        }

        function launcher() {
            toggleLauncher();
        }

        function toggleControlCenter() {
            if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleControlCenter === "function") {
                PopoutService.toggleControlCenter();
            }
        }

        function controlCenter() {
            toggleControlCenter();
        }

        function emoji() {
            if (typeof ModalManager !== "undefined" && typeof ModalManager.openEmoji === "function") {
                ModalManager.openEmoji();
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
    }

    // 1. DMS daemon supervisor
    DmsProcess {
        id: dmsProcess
    }

    // 2. Handover baseline snapshot & restore watchdog
    Handover {
        id: handover
        pluginApi: root.pluginApi
    }

    // 3. Notification popups takeover (Mako DND)
    NotifHandover {
        id: notifHandover
        pluginApi: root.pluginApi
    }

    // 4. Volume / brightness OSD takeover (SwayOSD)
    OsdHandover {
        id: osdHandover
        pluginApi: root.pluginApi
    }

    // 5. Lock screen shim coordinator (~/.local/bin/omarchy-lock-screen)
    LockHandover {
        id: lockHandover
        pluginApi: root.pluginApi
    }

    // 6. Dynamic Hyprland keybind takeover
    KbService {
        id: kbService
        pluginApi: root.pluginApi
    }

    // 7. Omarchy colors.toml & wallpaper sync
    OmarchyThemeSync {
        id: omarchyThemeSync
    }

    // 8. DUX Shell Core & UI
    ShellCore {
        id: shellCore
    }

    DMSShell {
        id: dmsShell
        core: shellCore
        pluginApi: root.pluginApi
    }
}
