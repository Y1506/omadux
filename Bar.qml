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

    function doToggle() {
        if (typeof ModalManager !== "undefined") ModalManager.toggleDefault();
    }
    function doLauncher() {
        if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleLauncher === "function") {
            PopoutService.toggleLauncher();
        } else if (typeof ModalManager !== "undefined" && typeof ModalManager.openLauncher === "function") {
            ModalManager.openLauncher();
        }
    }
    function doControlCenter() {
        if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleControlCenter === "function") {
            PopoutService.toggleControlCenter();
        }
    }
    function doNotifications() {
        if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleNotificationCenter === "function") {
            PopoutService.toggleNotificationCenter();
        } else if (typeof ModalManager !== "undefined" && typeof ModalManager.openNotifications === "function") {
            ModalManager.openNotifications();
        }
    }
    function doSettings() {
        if (typeof ModalManager !== "undefined" && typeof ModalManager.openSettings === "function") {
            ModalManager.openSettings();
        }
    }
    function doClipboard() {
        if (typeof ModalManager !== "undefined" && typeof ModalManager.openClipboard === "function") {
            ModalManager.openClipboard();
        } else if (typeof PopoutService !== "undefined" && typeof PopoutService.toggleClipboard === "function") {
            PopoutService.toggleClipboard();
        }
    }
    function doEmoji() {
        if (typeof ModalManager !== "undefined" && typeof ModalManager.openEmoji === "function") {
            ModalManager.openEmoji();
        } else {
            doLauncher();
        }
    }
    function doSession() {
        if (typeof ModalManager !== "undefined" && typeof ModalManager.openPowerMenu === "function") {
            ModalManager.openPowerMenu();
        }
    }
    function doLock() {
        if (typeof LockService !== "undefined" && typeof LockService.lockSession === "function") {
            LockService.lockSession();
        } else if (typeof SessionService !== "undefined" && typeof SessionService.lock === "function") {
            SessionService.lock();
        } else if (typeof ShellCore !== "undefined" && typeof ShellCore.lock === "function") {
            ShellCore.lock();
        }
    }
    function doUnlock() {
        if (typeof LockService !== "undefined" && typeof LockService.unlockSession === "function") {
            LockService.unlockSession();
        }
    }
    function doKeybinds() {
        if (typeof ModalManager !== "undefined" && typeof ModalManager.openKeybinds === "function") {
            ModalManager.openKeybinds();
        }
    }
    function doDnd() {
        if (typeof NotificationService !== "undefined") {
            NotificationService.dnd = !NotificationService.dnd;
        }
    }
    function doDash() {
        if (typeof ModalManager !== "undefined" && typeof ModalManager.openDash === "function") {
            ModalManager.openDash();
        } else {
            doControlCenter();
        }
    }
    function doDashMedia() {
        if (typeof ModalManager !== "undefined" && typeof ModalManager.openDashMedia === "function") {
            ModalManager.openDashMedia();
        } else {
            doControlCenter();
        }
    }
    function doReloadTheme() {
        omarchyThemeSync.syncNow();
    }
    function doVolUp() {
        if (typeof AudioService !== "undefined" && typeof AudioService.increaseVolume === "function") {
            AudioService.increaseVolume();
        }
    }
    function doVolDown() {
        if (typeof AudioService !== "undefined" && typeof AudioService.decreaseVolume === "function") {
            AudioService.decreaseVolume();
        }
    }
    function doVolMute() {
        if (typeof AudioService !== "undefined" && typeof AudioService.toggleMute === "function") {
            AudioService.toggleMute();
        }
    }
    function doMicMute() {
        if (typeof AudioService !== "undefined" && typeof AudioService.toggleMicMute === "function") {
            AudioService.toggleMicMute();
        }
    }
    function doBriUp() {
        if (typeof BrightnessService !== "undefined" && typeof BrightnessService.increaseBrightness === "function") {
            BrightnessService.increaseBrightness();
        }
    }
    function doBriDown() {
        if (typeof BrightnessService !== "undefined" && typeof BrightnessService.decreaseBrightness === "function") {
            BrightnessService.decreaseBrightness();
        }
    }

    // Quattro & Omarchy CLI IPC Router
    IpcHandler {
        target: "plugin:y1506.omadux.bar"

        function toggle() { root.doToggle(); }
        function launcher() { root.doLauncher(); }
        function toggleLauncher() { root.doLauncher(); }
        function controlCenter() { root.doControlCenter(); }
        function toggleControlCenter() { root.doControlCenter(); }
        function notifications() { root.doNotifications(); }
        function toggleNotifications() { root.doNotifications(); }
        function settings() { root.doSettings(); }
        function toggleSettings() { root.doSettings(); }
        function clipboard() { root.doClipboard(); }
        function toggleClipboard() { root.doClipboard(); }
        function emoji() { root.doEmoji(); }
        function session() { root.doSession(); }
        function lock() { root.doLock(); }
        function unlock() { root.doUnlock(); }
        function keybinds() { root.doKeybinds(); }
        function dnd() { root.doDnd(); }
        function dash() { root.doDash(); }
        function dashMedia() { root.doDashMedia(); }
        function reloadTheme() { root.doReloadTheme(); }
        function volumeUp() { root.doVolUp(); }
        function volUp() { root.doVolUp(); }
        function volumeDown() { root.doVolDown(); }
        function volDown() { root.doVolDown(); }
        function volumeMute() { root.doVolMute(); }
        function volMute() { root.doVolMute(); }
        function micMute() { root.doMicMute(); }
        function brightnessUp() { root.doBriUp(); }
        function briUp() { root.doBriUp(); }
        function brightnessDown() { root.doBriDown(); }
        function briDown() { root.doBriDown(); }
        function dashboard() { root.doDash(); }
        function sidebar() { root.doNotifications(); }
        function utilities() { root.doControlCenter(); }
        function overview() { root.doLauncher(); }
    }

    IpcHandler {
        target: "omadux"

        function toggle() { root.doToggle(); }
        function launcher() { root.doLauncher(); }
        function toggleLauncher() { root.doLauncher(); }
        function controlCenter() { root.doControlCenter(); }
        function toggleControlCenter() { root.doControlCenter(); }
        function notifications() { root.doNotifications(); }
        function toggleNotifications() { root.doNotifications(); }
        function settings() { root.doSettings(); }
        function toggleSettings() { root.doSettings(); }
        function clipboard() { root.doClipboard(); }
        function toggleClipboard() { root.doClipboard(); }
        function emoji() { root.doEmoji(); }
        function session() { root.doSession(); }
        function lock() { root.doLock(); }
        function unlock() { root.doUnlock(); }
        function keybinds() { root.doKeybinds(); }
        function dnd() { root.doDnd(); }
        function dash() { root.doDash(); }
        function dashMedia() { root.doDashMedia(); }
        function reloadTheme() { root.doReloadTheme(); }
        function volumeUp() { root.doVolUp(); }
        function volUp() { root.doVolUp(); }
        function volumeDown() { root.doVolDown(); }
        function volDown() { root.doVolDown(); }
        function volumeMute() { root.doVolMute(); }
        function volMute() { root.doVolMute(); }
        function micMute() { root.doMicMute(); }
        function brightnessUp() { root.doBriUp(); }
        function briUp() { root.doBriUp(); }
        function brightnessDown() { root.doBriDown(); }
        function briDown() { root.doBriDown(); }
        function dashboard() { root.doDash(); }
        function sidebar() { root.doNotifications(); }
        function utilities() { root.doControlCenter(); }
        function overview() { root.doLauncher(); }
    }

    IpcHandler {
        target: "y1506.dux"

        function launcher() { root.doLauncher(); }
        function dashboard() { root.doDash(); }
        function dashboardTab(tab) {
            if (tab === "media") root.doDashMedia();
            else root.doDash();
        }
        function sidebar() { root.doNotifications(); }
        function utilities() { root.doControlCenter(); }
        function session() { root.doSession(); }
        function settings() { root.doSettings(); }
        function overview() { root.doLauncher(); }
        function menu() { root.doLauncher(); }
        function wallpapers() { root.doSettings(); }
        function themes() { root.doReloadTheme(); }
        function clipboard() { root.doClipboard(); }
        function barFocus() { root.doToggle(); }
        function popout(name) {
            if (name === "update") root.doSettings();
            else root.doControlCenter();
        }
        function display() { root.doSettings(); }
        function brightness(step) {
            if (typeof step === "string" && step.startsWith("-")) root.doBriDown();
            else root.doBriUp();
        }
        function windowInfo() {}
    }

    IpcHandler {
        target: "omacale"

        function launcher() { root.doLauncher(); }
        function dashboard() { root.doDash(); }
        function dashboardTab(tab) {
            if (tab === "media") root.doDashMedia();
            else root.doDash();
        }
        function sidebar() { root.doNotifications(); }
        function utilities() { root.doControlCenter(); }
        function session() { root.doSession(); }
        function settings() { root.doSettings(); }
        function overview() { root.doLauncher(); }
        function menu() { root.doLauncher(); }
        function wallpapers() { root.doSettings(); }
        function themes() { root.doReloadTheme(); }
        function clipboard() { root.doClipboard(); }
        function barFocus() { root.doToggle(); }
        function popout(name) {
            if (name === "update") root.doSettings();
            else root.doControlCenter();
        }
        function display() { root.doSettings(); }
        function brightness(step) {
            if (typeof step === "string" && step.startsWith("-")) root.doBriDown();
            else root.doBriUp();
        }
        function windowInfo() {}
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
