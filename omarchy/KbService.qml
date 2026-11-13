import QtQuick
import Quickshell
import Quickshell.Io
import "../quickshell/Common"

Item {
    id: root

    property var pluginApi: null
    onPluginApiChanged: if (pluginApi) applyBinds()

    readonly property bool enabled: typeof SettingsData === "undefined" || SettingsData.enableKeybindTakeover

    readonly property var takenBinds: [
        { mod: "SUPER", key: "Space", action: "launcher" },
        { mod: "SUPER_CTRL", key: "E", action: "emoji" },
        { mod: "SUPER_CTRL", key: "C", action: "clipboard" },
        { mod: "SUPER_ALT", key: "Space", action: "settings" },
        { mod: "SUPER", key: "Escape", action: "session" },
        { mod: "SUPER", key: "K", action: "keybinds" },
        { mod: "SUPER", key: "BackSpace", action: "dnd" },
        { mod: "SUPER", key: "M", action: "dashMedia" },
        { mod: "SUPER", key: "comma", action: "notifications" },
        { mod: "", key: "XF86AudioRaiseVolume", action: "volUp" },
        { mod: "", key: "XF86AudioLowerVolume", action: "volDown" },
        { mod: "", key: "XF86AudioMute", action: "volMute" },
        { mod: "", key: "XF86AudioMicMute", action: "micMute" },
        { mod: "", key: "XF86MonBrightnessUp", action: "briUp" },
        { mod: "", key: "XF86MonBrightnessDown", action: "briDown" }
    ]

    function applyBinds() {
        if (!root.enabled) return;
        const commands = [];
        for (let i = 0; i < takenBinds.length; i++) {
            const b = takenBinds[i];
            const mod = b.mod.length > 0 ? b.mod : "";
            // unbind old bind, bind to omadux IPC
            commands.push("keyword unbind " + (mod.length > 0 ? (mod + ", ") : ", ") + b.key);
            commands.push("keyword bind " + (mod.length > 0 ? (mod + ", ") : ", ") + b.key + ", exec, omarchy-shell ipc call plugin:y1506.omadux.bar " + b.action);
        }
        batchProc.command = ["hyprctl", "--batch", commands.join(";")];
        batchProc.running = true;
    }

    function removeBinds() {
        if (!root.enabled) return;
        const commands = [];
        for (let i = 0; i < takenBinds.length; i++) {
            const b = takenBinds[i];
            const mod = b.mod.length > 0 ? b.mod : "";
            commands.push("keyword unbind " + (mod.length > 0 ? (mod + ", ") : ", ") + b.key);
        }
        batchProc.command = ["hyprctl", "--batch", commands.join(";")];
        batchProc.running = true;
    }

    Process {
        id: batchProc
    }

    Component.onCompleted: applyBinds()
    Component.onDestruction: removeBinds()
}
